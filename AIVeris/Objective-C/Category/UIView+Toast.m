//
//  UIView+Toast.m
//  AIVeris
//
//  Created by 王坜 on 15/12/9.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "UIView+Toast.h"
#import "AIViews.h"
#import "AITools.h"

#define kTextSideMargin   15

#define kTextFontSize     16

#define kLoadingTag       2015001

@implementation UIView (Toast)

- (void)showLoadingWithMessage:(NSString *)message
{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *toastView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    toastView.tag = kLoadingTag;
    toastView.userInteractionEnabled = NO;
    [keyWindow addSubview:toastView];
    
    // add bg
    UIView *bgView = [[UIView alloc] initWithFrame:toastView.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [toastView addSubview:bgView];
    
    // add loading
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = CGPointMake(CGRectGetWidth(toastView.frame) / 2, CGRectGetHeight(toastView.frame) * 0.45);
    [toastView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    // add message
    CGRect messageFrame = CGRectMake(kTextSideMargin, indicatorView.center.y + CGRectGetHeight(indicatorView.frame) / 2, CGRectGetWidth(keyWindow.bounds) - kTextSideMargin * 2, 100);
    UPLabel *messageLabel = [AIViews wrapLabelWithFrame:messageFrame text:message fontSize:kTextFontSize color:[UIColor whiteColor]];
    messageLabel.font = [AITools myriadSemiCondensedWithSize:kTextFontSize];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [toastView addSubview:messageLabel];
    
}


- (void)dismissLoading
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = [keyWindow viewWithTag:kLoadingTag];
    [view removeFromSuperview];
}

@end
