//
//  AIFakeUser.h
//  AIVeris
//
//  Created by 王坜 on 16/1/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FakeUserType) {
    FakeUserSeller = 100,
    FakeUserBuyer,
};


@class AIFakeUser;
typedef void(^UserSelectedAction)(AIFakeUser *user);

@interface AIFakeUser : UIView

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, assign) FakeUserType userType;


- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon selectedAction:(UserSelectedAction) action;


- (void)setSelected:(BOOL)selected;



@end
