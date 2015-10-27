//
//  AIBubble.m
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIBubble.h"
#import "AIBuyerBubbleModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+HighlightedWebCache.h"
#import "Veris-Swift.h"
#import "TDImageColors.h"

#define kBigBubbleRate          0.4

#define kMiddleBubbleRate       0.3

#define kSmallBubbleRate        0.2


@interface AIBubble ()

@property (nonatomic, strong) AIBuyerBubbleModel *bubbleModel;


@end

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}


@implementation AIBubble



-(UIColor*)mostColor:(UIImage*)image{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        
        int offset = 4*x;
        
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        //[cls addObject:clr];
        
        
        
    }
    CGContextRelease(context);
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[2] intValue]/255.0f) blue:([MaxColor[1] intValue]/255.0f) alpha:1];
}


+ (CGFloat)bigBubbleRadius
{
    return 438  / 2.46 / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kBigBubbleRate / 2;
}

+ (CGFloat)midBubbleRadius
{
    return 292  / 2.46 / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kMiddleBubbleRate / 2;
}

+ (CGFloat)smaBubbleRadius
{
    return 194  / 2.46 / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kSmallBubbleRate / 2;
}


+ (CGFloat)tinyBubbleRadius
{
    return 78  / 2.46 / 2;
}


- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bubbleModel = [model copy];
    }
    
    return self;
}


- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model
{
    self = [super init];
    
    if (self) {
        _bubbleModel = [model copy];
   
        CGFloat size = model.bubbleSize*2;//[self bubbleRadiusByModel:_bubbleModel] * 2;
        _radius = size / 2;

        self.frame = CGRectMake(0, 0, size, size);
        self.center = center;
        
        UIPopView * popView = [UIPopView currentView];
        [popView fillDataWithModel:_bubbleModel];
        [self addSubview:popView];
        double BridNum = size / popView.width;
        popView.transform =  CGAffineTransformMakeScale(BridNum, BridNum);
//        popView.frame = self.bounds;
        popView.center = CGPointMake(self.width/2, self.height/2);
        self.layer.cornerRadius = size / 2;
        self.layer.borderWidth = 2;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self setNeedsDisplay];
        //popView.firstImageView.image
//        UIColor * color = [self mostColor:[UIColor grayColor].imageWithColor];
//        UIColor * colorImage = [self mostColor:popView.firstImageView.image];
        AIBuyerBubbleProportModel * modelChild = model.service_list.firstObject;
        
        // NEW CREATE NEW IMAGEVIEW.
        __weak typeof(self) weakSelf = self;
        UIImageView * imageview = [[UIImageView alloc] init];
        [imageview sd_setHighlightedImageWithURL:[NSURL URLWithString:modelChild.service_thumbnail_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//  第一种解决方式:
//            dispatch_group_t group = dispatch_group_create();
//            
//            dispatch_group_enter(group);
//            
//            TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:image count:2];
//            dispatch_group_leave(group);
//            
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                UIColor *color = imageColors.colors.lastObject;
//                self.backgroundColor = color;
//            });
            
//  第二种解决方式:
            // UPDATE UI...
            dispatch_async(dispatch_get_main_queue(), ^{
                TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:image count:3];
                UIColor *color = imageColors.colors.lastObject;
                weakSelf.backgroundColor = color;
                //self.layer.borderColor = popView.firstImageView.image.pickImageEffectColor.CGColor;
            });
        }];
        
    }
    
    return self;
}


- (void) refereshBackground:(UIColor *) color{
    self.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
    
    //[self setNeedsDisplay];
}

// fake image


- (UIImage *)randomImage
{
    NSInteger random = arc4random() % 5 + 1;
    
    NSString *name = [NSString stringWithFormat:@"Bubble0%ld.png", (long)random];
    
    return [UIImage imageNamed:name];
    
}


#pragma mark - Calculate Bubble Size 

- (CGFloat)bubbleRadiusByModel:(AIBuyerBubbleModel *)model
{
    
    CGFloat maxSize = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    CGFloat size = maxSize * kBigBubbleRate / 2;
    
    NSInteger i = arc4random() % 3;
    
    if (model) {
        i = 3;
    }
    
    switch (i) {
            
        case 0:
            size = [AIBubble tinyBubbleRadius];//maxSize * kSmallBubbleRate / 2;
            break;
        case 1:
            size = [AIBubble smaBubbleRadius];//maxSize * kSmallBubbleRate / 2;
            break;
        case 2:
            size = [AIBubble midBubbleRadius];//maxSize * kMiddleBubbleRate / 2;
            break;
        case 3:
            size = [AIBubble bigBubbleRadius];//maxSize * kBigBubbleRate / 2;
            break;
            
        default:
            break;
    }
    
    return model.bubbleSize;
}


#pragma mark - SubViews

- (void)makeSubViews
{
    
}




@end
