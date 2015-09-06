//
//  CurveModel.h
//  DataStructure
//
//  Created by 王坜 on 15/7/14.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CurveModel : NSObject

@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) CGFloat endX;
@property (nonatomic, assign) CGFloat endY;

@property (nonatomic, strong) UIColor *strokeColor;    // 线条颜色
@property (nonatomic, strong) UIColor *displayColor;   // 圆形区域颜色

@property (nonatomic, assign) CGFloat strokeWidth;     // 线条的宽度      默认1
@property (nonatomic, assign) CGFloat displayWidth;    // 圆形区域的直径

@property (nonatomic, assign) CGFloat control1X;       // 可选
@property (nonatomic, assign) CGFloat control1Y;       // 可选
@property (nonatomic, assign) CGFloat control2X;       // 可选
@property (nonatomic, assign) CGFloat control2Y;       // 可选
@property (nonatomic, assign) CGFloat animationDuration;       // 可选 默认1秒


@property (nonatomic, assign) CGFloat relevancy;          // 相关度

@property (nonatomic, strong) NSString *displayTitle;     // 描述

@end