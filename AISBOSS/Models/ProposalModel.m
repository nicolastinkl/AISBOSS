//
//  ProposalModel.m
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "ProposalModel.h"

@implementation ParamModel
@end

@implementation ServiceOrderModel

@end

@implementation ProposalOrderListModel
@end

@implementation ProposalOrderModel
@end

@implementation AIProposalServiceModel

- (id) init
{
    self = [super init];
    
    if (self) {
        _service_rating_level = -1;
    }
    
    return self;
}

@end

@implementation AIProposalProvider
@end

@implementation AIProposalInstModel
@end

@implementation AIProposalHopeModel
@end

@implementation AIProposalServicePriceModel
@end

@implementation AIProposalHopeAudioTextModel
@end

@implementation AIProposalNotesModel
@end

/**
 *  @author tinkl, 15-12-01 11:12:52
 *
 *  @brief  detail
 *
 *  @since <#version number#>
 */
@implementation AIProposalServiceDetail_Intro_img_listModel
@end

@implementation AIProposalServiceDetail_provider_listModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"provider_id": @"id"
                                                       }];
}

@end

@implementation AIProposalServiceDetail_Param_listModel
@end

@implementation AIProposalServiceDetail_Param_Value_listModel
@end

@implementation AIProposalServiceDetail_Rating_List_Item_listModel
@end

@implementation AIProposalServiceDetail_Rating_Comment_listModel
@end

@implementation AIProposalServiceDetail_Rating_listModel
@end

@implementation AIProposalServiceDetail_label_list_listModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"label_id": @"id"
                                                       }];
}

@end

@implementation AIProposalServiceDetail_hope_list_listModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"hope_id": @"id"
                                                       }];
}

@end

@implementation AIProposalServiceDetail_wish_list_listModel
@end

@implementation AIProposalServiceDetailModel
@end
