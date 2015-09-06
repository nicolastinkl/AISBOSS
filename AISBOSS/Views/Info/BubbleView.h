//
//  BubbleView.h
//  DataStructure
//
//  Created by 王坜 on 15/7/9.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBubbleShouldShowDeleteButtonNotification  @"BubbleShouldShowDeleteButtonNotification"
#define kBubbleShouldHideDeleteButtonNotification  @"BubbleShouldHideDeleteButtonNotification"

@class CurveModel;


@protocol BubbleViewDelegate <NSObject>

- (void)bubbleViewDidDeleteBubble:(CurveModel *)bubbleModel;

@end


@interface BubbleView : UIView

@property (nonatomic, weak) id<BubbleViewDelegate> delegate;
@property (nonatomic, weak) UIView *linkedPointView;
@property (nonatomic, weak) CAShapeLayer *linkedLineLayer;

- (id)initWithFrame:(CGRect)frame model:(CurveModel *)model;

- (void)shouldDisppear;

-(void) removeAllObserver;

@end
