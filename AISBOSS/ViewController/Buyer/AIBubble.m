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
#import "AITools.h"
#import "MDCSpotlightView.h"


#define kBigBubbleRate          0.4

#define kMiddleBubbleRate       0.3

#define kSmallBubbleRate        0.2


typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;


@interface AIBubble ()



@end


@implementation AIBubble
@synthesize glowOffset = _glowOffset;
@synthesize glowAmount = _glowAmount;
@synthesize glowColor = _glowColor;


- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bubbleModel = [model copy];
    }
    
    return self;
}

/**
 *  @author tinkl, 15-10-27 19:10:54
 *
 *  @brief  INIT
 *
 */
- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model type:(BubbleType) type
{
    self = [super init];
    
    if (self) {
        
        _bubbleModel = [model copy];
        _bubbleType = type;
        if (model.service_id > 0) {
            self.hasSmallBubble = YES;
        }else{
            self.hasSmallBubble = NO;
        }
        
        switch (type) {
            case typeToAdd:
            {
                [self initWithAdd:center];
            }
                break;
            case typeToNormal:
            {
                [self initWithNormal:center model:model];
                
            }
                break;
            case typeToSignIcon:
            {
                [self initWithSignIcon:center model:model];
            }
                break;
                
            default:
                break;
        }      
    }
    
    return self;
}


- (void) initWithSignIcon:(CGPoint)center model:(AIBuyerBubbleModel *)model{
    
    int width = [AIBubble tinyBubbleRadius] * 2;
    
    self.frame = CGRectMake(0, 0, width, width);
    self.center = center;
    
    _radius = width / 2;
    //背景
    self.rotateImageView = [[UIImageView alloc] init];
    self.rotateImageView.frame = self.frame;
    self.rotateImageView.alpha = 0.5;
    self.rotateImageView.center =  CGPointMake(self.width/2, self.height/2);
    [self addSubview:self.rotateImageView];

    
    CALayer* _contentLayer = [CALayer layer];
    _contentLayer.frame = self.bounds;
    _contentLayer.contents = (id)[UIImage imageNamed:@"recommandPlackholder"].CGImage;
    self.rotateImageView.layer.mask = _contentLayer;
    self.rotateImageView.layer.masksToBounds = YES;
    self.rotateImageView.clipsToBounds = YES;

    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.frame = self.frame;
    imageview.alpha = 0.5;
    imageview.center =  CGPointMake(self.width/2, self.height/2);
    //[self addSubview:imageview];
    
    //add it directly to our view's layer
//    CALayer* _contentLayer = [CALayer layer];
//    _contentLayer.frame = CGRectMake(-2, -2, 78/3+5, 88/3+3);
//    _contentLayer.contents = (id)[UIImage imageNamed:@"recommandPlackholder"].CGImage;
//    imageview.layer.mask = _contentLayer;
    //center the image
   
//    imageview.layer.masksToBounds = YES;
//    imageview.clipsToBounds = YES;


    {
        // 不规则图
        UIImageView * imageview2 = [[UIImageView alloc] init];
        imageview2.frame = CGRectMake(0, 0, 96/3, 104/3);
        imageview2.center =  CGPointMake(self.width/2, self.height/2);
        [self addSubview:imageview2];
        imageview2.image = [UIImage imageNamed:@"recommandPlackholder"];
    }
    {
        //图标
        UIImageView * imageviewIcon = [[UIImageView alloc] init];
        imageviewIcon.frame = CGRectMake(0, 0, 42/3, 42/3);
        imageviewIcon.center =  CGPointMake(self.width/2, self.height/2);
        [self addSubview:imageviewIcon];
        imageviewIcon.image = [UIImage imageNamed:@"recommandIcon"];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:[UIImage imageNamed:@"Bubble01"] count:3];
        
        NSArray * array = [NSArray arrayWithObjects:imageColors.colors.lastObject, imageColors.colors[1],nil];
        UIColor *color = imageColors.colors[1];
        weakSelf.layer.borderColor = color.CGColor;
        
        weakSelf.rotateImageView.image = [weakSelf buttonImageFromColors:array frame:weakSelf.rotateImageView.frame];
        
        
    });
    
}

- (void) initWithAdd:(CGPoint)center{
    
    int width = [AIBubble smaBubbleRadius]*2;//56.0;
    
    self.frame = CGRectMake(0, 0, width, width);
    self.center = center;
    
    _radius = width / 2;
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [button setImage:[UIImage imageNamed:@"addbubble"] forState:UIControlStateNormal];
    button.center =  CGPointMake(self.width/2, self.height/2);
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    [self setNeedsDisplay];
    
    
}

- (IBAction)addAction:(id)sender{
    
}

/**
 *  @author tinkl, 15-10-27 18:10:31
 *
 *  @brief  normal model
 *
 */
- (void) initWithNormal:(CGPoint)center model:(AIBuyerBubbleModel *)model{
    CGFloat size = model.bubbleSize*2;//[self bubbleRadiusByModel:_bubbleModel] * 2;
    _radius = size / 2;
    
    self.frame = CGRectMake(0, 0, size, size);
    self.center = center;
    
    //根据发光效果添加图层
    /*{
        MDCSpotlightView *focalPointView = [[MDCSpotlightView alloc] initWithFocalView:self];
        [self addSubview:focalPointView];
        
        focalPointView.bgColor= [UIColor groupTableViewBackgroundColor];
        focalPointView.frame = CGRectMake(0, 0, size + 30, size + 30);
        focalPointView.center = CGPointMake(self.width/2, self.height/2);
        focalPointView.backgroundColor = [UIColor greenColor];
        focalPointView.layer.cornerRadius = focalPointView.frame.size.width/2;
        focalPointView.layer.masksToBounds  = YES;
        [focalPointView setNeedsDisplay];
        focalPointView.alpha = 0.1;
    }*/
    
    //背景
    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.frame = self.frame;
    imageview.alpha = 0.5;
    imageview.center =  CGPointMake(self.width/2, self.height/2);
    [self addSubview:imageview];
    
    UIPopView * popView = [UIPopView currentView];
    [popView fillDataWithModel:_bubbleModel];
    [self addSubview:popView];
    
    double BridNum = size / popView.width;
    popView.transform =  CGAffineTransformMakeScale(BridNum, BridNum);
    popView.center = CGPointMake(self.width/2, self.height/2);
    self.layer.cornerRadius = size / 2;
    self.layer.borderWidth = 1.5;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;

    [self setNeedsDisplay];
    
    AIBuyerBubbleProportModel * modelChild = model.service_list.firstObject;
    
    // NEW CREATE NEW IMAGEVIEW.
    __weak typeof(self) weakSelf = self;
    
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
            
            NSArray * array = [NSArray arrayWithObjects:imageColors.colors.lastObject, imageColors.colors[1],nil];
            //                [imageColors.colors.lastObject]
            UIColor *color = imageColors.colors.lastObject;
            //                self.backgroundColor = color;
            weakSelf.layer.borderColor = color.CGColor;
            
            imageview.image = [weakSelf buttonImageFromColors:array frame:imageview.frame];
            //self.layer.borderColor = popView.firstImageView.image.pickImageEffectColor.CGColor;
            
            // Settings Shadow.
            
            
            //Create the gradient and add it to our view's root layer
//            colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//            self.glowOffset = CGSizeMake(0.0, 0.0);
//            self.glowAmount = 0.0;
//            self.glowColor = [UIColor clearColor];
            
//            CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//            gradientLayer.frame =  (CGRect){CGPointZero, CGSizeMake(weakSelf.width, weakSelf.width)};
//            gradientLayer.position = weakSelf.center;
//            [weakSelf.layer addSublayer:gradientLayer];
//            [gradientLayer setColors:[NSArray arrayWithObjects:(id)color.CGColor,(id)[UIColor grayColor].CGColor, nil]];
            
        });
    }];
    
}


- (void) refereshBackground:(UIColor *) color{
    self.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
    
    //[self setNeedsDisplay];
}

#pragma mark - Glow..
- (void)setGlowColor:(UIColor *)newGlowColor
{
    if (newGlowColor != glowColor) {
        CGColorRelease(glowColorRef);
        glowColor = newGlowColor;
        glowColorRef = CGColorCreate(colorSpaceRef, CGColorGetComponents(glowColor.CGColor));
    }
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




/**
 *  @author tinkl, 15-10-27 17:10:29
 *
 *  @brief  渐变颜色处理
 *
 */
- (UIImage*) buttonImageFromColors:(NSArray*)colors frame:(CGRect) newFrame{
    GradientType gradientType = topToBottom;
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(newFrame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, newFrame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(newFrame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(newFrame.size.width, newFrame.size.height);
            break;
        case 3:
            start = CGPointMake(newFrame.size.width, 0.0);
            end = CGPointMake(0.0, newFrame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    //CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (CGFloat)bigBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:438] / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kBigBubbleRate / 2;
}

+ (CGFloat)midBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:292] / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kMiddleBubbleRate / 2;
}

+ (CGFloat)smaBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:194] / 2;//CGRectGetWidth([UIScreen mainScreen].bounds) * kSmallBubbleRate / 2;
}


+ (CGFloat)tinyBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:88] / 2;
}

/*
-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, self.glowOffset, self.glowAmount);
    CGContextSetShadowWithColor(context, self.glowOffset, self.glowAmount, glowColorRef);
    
    [super drawRect:rect];
    
    CGContextRestoreGState(context);
}
*/


@end
