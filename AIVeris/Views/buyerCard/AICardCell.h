//
//  AICardCell.h
//  MessageList
//
//  Created by 王坜 on 15/7/19.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"


typedef NS_ENUM(NSInteger, AICardPosition){
    AICardPositionNormal,
    AICardPositionAtFirst,
    AICardPositionAtLast,
    AICardPositionAtMiddle,
};

#define kCell_HyperText         @"HyperText"

#define kCell_HyperKeys         @"HyperKeys"

#define kCell_IndicatorColor    @"IndicatorColor"

#define kCell_IndicatorImage    @"IndicatorImage"

@interface AICardCell : UIView<OHAttributedLabelDelegate>

@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, strong) UIImage *indicatorImage;

@property (nonatomic, assign) BOOL shouldShowTopLine;

@property (nonatomic, assign) BOOL shouldShowBottomLine;

@property (nonatomic, strong) NSArray *hyperLinkArray;

- (id)initWithFrame:(CGRect)frame hyperlinkText:(NSString *)hyperlinkText;

- (id)initWithFrame:(CGRect)frame content:(NSDictionary *)content position:(AICardPosition)position;


@end