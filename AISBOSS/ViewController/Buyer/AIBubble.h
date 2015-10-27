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

//圆角
@property (nonatomic) CGFloat radius;
//类型
@property (nonatomic) BubbleType bubbleType;
//是否发光
@property (nonatomic) CGFloat isLight;


+ (CGFloat)bigBubbleRadius;

+ (CGFloat)midBubbleRadius;

+ (CGFloat)smaBubbleRadius;

+ (CGFloat)tinyBubbleRadius;

- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model;

- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model type:(BubbleType) type;


@end
