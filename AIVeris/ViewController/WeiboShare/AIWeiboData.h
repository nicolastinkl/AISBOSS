//
//  AIWeiboData.h
//  AITrans
//
//  Created by 王坜 on 15/8/3.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AIWeiboData : NSObject

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;

@property (nonatomic, weak) UIViewController *shareViewController;

+ (instancetype)instance;

@end
