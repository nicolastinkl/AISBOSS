//
//  AIExecuteServiceModel.h
//  AIVeris
//
//  Created by 刘先 on 16/5/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIOrderManagementModels.h"

#pragma mark - AIGrabOrderDetailModel 抢单订单详情

@protocol AIGrabOrderParamModel @end

@interface AIGrabOrderParamModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *icon;
@property(nonatomic,strong) NSString<Optional> *content;

@end


@protocol AIGrabOrderDetailModel @end

@interface AIGrabOrderDetailModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *service_thumbnail_icon;
@property(nonatomic,strong) NSString<Optional> *service_name;
@property(nonatomic,strong) NSString<Optional> *service_intro_content;
@property(nonatomic,assign) AICustomer<Optional> *customer;
@property(nonatomic, assign) NSArray<Optional, AIGrabOrderParamModel> *contents;

@end


@protocol AIGrabOrderUserNeedsModel @end

@interface AIGrabOrderUserNeedsModel : JSONModel

@property(nonatomic, assign) NSArray<Optional, AIGrabOrderParamModel> *contents;
@property(nonatomic,strong) NSString<Optional> *desc;

@end

#pragma mark - AIGrabOrderDetailModel 抢单结果模型
@protocol AIGrabOrderResultModel @end

@interface AIGrabOrderResultModel : JSONModel

@property(nonatomic,strong) NSNumber<Optional> *result;
@property(nonatomic,assign) AIGrabOrderUserNeedsModel<Optional> *customer;

@end