//
//  AIOrderTableModel.h
//  AIVeris
//
//  Created by 王坜 on 16/1/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIOrderTableModel : NSObject


@property (nonatomic, strong) NSString *sortTime;

@property (nonatomic, strong) NSMutableArray *orderList;

@property (nonatomic, strong) NSString *timeTitle;


@end
