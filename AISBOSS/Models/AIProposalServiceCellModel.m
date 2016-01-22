//
//  AIProposalServiceCellModel.m
//  AIVeris
//
//  Created by 刘先 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIProposalServiceCellModel.h"

@implementation PlaneTicketModel

@end

@implementation TaxiModel

@end

@implementation TextDescModel

@end

@implementation HotelModel

@end

@implementation ServiceCellStadandParamModel

@end

@implementation ServiceCellProductParamModel


- (id) init
{
    self = [super init];
    
    if (self) {
        _product_name = @"";
        _product_sub_name = @"";
    }
    
    return self;
}


+(JSONKeyMapper*)keyMapper
{
    // 这里就采用了KVC的方式来取值...
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"param_value.product_name": @"product_name",
                                                       @"param_value.param_list": @"param_list"
                                                       
                                                       }];
}


@end

@implementation ServiceCellStandardParamListModel

@end

@implementation ServiceCellShoppingItemModel

@end

@implementation ServiceCellShoppingModel

@end