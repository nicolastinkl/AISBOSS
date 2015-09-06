//
//  AICardView.h
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface AICardView : UIView

@property (nonatomic, readonly) NSArray *heights;

- (id)initWithFrame:(CGRect)frame cards:(NSArray *)cards;

@end
