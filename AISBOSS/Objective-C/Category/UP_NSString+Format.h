//
//  NSString+Format.h
//  MPOS
//
//  Created by liwang on 14-10-21.
//  Copyright (c) 2014年 China UnionPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Format)


#pragma mark - Hex to Color

- (UIColor *)hexToColor;


#pragma mark - to hex

- (NSString *)hexString;

- (NSString *)stringFromHex;

#pragma mark - fen to yuan

- (NSString *)yuanValue;

@end
