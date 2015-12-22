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
#import "AINetEngine.h"
#import "AINotifications.h"

#define kMargin 20

#define kBuyer1Tag 100

#define kSeller1Tag 200

@interface AIFakeLoginView ()


@end

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


- (void)hideSelf
{
    self.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.3;
        weakSelf.transform = CGAffineTransformMakeScale(0.25, 0.25);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self hideSelf];
    
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


- (void)makeBubbleViewWithBubbleImageName:(NSString *)bubbleImageName
                             bubbleTitle:(NSString *)bubbleTitle
                                 atPointY:(CGFloat)pointY tag:(NSInteger)tag
{
    UIImageView *bubbleView = [self makeImageViewAtPoint:CGPointMake(kMargin, pointY) imageName:bubbleImageName];
    bubbleView.userInteractionEnabled = YES;
    bubbleView.tag = tag;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    [bubbleView addGestureRecognizer:tapGesture];
    //
    CGFloat titleHeight = [AITools displaySizeFrom1080DesignSize:200];
    
    UPLabel *titleLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(bubbleView.frame), titleHeight) text:bubbleTitle fontSize:[AITools displaySizeFrom1080DesignSize:68] color:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bubbleView addSubview:titleLabel];
    
    //
    
    
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
    
    UIImageView *titleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_BuyerTitle"];
    y += kMargin * 2 + CGRectGetHeight(titleImageView.frame);
    
    [self makeBubbleViewWithBubbleImageName:@"FakeLogin_Buyer" bubbleTitle:@"Lucy" atPointY:y tag:kBuyer1Tag];
}

- (void)makeSellerArea
{
    CGFloat y = CGRectGetHeight(self.frame) / 2;
    
    [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_Line"];
    
    y += 1 + kMargin;
    
    UIImageView *titleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_SellerTitle"];
    y += kMargin * 2 + CGRectGetHeight(titleImageView.frame);
    
    [self makeBubbleViewWithBubbleImageName:@"FakeLogin_Seller" bubbleTitle:@"Lily" atPointY:y tag:kSeller1Tag];
}

#pragma mark - Actions
/*买家气泡以100开头，卖家气泡以200开头
 * 100 : 第一个买家气泡
 * 200 : 第一个卖家气泡
 *
 *
 *
 *
 */

- (void)action:(UITapGestureRecognizer *)gesture
{
    NSString *userID = nil;
    
    switch (gesture.view.tag) {
        case kBuyer1Tag:
            userID = @"100000002410";
            break;
        case kSeller1Tag:
            userID = @"200000002501";
            break;
            
        default:
            break;
    }
    
    
    if (userID) {
        
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kDefault_UserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *query = [NSString stringWithFormat:@"0&0&%@&0", userID];
        [[AINetEngine defaultEngine] removeCommonHeaders];
        [[AINetEngine defaultEngine] configureCommonHeaders:@{@"HttpQuery" : query}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdataUserDataNotification object:nil];
    }
    
    
    [self hideSelf];
}



@end
