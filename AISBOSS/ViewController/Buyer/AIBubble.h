//
//  AIBubble.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum  {
    
    typeToNormal = 0,
    typeToSignIcon = 1,//
    typeToAdd = 2//
    
}BubbleType;

@class AIBuyerBubbleModel;
@interface AIBubble : UIView
{
    CGColorSpaceRef colorSpaceRef;
    CGColorRef glowColorRef;
}
@property (nonatomic) BOOL hadRecommend;

@property (nonatomic) CGFloat radius;
//类型
@property (nonatomic) BubbleType bubbleType;
//是否发光
@property (nonatomic) CGFloat isLight;
//是否周边有小气泡标识
@property (nonatomic) BOOL hasSmallBubble;


@property (nonatomic) CGSize glowOffset;

@property (nonatomic) CGFloat glowAmount;

@property (nonatomic, strong) UIColor *glowColor;

@property (nonatomic, strong) UIImageView *rotateImageView;

@property (nonatomic, strong) AIBuyerBubbleModel *bubbleModel;


+ (CGFloat)bigBubbleRadius;

+ (CGFloat)midBubbleRadius;

+ (CGFloat)smaBubbleRadius;

+ (CGFloat)tinyBubbleRadius;

- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model;

- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model type:(BubbleType) type;


@end
