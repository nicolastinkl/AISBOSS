//
//  ProposalModel.h
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol ServiceOrderModel

@end

@protocol ParamModel

@end

@interface ParamModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *param_key;
@property (nonatomic, strong) NSString<Optional> *param_value;

@end

@interface ServiceOrderModel : JSONModel

@property (nonatomic, assign) NSInteger order_id;
@property (nonatomic, assign) NSInteger service_id;
@property (nonatomic, strong) NSString<Optional> *service_name;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_icon;
@property (nonatomic, strong) NSString<Optional> *service_intro;
@property (nonatomic, strong) NSString<Optional> *order_state;
// 1:可现实详情 0:不显示详情
@property (nonatomic, assign) NSInteger detail_flag;
// 1:可催单 0:不可催单
@property (nonatomic, assign) NSInteger prompt_flag;
// 1:可联系 0:不可联系
@property (nonatomic, assign) NSInteger contact_flag;
@property (nonatomic, strong) NSArray<ParamModel, Optional> *param_list;

@end



@protocol ProposalOrderModel

@end

@interface ProposalOrderModel : JSONModel

@property (nonatomic, assign) NSInteger proposal_id;
@property (nonatomic, strong) NSString<Optional> *proposal_name;
// 1:正常 0:异常
@property (nonatomic, assign) NSInteger alarm_state;
@property (nonatomic, strong) NSArray<ServiceOrderModel, Optional> *order_list;

@end



@interface ProposalOrderListModel : JSONModel

@property (nonatomic, strong) NSArray<ProposalOrderModel, Optional> *proposal_order_list;
@end

//气泡详情页使用
@protocol AIProposalServiceModel

@end

@interface AIProposalServiceModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;
@property (strong, nonatomic) NSString<Optional> * service_desc;
@property (strong, nonatomic) NSString<Optional> * service_price;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;
@property (strong, nonatomic) NSString<Optional> * service_rating_icon;
@property (nonatomic, strong) ParamModel<Optional> * service_param;

@end

@protocol AIProposalProvider

@end

@interface AIProposalProvider : JSONModel

@property (assign, nonatomic) NSInteger            provider_id;
@property (strong, nonatomic) NSString<Optional> * provider_phone;

@end

@protocol AIProposalInstModel

@end

@interface AIProposalInstModel : JSONModel

@property (assign, nonatomic) NSInteger proposal_id;
@property (assign, nonatomic) NSInteger order_times;
@property (strong, nonatomic) NSString<Optional> * proposal_name;
@property (strong, nonatomic) NSString<Optional> * proposal_price;
@property (strong, nonatomic) NSString<Optional> * order_total_price;
@property (strong, nonatomic) NSString<Optional> * proposal_origin;
@property (strong, nonatomic) NSString<Optional> * proposal_desc;
@property (nonatomic, strong) AIProposalProvider<Optional> * proposal_provider;
@property (nonatomic, strong) NSArray<AIProposalServiceModel,Optional> *service_list;

@end




