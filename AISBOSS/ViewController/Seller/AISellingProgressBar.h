//
//  AISellingProgressBar.h
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AISellingProgressBar : UIView

@property (nonatomic, readonly) UILabel *progressLabel;

@property (nonatomic, readonly) UIImageView *progressIndicator;

@property (nonatomic, assign) NSInteger progressPercent;


- (void)setProgressContent:(NSDictionary *)content;


@end
