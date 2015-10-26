//
//  UIImage+Effect.h
//  AITrans
//
//  Created by admin on 6/26/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Effect)

/**
 *  @author tinkl, 15-10-26 11:10:27
 *
 *  @brief  图片模糊处理  模糊等级
 *
 */
- (UIImage *)blurryImagewithBlurLevel:(CGFloat)blur;

/**
 *  @author tinkl, 15-10-26 11:10:27
 *
 *  @brief  提取图片主色调
 *
 */
-(UIColor*)pickUpImageColor;

@end
