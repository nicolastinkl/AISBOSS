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

#define kSellerDavidTag 300

#define kBuyer1         @"100000002410"
#define kSeller1        @"200000002501"
#define kSellerDavid    @"200000002501"


@interface AIFakeLoginView ()
{
    UIImageView *_buyerTitleImageView;
    UIImageView *_sellerTitleImageView;
}

@end

@implementation AIFakeLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeBackground];
        [self makeBuyerArea];
        [self makeSellerArea];
        [self makeDefaultUser];
    }
    
    return self;
}

- (void)makeDefaultUser
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kDefault_UserID];
    
    if ([userID isEqualToString:kBuyer1]) {
        _buyerTitleImageView.highlighted = YES;
    }
    else if ([userID isEqualToString:kSeller1])
    {
        _sellerTitleImageView.highlighted = YES;
    }
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

- (void)noneAction
{
    
}

#pragma mark- Util

- (UIImageView *)makeImageViewAtPoint:(CGPoint)point imageName:(NSString *)imageName hlImageName:(NSString *)hlImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage: hlImageName ? [UIImage imageNamed:hlImageName] : nil];
    imageView.frame = frame;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noneAction)];
    [imageView addGestureRecognizer:tapGesture];
    [self addSubview:imageView];
    
    return imageView;
}


- (UIImageView *)makeBubbleViewWithBubbleImageName:(NSString *)bubbleImageName
                             bubbleTitle:(NSString *)bubbleTitle
                                 atPoint:(CGPoint)point tag:(NSInteger)tag
{
    UIImageView *bubbleView = [self makeImageViewAtPoint:point imageName:bubbleImageName hlImageName:nil];
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
    return bubbleView;
    
}

#pragma mark - Main

- (void)makeBackground
{
    UIImageView *bgView = [self makeImageViewAtPoint:CGPointZero imageName:@"FakeLogin_BG" hlImageName:nil];
    bgView.userInteractionEnabled = NO;
    bgView.frame = self.bounds;
}


- (void)makeBuyerArea
{
    CGFloat y = kMargin;
    
    _buyerTitleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_BuyerTitle" hlImageName:@"FakeLogin_BuyerTitleL"];
    y += kMargin * 2 + CGRectGetHeight(_buyerTitleImageView.frame);
    
    [self makeBubbleViewWithBubbleImageName:@"FakeLogin_Buyer" bubbleTitle:@"" atPoint:CGPointMake(kMargin, y) tag:kBuyer1Tag];
}

- (void)makeSellerArea
{
    CGFloat y = CGRectGetHeight(self.frame) / 2;
    
    [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_Line" hlImageName:nil];
    
    y += 1 + kMargin;
    
    _sellerTitleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_SellerTitle" hlImageName:@"FakeLogin_SellerTitleL"];
    y += kMargin * 2 + CGRectGetHeight(_sellerTitleImageView.frame);
    
    UIImageView *seller =  [self makeBubbleViewWithBubbleImageName:@"FakeLogin_Seller" bubbleTitle:@"" atPoint:CGPointMake(kMargin, y) tag:kSeller1Tag];
    
    CGFloat x = CGRectGetMaxX(seller.frame) + kMargin;
    
    [self makeBubbleViewWithBubbleImageName:@"FakeLogin_David" bubbleTitle:@"" atPoint:CGPointMake(x, y) tag:kSellerDavidTag];
    
}

- (void)makeDavidArea
{
    
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
    // handle userID
    NSString *userID = nil;
    
    switch (gesture.view.tag) {
        case kBuyer1Tag:
        {
            userID = kBuyer1;
            _buyerTitleImageView.highlighted = YES;
            _sellerTitleImageView.highlighted = NO;
        }
            
            break;
        case kSeller1Tag:
        {
            userID = kSeller1;
            _buyerTitleImageView.highlighted = NO;
            _sellerTitleImageView.highlighted = YES;
        }
            break;
        case kSellerDavidTag:
        {
            userID = kSellerDavid;
            _buyerTitleImageView.highlighted = NO;
            _sellerTitleImageView.highlighted = YES;
        }
            
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
