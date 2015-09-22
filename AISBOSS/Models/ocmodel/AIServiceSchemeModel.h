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
@property (assign, nonatomic) NSInteger param_key;
@property (strong, nonatomic) NSString<Optional> * param_value;
@property (strong, nonatomic) NSNumber<Optional> * param_value_id;
@end


// MARK: 计价方式
@interface ServicePrice : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * price;  //价格数值
@property (assign, nonatomic) int unit;     //价格单位 1-人民币 2-美元
@property (assign, nonatomic) int billing_mode; //计价方式 1.按次数2.按小时3.按天
@property (strong, nonatomic) NSString<Optional> * price_show;   //显示用价格

@end

@interface ServiceList : JSONModel

@property (assign, nonatomic) NSInteger service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_intro;
@property (assign, nonatomic) NSInteger provider_id;
@property (strong, nonatomic) NSString<Optional> * provider_name;
@property (strong, nonatomic) NSNumber<Optional> * service_rating;
@property (strong, nonatomic) NSString<Optional> * provider_icon;
@property (strong, nonatomic) NSString<Optional> * service_img;
@property (strong, nonatomic) NSArray<SchemeParamList *> * service_param_list;
@property (strong, nonatomic) ServicePrice<Optional> * service_price;
@end


@interface Catalog : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * relevant_level;
@property (strong, nonatomic) NSString<Optional> * catalog_name;
@property (strong, nonatomic) NSNumber<Optional> * service_level; //1-轮播 2-平铺 3-开关 4-单个（机票）
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
@property (strong, nonatomic) NSArray<Catalog *> * catalog_list;

@end


