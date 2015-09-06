//
//  TableViewCellBackgroundView.m
//  OwnerApp
//
//  Created by tinkl on 27/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TableViewCellBackgroundView.h"

@implementation TableViewCellBackgroundView

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
- (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

/// ===============
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initForCell:(UITableViewCell *)cell {
    if (self = [super initWithFrame:CGRectZero]) {
        self.type = CommonCellBackgroundViewTypeGroupSingle;
        self.cell =cell;    
        self.backgroundColor =  [self colorWithHexString:@"#715E79" alpha:0.8];
        self.separatorCGColor = [UIColor clearColor]; // RGB(200, 199, 204);
        _borderEdgeInsets = UIEdgeInsetsMake(0, -1, 0, -1);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGroupSeparatorLineWithContext:context rect:rect];
}

- (void)drawGroupSeparatorLineWithContext:(CGContextRef)context rect:(CGRect)rect {
    
    if (self.borderEdgeInsets.left == -1) {
        self.borderInsetLeft = CGRectGetMinX(self.cell.contentView.frame) + CGRectGetMinX(self.cell.textLabel.frame);
    } else {
        self.borderInsetLeft = self.borderEdgeInsets.left;
    }
    
    if (self.borderEdgeInsets.right == -1 || self.borderEdgeInsets.right == 0) {
        self.borderInsetRight = CGRectGetWidth(rect);
    } else {
        self.borderInsetRight = CGRectGetWidth(rect) - self.borderEdgeInsets.right;
    }
    
    
    NSLog(@"left: %f   right: %f ",self.borderInsetLeft,self.borderInsetRight);
    
//    CGContextSetStrokeColorWithColor(context, self.separatorCGColor.CGColor);
//    CGContextSetLineWidth(context, 1);
    
    
    if (self.type == CommonCellBackgroundViewTypeGroupFirst) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, self.borderInsetRight, 0);
        CGContextStrokePath(context);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.borderInsetLeft, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, self.borderInsetRight, CGRectGetHeight(rect));
        CGContextStrokePath(context);
    } else if (self.type == CommonCellBackgroundViewTypeGroupMiddle) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.borderInsetLeft, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, self.borderInsetRight, CGRectGetHeight(rect));
        CGContextStrokePath(context);
    } else if (self.type == CommonCellBackgroundViewTypeGroupLast) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, self.borderInsetRight, CGRectGetHeight(rect));
        CGContextStrokePath(context);
    } else if (self.type == CommonCellBackgroundViewTypeGroupSingle) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, self.borderInsetRight, 0);
        CGContextStrokePath(context);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect));
        CGContextAddLineToPoint(context, self.borderInsetRight, CGRectGetHeight(rect));
        CGContextStrokePath(context);
    }
}


@end
