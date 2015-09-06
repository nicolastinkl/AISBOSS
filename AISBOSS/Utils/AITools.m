//
//  AITools.m
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AITools.h"


@implementation AITools

+ (MPMoviePlayerController *)playMovieNamed:(NSString *)name type:(NSString *)type onView:(UIView *)view
{
    //视频文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    //视频URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.controlStyle = MPMovieControlStyleNone;
    [player.view setFrame:view.bounds];
    player.shouldAutoplay = YES;
    player.scalingMode = MPMovieScalingModeAspectFill;
    [view addSubview:player.view];
    player.view.alpha = 0;
    player.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        player.view.alpha = 0.8;
    } completion:^(BOOL finished) {
        [player play];
    }];
    
    
    return player;
}

+ (void)performBlock:(void(^)(void))block delay:(CGFloat)delay
{
    
}


+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (!hex) return nil;
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
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


@end
