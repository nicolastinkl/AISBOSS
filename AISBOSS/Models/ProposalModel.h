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
@property (nonatomic, strong) NSArray<ParamModel, Optional> *service_param_list;

@end



@protocol ProposalModel

@end

@interface ProposalModel : JSONModel

@property (nonatomic, assign) NSInteger proposal_id;
@property (nonatomic, strong) NSString<Optional> *proposal_name;
// 1:正常 0:异常
@property (nonatomic, assign) NSInteger alarm_state;
@property (nonatomic, strong) NSArray<ServiceOrderModel, Optional> *order_list;

@end



@interface ProposalListModel : JSONModel

@property (nonatomic, strong) NSArray<ProposalModel, Optional> *proposal_order_list;
@end
