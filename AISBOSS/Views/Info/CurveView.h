//
//  CavasLineView.h
//  DataStructure
//
//  Created by 王坜 on 15/7/8.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CurveModel.h"
#import "BubbleView.h"

#define kStartPointKey  @"StartPoint"
#define kEndPointKey    @"EndPoint"





@protocol CurveViewDelegate <NSObject>

- (void)curveViewDidDeleteBubble:(CurveModel *)bubbleModel;

@end


@interface CurveView : UIView<BubbleViewDelegate>

@property (nonatomic, weak) id<CurveViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *displayModels;

@property (nonatomic, strong) NSMutableDictionary *bubbleCompareModels;

- (id)initWithFrame:(CGRect)frame points:(NSArray *)points;

- (void)startEdit;

- (void)endEdit;

- (void)undoDeleteWithModel:(CurveModel *)model;

- (void)undoAddWithModel:(CurveModel *)model;

- (void)addBubbleWithModel:(CurveModel *)model;

- (void)undoAddWithTitle:(NSString *)title;


@end
