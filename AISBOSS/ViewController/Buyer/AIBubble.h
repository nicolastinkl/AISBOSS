//
//  AIBubble.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AIBuyerBubbleModel;
@interface AIBubble : UIView

+ (CGFloat)bigBubbleRadius;

+ (CGFloat)midBubbleRadius;

+ (CGFloat)smaBubbleRadius;

- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model;

- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model;


@end
