//
//  AIOrderManagementModels.h
//  AIVeris
//
//  Created by 王坜 on 16/3/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"



@interface AIOrderManagementModels : JSONModel

@end


#pragma mark - customer


@protocol AICustomer @end

@interface AICustomer : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *customer_id;

@property (nonatomic, strong) NSString<Optional> *user_portrait_icon;

@property (nonatomic, strong) NSString<Optional> *user_name;

@property (nonatomic, strong) NSString<Optional> *user_phone;

@property (nonatomic, strong) NSNumber<Optional> *user_id;

@property (nonatomic, strong) NSNumber<Optional> *user_message_count;


@end

#pragma mark - progress
@protocol AITaskProgress @end

@interface AITaskProgress : JSONModel

@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *percentage;
@property (nonatomic, strong) NSNumber<Optional> *operation;
@property (nonatomic, strong) NSString<Optional> *icon;

@property (nonatomic, strong) NSNumber<Optional> *service_id;
@property (nonatomic, strong) NSString<Optional> *service_catalog;
@property (nonatomic, strong) NSString<Optional> *service_progress;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_url;


@end

#pragma mark - Service
@protocol AIService @end

@interface AIService : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *service_catalog;

@property (nonatomic, strong) NSString<Optional> *service_progress;

@property (nonatomic, strong) NSNumber<Optional> *service_id;


@end

#pragma mark - AIServiceCategory
@protocol AIServiceCategory @end

@interface AIServiceCategory : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *category_id;
@property (nonatomic, strong) NSString<Optional> *category_name;
@property (nonatomic, strong) NSString<Optional> *category_icon;


@end

#pragma mark - AIServiceRights
@protocol AIServiceRights @end

@interface AIServiceRights : JSONModel

@property (nonatomic, strong) NSString<Optional> *right_id;
@property (nonatomic, strong) NSString<Optional> *right_value;

@end


#pragma mark - AIRights
@protocol AIRights @end

@interface AIRights : JSONModel

@property (nonatomic, strong) NSString<Optional> *rightID;

@property (nonatomic, strong) NSString<Optional> *rightValue;


@end

#pragma mark - AIServiceProvider
@protocol AIServiceProvider @end

@interface AIServiceProvider : JSONModel
@property (nonatomic, strong) NSString<Optional> *provider_portrait_url;

@property (nonatomic, strong) NSString<Optional> *relservice_desc;

@property (nonatomic, strong) NSNumber<Optional> *relservice_id;

@property (nonatomic, strong) NSString<Optional> *relservice_name;

@property (nonatomic, strong) NSNumber<Optional> *relservice_instance_id;

@property (nonatomic, strong) NSNumber<Optional> *reluser_id;

@property (nonatomic, strong) NSNumber<Optional> *service_item_id;

@property (nonatomic, strong) NSNumber<Optional> *service_rating_level;

@property (nonatomic, strong) NSDictionary<Optional> *relservice_progress;

@property (nonatomic, strong) NSArray<Optional> *own_right_id;


@end

#pragma mark - QueryBusinessInfos

@protocol AIQueryBusinessInfos @end

@interface AIQueryBusinessInfos : JSONModel


@property (nonatomic, strong) NSNumber<Optional> *order_id;

@property (nonatomic, strong) NSString<Optional> *order_state;

@property (nonatomic, strong) NSString<Optional> *order_create_time;

@property (nonatomic, strong) NSNumber<Optional> *comp_service_id;

@property (nonatomic, strong) NSString<Optional> *comp_user_id;

@property (nonatomic, strong) AICustomer<Optional> *customer;

@property (nonatomic, strong) AIService<Optional> *service;

@property (nonatomic, strong) NSArray<Optional, AIServiceRights> *right_list;

@property (nonatomic, strong) NSArray<Optional, AIServiceProvider> *rel_serv_rolelist;

 





@end

#pragma mark - AIDefaultTag
@protocol AIDefaultTag @end

@interface AIDefaultTag : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *tag_id;
@property (nonatomic, strong) NSString<Optional> *tag_type;
@property (nonatomic, strong) NSString<Optional> *tag_content;

@end







#pragma mark - AIRequirementTag
@protocol AIRequirementTag @end

@interface AIRequirementTag : JSONModel

@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *status;
@end

#pragma mark - AIRequirement
@protocol AIRequirement @end

@interface AIRequirement : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *rid;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *status;
@end


#pragma mark - AIRequirementItem
@protocol AIRequirementItem @end

@interface AIRequirementItem : JSONModel

@property (nonatomic, strong) NSArray<Optional, AIRequirement> *requirement;
@property (nonatomic, strong) NSArray<Optional> *service_provider_icons;

@end


#pragma mark - AIOriginalRequirements
@protocol AICommonRequirements @end

@interface AICommonRequirements : JSONModel

@property (nonatomic, strong) NSString<Optional> *block_title;
@property (nonatomic, strong) NSString<Optional> *block_desc;
@property (nonatomic, strong) NSString<Optional> *block_icon;
@property (nonatomic, strong) NSString<Optional> *block_category;

@property (nonatomic, strong) NSArray<Optional, AIRequirementItem> *requirements;




@end


#pragma mark -
@protocol AIOriginalRequirementsList @end

@interface AIOriginalRequirementsList : JSONModel

@property (nonatomic, strong) NSArray<Optional, AICommonRequirements> *requirement_list;

@end
