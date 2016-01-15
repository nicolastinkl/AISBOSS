//
//  AIOrderTableModel.m
//  AIVeris
//
//  Created by 王坜 on 16/1/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIOrderTableModel.h"

@implementation AIOrderTableModel


- (id)init
{
    self = [super init];
    
    if (self) {
        _orderList = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end
