//
//  NSString+Size.h
//  MPOS
//
//  Created by liwang on 14-9-7.
//  Copyright (c) 2014年 China UnionPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)newSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFontSize:(CGFloat)fontSize forWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width;

@end
