//
//  AIOrderManagementModels.m
//  AIVeris
//
//  Created by 王坜 on 16/3/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIOrderManagementModels.h"

@implementation AIOrderManagementModels

@end


@implementation AICustomer @end

@implementation AITaskProgress @end

@implementation AIService @end

@implementation AIServiceCategory @end

@implementation AIServiceRights @end

@implementation AIRights @end

@implementation AIServiceProvider

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"provider_portrait_url": @"portrait_icon"}];
}


@end

@implementation AIQueryBusinessInfos @end

@implementation AIRequirementTag @end

@implementation AIDefaultTag @end

@implementation AIRequirement @end

@implementation AIRequirementItem @end

@implementation AICommonRequirements @end

@implementation AIOriginalRequirementsList @end


/*
@implementation customer @end
 */
