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

#define kBigBubbleRate          0.4

#define kMiddleBubbleRate       0.3

#define kSmallBubbleRate        0.2


@interface AIBubble ()

@property (nonatomic, strong) AIBuyerBubbleModel *bubbleModel;


@end


@implementation AIBubble


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
        NSLog(@"%f",size);
        self.frame = CGRectMake(0, 0, size, size);
        self.center = center;
        
        UIPopView * popView = [UIPopView currentView];
        [popView fillDataWithModel:_bubbleModel];
//        popView.frame = self.bounds;
        popView.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:popView];
        self.backgroundColor = popView.firstImageView.image.pickImageDeepColor;
        self.layer.borderColor = popView.firstImageView.image.pickImageEffectColor.CGColor;
        self.layer.cornerRadius = size / 2;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;        
    }
    
    return self;
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
