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

#define kDefaultAlpha           0.9

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


@property (strong, nonatomic) NSTimer *timer;
@end


@implementation AIBubble

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
            self.hadRecommend = YES;
            self.hasSmallBubble = YES;
        }else{
            self.hadRecommend = NO;
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
    self.rotateImageView.alpha = kDefaultAlpha;
    self.rotateImageView.center =  CGPointMake(self.width/2, self.height/2);
    //[self addSubview:self.rotateImageView];

    
    CALayer* _contentLayer = [CALayer layer];
    _contentLayer.frame = self.bounds;
    _contentLayer.contents = (id)[UIImage imageNamed:@"recommandPlackholder"].CGImage;
    self.rotateImageView.layer.mask = _contentLayer;
    self.rotateImageView.layer.masksToBounds = YES;
    self.rotateImageView.clipsToBounds = YES;

    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.frame = self.frame;
    imageview.alpha = kDefaultAlpha;
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
        self.rotateBubleImageView = imageview2;
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
    int size =  width;
    self.frame = CGRectMake(0, 0, width, width);
    self.center = center;
    _radius = width / 2;
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [button setImage:[UIImage imageNamed:@"addbubble"] forState:UIControlStateNormal];
    button.center =  CGPointMake(self.width/2, self.height/2);
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
//    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
//    [self setNeedsDisplay];
    
    //处理发光效果
    
    {
        MDCSpotlightView *focalPointView = [[MDCSpotlightView alloc] initWithFocalView:self];
        focalPointView.bgColor= [UIColor whiteColor];
        focalPointView.frame = CGRectMake(0, 0, size + 13, size + 13);
        focalPointView.center = CGPointMake(self.width/2, self.height/2);
        focalPointView.layer.cornerRadius = focalPointView.frame.size.width/2;
        focalPointView.layer.masksToBounds  = YES;
        [focalPointView setNeedsDisplay];
        [self insertSubview:focalPointView atIndex:0];
        focalPointView.alpha = kDefaultAlpha;
        
        
        //定时器
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(TimerEvent)
                                                    userInfo:@{@"focalPointView":focalPointView}
                                                     repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:self.timer  forMode:NSDefaultRunLoopMode];
        
    }
    
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
    
    
    //背景
    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.frame = self.frame;
    imageview.alpha = kDefaultAlpha;
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
            UIColor *color = imageColors.colors.lastObject;
            //处理颜色 鲜艳度
            
            const CGFloat *cs = CGColorGetComponents(color.CGColor);
            CGFloat red = cs[0] ;   //CGFloat(cs[0]);
            CGFloat green = cs[1];  //CGFloat(cs[1]);
            CGFloat blue =cs[2];    //CGFloat(cs[2]);
            CGFloat colorHold = 0.2;
            UIColor * newColor = [UIColor colorWithRed:red+colorHold green:green+colorHold blue:blue+colorHold alpha:1];
            weakSelf.layer.borderColor = newColor.CGColor;
            
            imageview.alpha=0.1;
            imageview.image = [weakSelf buttonImageFromColors:array frame:imageview.frame];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:(0.5)];
            [imageview setNeedsDisplay];
            imageview.alpha = kDefaultAlpha;
            [UIView commitAnimations];
            
            if (model.proposal_id_new > 0){
                //根据发光效果添加图层
                {
                    //weakSelf.hidden = YES;
                    MDCSpotlightView *focalPointView = [[MDCSpotlightView alloc] initWithFocalView:weakSelf];
                    focalPointView.bgColor= color;
                    focalPointView.frame = CGRectMake(0, 0, size + 16, size + 16);
                    focalPointView.center = CGPointMake(weakSelf.width/2, weakSelf.height/2);
                    focalPointView.layer.cornerRadius = focalPointView.frame.size.width/2;
                    focalPointView.layer.masksToBounds  = YES;
                    [focalPointView setNeedsDisplay];
                    [weakSelf.superview insertSubview:focalPointView atIndex:0];
                    focalPointView.alpha = 0.5;
                    
                    
                    //定时器
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                  target:self
                                                                selector:@selector(TimerEvent)
                                                                userInfo:@{@"focalPointView":focalPointView}
                                                                 repeats:YES];
                    
                    [[NSRunLoop currentRunLoop]addTimer:self.timer  forMode:NSDefaultRunLoopMode];
                    
                }
            }
            
            
        });
    }];
    
}

- (void)TimerEvent
{
    MDCSpotlightView *focalPointView = self.timer.userInfo[@"focalPointView"];
    
    if (focalPointView != nil) {
        CGFloat alpha = focalPointView.alpha;
        if ( alpha == 0.5) {
            [UIView animateWithDuration:0.8 animations:^{
                focalPointView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.8 animations:^{
                focalPointView.alpha = 0.5;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
    
}



- (void) refereshBackground:(UIColor *) color{
    self.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
    
    //[self setNeedsDisplay];
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
    return [AITools displaySizeFrom1080DesignSize:438] / 2;
}

+ (CGFloat)midBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:292] / 2;
}

+ (CGFloat)smaBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:194] / 2;
}


+ (CGFloat)tinyBubbleRadius
{
    return [AITools displaySizeFrom1080DesignSize:88] / 2;
}

@end
