//
//  AIOrderPreModel.m
//  AIVeris
//
//  Created by 王坜 on 15/9/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIOrderPreModel.h"

@implementation AICustomerModel

/*
+(JSONKeyMapper*)keyMapper
{
    // 这里就采用了KVC的方式来取值...
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"user_portrait_icon.param_value": @"user_portrait_icon"
                                                       
                                                       }];
}*/

@end


@implementation AIServiceModel



@end


@implementation AIServiceParamModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation AIProgressModel



@end

@implementation AIOrderPreModel

@end

@implementation AIOrderPreListModel


@end

@implementation AIServiceCategoryModel



@end
