//
//  AIFakeLoginViewController.m
//  AIVeris
//
//  Created by 王坜 on 15/12/14.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIFakeLoginView.h"
#import "AITools.h"
#import "AIViews.h"

#define kMargin 20



@implementation AIFakeLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeBackground];
        [self makeBuyerArea];
        [self makeSellerArea];
    }
    
    return self;
}

#pragma mark - Tap

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark- Util

- (UIImageView *)makeImageViewAtPoint:(CGPoint)point imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    return imageView;
}


- (void)makeCommonViewWithTitleImageName:(NSString *)titleImageName
                         bubbleImageName:(NSString *)bubbleImageName
                             bubbleTitle:(NSString *)bubbleTitle
                                atPointY:(CGFloat)pointY
{

    UIImageView *titleView = [self makeImageViewAtPoint:CGPointMake(0, pointY) imageName:titleImageName];
    pointY += CGRectGetHeight(titleView.frame) + kMargin * 2;
    UIImageView *bubbleView = [self makeImageViewAtPoint:CGPointMake(kMargin, pointY) imageName:bubbleImageName];
    
    //
    
    CGFloat titleHeight = [AITools displaySizeFrom1080DesignSize:200];
    
    UPLabel *titleLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(bubbleView.frame), titleHeight) text:bubbleTitle fontSize:[AITools displaySizeFrom1080DesignSize:68] color:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bubbleView addSubview:titleLabel];
}

#pragma mark - Main

- (void)makeBackground
{
    UIImageView *bgView = [self makeImageViewAtPoint:CGPointZero imageName:@"FakeLogin_BG"];
    bgView.frame = self.bounds;
}


- (void)makeBuyerArea
{
    CGFloat y = kMargin;
    
    [self makeCommonViewWithTitleImageName:@"FakeLogin_BuyerTitle" bubbleImageName:@"FakeLogin_Buyer" bubbleTitle:@"Lucy" atPointY:y];
}

- (void)makeSellerArea
{
    CGFloat y = CGRectGetHeight(self.frame) / 2;
    
    [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_Line"];
    
    y += 1 + kMargin;
    
    [self makeCommonViewWithTitleImageName:@"FakeLogin_SellerTitle" bubbleImageName:@"FakeLogin_Seller" bubbleTitle:@"Lily" atPointY:y];
}



@end
