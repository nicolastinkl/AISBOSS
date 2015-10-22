//
//  AIBubble.m
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIBubble.h"
#import "AIBuyerBubbleModel.h"

#define kBigBubbleRate          0.4

#define kMiddleBubbleRate       0.3

#define kSmallBubbleRate        0.2


@interface AIBubble ()

@property (nonatomic, strong) AIBuyerBubbleModel *bubbleModel;

@end


@implementation AIBubble


+ (CGFloat)bigBubbleRadius
{
    return CGRectGetWidth([UIScreen mainScreen].bounds) * kBigBubbleRate / 2;
}

+ (CGFloat)midBubbleRadius
{
    return CGRectGetWidth([UIScreen mainScreen].bounds) * kMiddleBubbleRate / 2;
}

+ (CGFloat)smaBubbleRadius
{
    return CGRectGetWidth([UIScreen mainScreen].bounds) * kSmallBubbleRate / 2;
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
        CGFloat size = [self bubbleRadiusByModel:_bubbleModel];
        self.frame = CGRectMake(0, 0, size, size);
        self.center = center;
        self.layer.cornerRadius = size / 2;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor redColor];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}


#pragma mark - Calculate Bubble Size 

- (CGFloat)bubbleRadiusByModel:(AIBuyerBubbleModel *)model
{
    
    CGFloat maxSize = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    CGFloat size = maxSize * kBigBubbleRate / 2;
    
    switch (model.bubbleSize) {
        case 1:
            size = maxSize * kSmallBubbleRate / 2;
            break;
        case 2:
            size = maxSize * kMiddleBubbleRate / 2;
            break;
        case 3:
            size = maxSize * kBigBubbleRate / 2;
            break;
            
        default:
            break;
    }
    
    return size;
}






@end
