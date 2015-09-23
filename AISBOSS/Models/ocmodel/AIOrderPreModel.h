//
//  AIOrderPreModel.h
//  AIVeris
//
//  Created by 王坜 on 15/9/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"


// 买家

@interface AICustomerModel : JSONModel

@property (nonatomic, assign) int user_id;               // 用户ID
@property (nonatomic, strong) NSString<Optional> *user_portrait_icon;    // 用户头像
@property (nonatomic, strong) NSString<Optional> *user_name;
@property (nonatomic, strong) NSString<Optional> *user_phone;
@property (nonatomic, strong) NSString<Optional> *user_address;

@end


// 进度

@interface AIProgressModel : JSONModel

@property (nonatomic, assign) NSString<Optional> *percentage;

@property (nonatomic, strong) NSString<Optional> *name;

@property (nonatomic, assign) int operation;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString<Optional> *icon;

@end



@interface AIServiceCategoryModel : JSONModel

@property (nonatomic, assign) int category_id;
@property (nonatomic, strong) NSString<Optional> *category_name;             // 服务的类别名称
@property (nonatomic, strong) NSString<Optional> *category_icon;             // 服务的类别图标

@end

@protocol AIServiceCategoryModel
@end


// 订单

@interface AIServiceModel : JSONModel

@property (nonatomic, assign) int service_id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_name;
@property (nonatomic, strong) AIServiceCategoryModel<Optional> *service_category;
@property (nonatomic, strong) AIProgressModel<Optional> *service_progress;   // 服务执行的进度


@end



// 服务

@protocol AIOrderPreModel
@end

@interface AIOrderPreModel : JSONModel

@property (nonatomic, assign) int order_id;

@property (nonatomic, strong) NSString<Optional> *order_number;

@property (nonatomic, assign) int order_state;

@property (nonatomic, strong) NSString<Optional> *order_state_name;

@property (nonatomic, strong) AICustomerModel<Optional> *customer;

@property (nonatomic, strong) AIServiceModel<Optional> *service;


@end



@interface AIOrderPreListModel : JSONModel

@property (nonatomic, strong) NSArray<AIOrderPreModel> *order_list;

@end


