//
//  AISellerViewController.h
//  AITrans
//
//  Created by 王坜 on 15/7/21.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AISellerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *logoButton;

@end
