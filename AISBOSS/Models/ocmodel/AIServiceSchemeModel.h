//
//  AIServiceSchemeModel.h
//  AIVeris
//
//  Created by tinkl on 16/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

/*!
 *  @author tinkl, 15-09-16 10:09:19
 *
 *  参数model
 */
@interface SchemeParamList : JSONModel
@property (assign, nonatomic) int param_key;
@property (strong, nonatomic) NSString<Optional> * param_value;
@property (strong, nonatomic) NSNumber<Optional> * param_value_id;
@end

@interface ServiceList : JSONModel

@property (assign, nonatomic) int  service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_price;
@property (strong, nonatomic) NSString<Optional> * service_intro;
@property (assign, nonatomic) int provider_id;
@property (strong, nonatomic) NSString<Optional> * provider_name;
@property (strong, nonatomic) NSNumber<Optional> * service_rating;
@property (strong, nonatomic) NSString<Optional> * provider_icon;
@property (strong, nonatomic) NSString<Optional> * service_img;
@property (strong, nonatomic) NSArray<SchemeParamList *> * service_param_list;

@end

@interface CatalogList : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * relevant_level;
@property (strong, nonatomic) NSString<Optional> * catalog_name;
@property (strong, nonatomic) NSNumber<Optional> * service_level;
@property (strong, nonatomic) NSNumber<Optional> * binding_flag;
@property (strong, nonatomic) NSArray<ServiceList *> * service_list;

@end

/*!
 *  @author tinkl, 15-09-16 10:09:25
 *
 *  服务方案model
 */
@interface AIServiceSchemeModel : JSONModel

@property (strong, nonatomic) NSArray<SchemeParamList *> * scheme_param_list;
@property (strong, nonatomic) NSArray<CatalogList *> * catalog_list;

@end


