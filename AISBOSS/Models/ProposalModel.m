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
@implementation AIProposalServiceDetailIntroImgModel
@end

@implementation AIProposalServiceDetailProviderModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"provider_id"
                                                       }];
}

@end

@implementation AIProposalServiceDetailParamModel
@end

@implementation AIProposalServiceDetailParamValueModel
@end

@implementation AIProposalServiceDetailRatingItemModel
@end

@implementation AIProposalServiceDetailRatingCommentModel
@end

@implementation AIProposalServiceDetailRatingModel
@end

@implementation AIProposalServiceDetailLabelModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"label_id"
                                                       }];
}

@end

@implementation AIProposalServiceDetailHopeModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"hope_id"
                                                       }];
}

@end

@implementation AIProposalServiceDetail_WishModel
@end

@implementation AIProposalServiceDetailModel
@end



@implementation AIRelationParamItemModel
@end

@implementation AIParamRelationModel
@end

