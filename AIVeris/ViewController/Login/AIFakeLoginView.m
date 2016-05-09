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
#import "AIFakeUser.h"
#import <AVOSCloud/AVOSCloud.h>

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


@property (nonatomic, weak) AIFakeUser *currentUser;

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


#pragma mark- Util

- (UIImageView *)makeImageViewAtPoint:(CGPoint)point imageName:(NSString *)imageName hlImageName:(NSString *)hlImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage: hlImageName ? [UIImage imageNamed:hlImageName] : nil];
    imageView.frame = frame;
    imageView.userInteractionEnabled = YES;
    

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
    
    
    UIImage *image = [UIImage imageNamed:@"FakeLogin_Buyer"];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    __weak typeof(self) wf = self;
    AIFakeUser *buyer = [[AIFakeUser alloc] initWithFrame:CGRectMake(kMargin, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    buyer.userID = @"100000002410";
    buyer.userType = FakeUserBuyer;
    [self handlerDefaultUser:buyer];
    [self addSubview:buyer];

}

- (void)makeSellerArea
{
    __weak typeof(self) wf = self;
    CGFloat y = CGRectGetHeight(self.frame) / 2;
    
    [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_Line" hlImageName:nil];
    
    y += 1 + kMargin;
    
    _sellerTitleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_SellerTitle" hlImageName:@"FakeLogin_SellerTitleL"];
    y += kMargin * 2 + CGRectGetHeight(_sellerTitleImageView.frame);
    
    // Seller
    
    UIImage *image = [UIImage imageNamed:@"FakeLogin_Seller"];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    AIFakeUser *seller = [[AIFakeUser alloc] initWithFrame:CGRectMake(kMargin, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    seller.userID = @"200000002501";
    seller.userType = FakeUserSeller;
    [self addSubview:seller];
    [self handlerDefaultUser:seller];
    // David
    
    CGFloat x = CGRectGetMaxX(seller.frame) + kMargin;
    
    image = [UIImage imageNamed:@"FakeLogin_David"];
    size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    seller = [[AIFakeUser alloc] initWithFrame:CGRectMake(x, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    seller.userID = @"200000001635";
    seller.userType = FakeUserSeller;
    [self handlerDefaultUser:seller];
    [self addSubview:seller];
    
    
}



#pragma mark - Actions

- (void)makeStatusWithUserType:(FakeUserType)type
{
    if (type == FakeUserBuyer) {
        _buyerTitleImageView.highlighted = YES;
        _sellerTitleImageView.highlighted = NO;
    }
    else if (type == FakeUserSeller)
    {
        _buyerTitleImageView.highlighted = NO;
        _sellerTitleImageView.highlighted = YES;
    }
}


- (void)handlerDefaultUser:(AIFakeUser *)user
{
    NSString *defaultID = [[NSUserDefaults standardUserDefaults] objectForKey:kDefault_UserID];
    
    if ([user.userID isEqualToString:defaultID]) {
        self.currentUser = user;
        [user setSelected:YES];
        [self makeStatusWithUserType:user.userType];
    }
}

- (void)handlerUser:(AIFakeUser *)user
{
    [self.currentUser setSelected:NO];
    
    [self makeStatusWithUserType:user.userType];
    
    if (user.userID) {
        // 配置语音协助定向推送
        // 配置频道
        AVInstallation *installation = [AVInstallation currentInstallation];

        if (user.userType == FakeUserSeller) {
            [installation setObject:user.userID forKey:@"ProviderIdentifier"];
            [installation addUniqueObject:@"ProviderChannel" forKey:@"channels"];
            [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:kDefault_UserType];
        }
        else
        {
            [installation removeObjectForKey:@"ProviderIdentifier"];
            [installation removeObject:@"ProviderChannel" forKey:@"channels"];
            [[NSUserDefaults standardUserDefaults] setObject:@"101" forKey:kDefault_UserType];
        }
        
        [installation saveInBackground];
        
        
        // 保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:user.userID forKey:kDefault_UserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *query = [NSString stringWithFormat:@"0&0&%@&0", user.userID];
        [[AINetEngine defaultEngine] removeCommonHeaders];
        [[AINetEngine defaultEngine] configureCommonHeaders:@{@"HttpQuery" : query}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdataUserDataNotification object:nil];
    }
    
    [self hideSelf];
}

/*
 
 
 */



@end
