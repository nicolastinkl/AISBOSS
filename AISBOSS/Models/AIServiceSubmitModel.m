//
//  AIServiceSubmitModel.m
//  AIVeris
//  提交服务参数
//  Created by Rocky on 15/12/16.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceSubmitModel.h"

@implementation AIProductParamItem
@end

@implementation AIServiceParamItem

- (id) init
{
    self = [super init];
    
    if (self) {
        _param_value_id = [[NSMutableArray alloc]init];
        _param_value = [[NSMutableArray alloc]init];
    }
    
    return self;
}

@end

@implementation AIServiceSaveDataModel

- (id) init
{
    self = [super init];
    
    if (self) {
        _product_list = [[NSMutableArray alloc]init];
        _service_param_list = [[NSMutableArray alloc]init];
    }
    
    return self;
}

@end

@implementation AIServiceSubmitModel
@end
