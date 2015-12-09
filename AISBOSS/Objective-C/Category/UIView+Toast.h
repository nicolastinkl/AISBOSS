//
//  UIView+Toast.h
//  AIVeris
//
//  Created by 王坜 on 15/12/9.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Toast)

- (void)showLoadingWithMessage:(NSString *)message;

- (void)dismissLoading;

@end
