//
//  AIShareViewController.h
//  WeiboSDKLibDemo
//
//  Created by 王坜 on 15/7/30.
//  Copyright (c) 2015年 SINA iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface AIShareViewController : UIAlertController<WeiboSDKDelegate>

@property (nonatomic, strong) NSString *shareText;

+ (instancetype)shareWithText:(NSString *)text;


@end
