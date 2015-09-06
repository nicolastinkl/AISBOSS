//
//  AIViews.m
//  DataStructure
//
//  Created by 王坜 on 15/7/13.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import "AIViews.h"
#import "AITools.h"


static MPMoviePlayerController *_singalPlayer;

@implementation AIViews

+ (UPLabel *)normalLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                         fontSize:(CGFloat)fontSize
                            color:(UIColor *)color
{
    UPLabel *label = [[UPLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.verticalAlignment = UPVerticalAlignmentMiddle;
    
    return label;
}


+ (UPLabel *)wrapLabelWithFrame:(CGRect)frame
                           text:(NSString *)text
                       fontSize:(CGFloat)fontSize
                          color:(UIColor *)color
{
    UPLabel *label = [[UPLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.verticalAlignment = UPVerticalAlignmentMiddle;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    return label;
}

+ (UIButton *)baseButtonWithFrame:(CGRect)frame normalTitle:(NSString *)normalTitle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.exclusiveTouch = YES;
    [button setFrame:frame];
    [button setTitle:normalTitle forState:UIControlStateNormal];
    
    return button;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (image == nil) {
        return nil;
    }

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    
    return imageView;
}


+ (BOOL)showAnimationLoadingOnView:(UIView *)view
{
    if (_singalPlayer) {
        return NO;
    }
    
    view.userInteractionEnabled = NO;
    _singalPlayer = [AITools playMovieNamed:@"loading" type:@"mp4" onView:view];
    _singalPlayer.repeatMode = MPMovieRepeatModeOne;
    return YES;
}

+ (BOOL)stopAnimationLoadingOnView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    if (_singalPlayer) {
        [_singalPlayer stop];
        [_singalPlayer.view removeFromSuperview];
        _singalPlayer = nil;
    }
    
    return YES;
}

@end
