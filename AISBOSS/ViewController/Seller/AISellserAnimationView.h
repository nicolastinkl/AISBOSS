//
//  AISellserAnimationView.h
//  AITrans
//
//  Created by 王坜 on 15/9/23.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AISellerViewController;

@interface AISellserAnimationView : UIView

/*!
 *  @author tinkl, 15-09-23 15:09:22
 */
@property (nonatomic, weak) AISellerViewController *sellerViewController;

/**
 * 说明：增加卖家主页开场动画
 */
+ (void)startAnimationOnSellerViewController:(AISellerViewController *)sellerViewController;


@end
