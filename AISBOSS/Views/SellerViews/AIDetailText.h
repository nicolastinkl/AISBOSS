//
//  AIDetailText.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIDetailText : UIView

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *detailString;

- (instancetype)initWithFrame:(CGRect)frame titile:(NSString *)title detail:(NSString *)detail;


@end
