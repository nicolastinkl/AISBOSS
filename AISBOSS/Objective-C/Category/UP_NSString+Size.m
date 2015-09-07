//
//  NSString+Size.m
//  MPOS
//
//  Created by liwang on 14-9-7.
//  Copyright (c) 2014年 China UnionPay. All rights reserved.
//

#import "UP_NSString+Size.h"

@implementation NSString (Size)

- (CGSize)newSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    size = frame.size;
    [paragraphStyle release];

    return size;
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize forWidth:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    size = frame.size;
    [paragraphStyle release];
    
    return size;
}


- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    size = frame.size;
    [paragraphStyle release];
    
    return size;
}

@end
