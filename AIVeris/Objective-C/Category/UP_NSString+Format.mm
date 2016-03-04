//
//  NSString+Format.m
//  MPOS
//
//  Created by liwang on 14-10-21.
//  Copyright (c) 2014年 China UnionPay. All rights reserved.
//
#import "UP_NSString+Format.h"


@implementation NSString (Format)


//16进制颜色(html颜色值)字符串转为UIColor

- (UIColor *)hexToColor
{
    if (!self ) return nil;
    
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6
    
    if ([cString length] !=6) return nil;
    
    // Separate into r, g, b substrings
    
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}







// 十六进制转换为普通字符串的。
- (NSString *)stringFromHex
{ //
    if (!self) {
        return nil;
    }
    
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
        [scanner release];
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
    free(myBuffer);
    
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的。

- (NSString *)hexString
{
    if (!self) {
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    //下面是Byte 转换为16进制。
    NSMutableString *hexStr= [NSMutableString stringWithString:@""];
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02X",bytes[i]];///16进制数
        [hexStr appendString:newHexStr];
    }
    
    return hexStr; 
}




#pragma mark - fen to yuan

- (NSString *)yuanValue
{
    if (!self) {
        return nil;
    }
    double doubleValue = self.doubleValue;
    return [NSString stringWithFormat:@"%.2lf", doubleValue/100];;
}

@end
