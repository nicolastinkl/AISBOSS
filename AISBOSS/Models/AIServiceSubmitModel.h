//
//  AIServiceSubmitModel.h
//  AIVeris
//
//  提交服务参数
//  Created by Rocky on 15/12/16.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>
// 作为product提交的数据
@protocol AIProductParamItem
@end

@interface AIProductParamItem : JSONModel

@property (strong, nonatomic) NSString<Optional> * product_id;
@property (strong, nonatomic) NSString<Optional> * service_id;
@property (strong, nonatomic) NSString<Optional> * role_id;
@property (strong, nonatomic) NSString<Optional> * name;

@end


// 作为服务的纯参数提交的数据
@protocol AIServiceParamItem
@end

@interface AIServiceParamItem : JSONModel

@property (strong, nonatomic) NSString<Optional> * source;
@property (strong, nonatomic) NSString<Optional> * service_id;
@property (strong, nonatomic) NSString<Optional> * role_id;
@property (strong, nonatomic) NSString<Optional> * product_id;
@property (strong, nonatomic) NSString<Optional> * param_key;
@property (strong, nonatomic) NSArray<Optional> * param_value_id;
@property (strong, nonatomic) NSArray<Optional> * param_value;

@end



@protocol AIServiceSaveDataModel
@end

@interface AIServiceSaveDataModel : JSONModel

@property (strong, nonatomic) NSArray<AIProductParamItem, Optional> * product_list;
@property (strong, nonatomic) NSArray<AIServiceParamItem, Optional> * service_param_list;

@end




@interface AIServiceSubmitModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;
@property (assign, nonatomic) NSInteger customer_id;
@property (assign, nonatomic) NSInteger proposal_id;
@property (assign, nonatomic) NSInteger role_id;
@property (strong, nonatomic) AIServiceSaveDataModel<Optional> * save_data;

@end
