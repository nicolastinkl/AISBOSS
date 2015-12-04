//
//  ProposalModel.h
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"


@protocol ServiceOrderModel @end

@protocol ParamModel @end

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



@protocol ProposalOrderModel @end

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
 

//心愿标签
@protocol AIProposalNotesModel @end
@interface AIProposalNotesModel : JSONModel

@property (assign, nonatomic) NSInteger h_id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString<Optional> * color;

@end

//文本语音心愿
@protocol AIProposalHopeAudioTextModel @end
@interface AIProposalHopeAudioTextModel : JSONModel

@property (assign, nonatomic) NSInteger at_id;
@property (assign, nonatomic) NSInteger type; //类型:  语音0 文本1
@property (strong, nonatomic) NSString<Optional> * text;
@property (assign, nonatomic) NSInteger audio_length;
@property (strong, nonatomic) NSString<Optional> * audio_url;
@property (assign, nonatomic) NSInteger timer;
@end


@protocol AIProposalHopeModel @end
@interface AIProposalHopeModel : JSONModel

@property (strong, nonatomic) NSArray<AIProposalNotesModel,Optional> * label_list;
@property (strong, nonatomic) NSArray<AIProposalHopeAudioTextModel,Optional> * hope_list;

@end


//气泡详情页使用
@protocol AIProposalServicePriceModel @end
@interface AIProposalServicePriceModel : JSONModel
@property (strong, nonatomic) NSString<Optional> * original;
@property (strong, nonatomic) NSString<Optional> * discount;
@property (strong, nonatomic) NSString<Optional> * saved;
@end

@protocol AIProposalServiceModel @end


// 服务参数设置标记
typedef NS_ENUM(NSInteger, ParamSettingFlag) {
    ParamSettingFlagUnset,
    ParamSettingFlagSet
};


@interface AIProposalServiceModel : JSONModel

@property (nonatomic, assign) NSInteger is_deleted_flag;
@property (nonatomic, assign) NSInteger is_deletable;

@property (assign, nonatomic) NSInteger service_id;
@property (assign, nonatomic) NSInteger is_main_flag;
@property (strong, nonatomic) NSString<Optional> * service_desc;
@property (strong, nonatomic) AIProposalServicePriceModel<Optional> * service_price;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;
@property (strong, nonatomic) NSString<Optional> * service_rating_icon;
@property (strong, nonatomic) ParamModel<Optional> * service_param;
@property (assign, nonatomic) NSInteger param_setting_flag;
@property (strong, nonatomic) AIProposalHopeModel<Optional> * wish_list; //服务心愿单
@property (assign, nonatomic) NSInteger service_rating_level;

@end

@protocol AIProposalProvider @end
@interface AIProposalProvider : JSONModel

@property (assign, nonatomic) NSInteger            provider_id;
@property (strong, nonatomic) NSString<Optional> * provider_phone;

@end

/**
 *  @author tinkl, 15-11-24 09:11:55
 *
 *  @brief  服务详情模型
 *
 */
@protocol AIProposalInstModel @end

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

//==================================== AIProposalServiceDetailModel =============================================

//service_intro_img_list
@protocol AIProposalServiceDetail_Intro_img_listModel @end
@interface AIProposalServiceDetail_Intro_img_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * service_intro_img;

@end

//service_provider
@protocol AIProposalServiceDetail_provider_listModel @end
@interface AIProposalServiceDetail_provider_listModel : JSONModel

@property (assign, nonatomic) NSInteger provider_id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (strong, nonatomic) NSString<Optional> * portrait_icon;

@end

//service_param_list

@protocol AIProposalServiceDetail_Param_Value_listModel @end
@interface AIProposalServiceDetail_Param_Value_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * value_key;
@property (strong, nonatomic) NSString<Optional> * value_display;

@end

@protocol AIProposalServiceDetail_Param_listModel @end
@interface AIProposalServiceDetail_Param_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * param_key;
@property (strong, nonatomic) NSString<Optional> * param_type;
@property (strong, nonatomic) NSString<Optional> * param_name;
@property (strong, nonatomic) NSString<Optional> * param_source;
@property (strong, nonatomic) NSString<Optional> * param_product_id;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Param_Value_listModel,Optional> * param_value;

@end

// service_rating
@protocol AIProposalServiceDetail_Rating_List_Item_listModel @end
@interface AIProposalServiceDetail_Rating_List_Item_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * name;
@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) NSInteger priority;
@end

//comment
@protocol AIProposalServiceDetail_Rating_Comment_listModel @end
@interface AIProposalServiceDetail_Rating_Comment_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * time;
@property (strong, nonatomic) NSString<Optional> * content;
@property (assign, nonatomic) NSInteger rating_level;
@property (nonatomic, strong) AIProposalServiceDetail_provider_listModel<Optional> * service_customer;

@end

@protocol AIProposalServiceDetail_Rating_listModel @end
@interface AIProposalServiceDetail_Rating_listModel : JSONModel

@property (assign, nonatomic) NSInteger reviews;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Rating_List_Item_listModel,Optional> * rating_level_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Rating_Comment_listModel,Optional> * comment_list;
@end

//wish list

@protocol AIProposalServiceDetail_label_list_listModel @end
@interface AIProposalServiceDetail_label_list_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * content;
@property (assign, nonatomic) NSInteger selected_num;
@property (assign, nonatomic) NSInteger selected_flag;
@property (assign, nonatomic) NSInteger label_id;

@end

@protocol AIProposalServiceDetail_hope_list_listModel @end
@interface AIProposalServiceDetail_hope_list_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * text;
@property (strong, nonatomic) NSString<Optional> * audio_url;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) NSInteger hope_id;

@end

@protocol AIProposalServiceDetail_wish_list_listModel @end
@interface AIProposalServiceDetail_wish_list_listModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * intro;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_label_list_listModel,Optional> * label_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_hope_list_listModel,Optional> * hope_list;

@end

/**
 *  @author tinkl, 15-12-01 10:12:26
 *
 *  @brief  心愿详情界面 url: http://171.221.254.231:3000/findServiceDetailFake
 *  @ViewController AIServiceContentViewController
 */
@interface AIProposalServiceDetailModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_intro_title;
@property (strong, nonatomic) NSString<Optional> * service_intro_content;

@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Intro_img_listModel,Optional> *service_intro_img_list;
@property (nonatomic, strong) AIProposalServicePriceModel<Optional> * service_price;
@property (nonatomic, strong) AIProposalServiceDetail_provider_listModel<Optional> * service_provider;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Param_listModel,Optional> * service_param_list;
@property (nonatomic, strong) AIProposalServiceDetail_Rating_listModel<Optional> * service_rating;
@property (nonatomic, strong) AIProposalServiceDetail_wish_list_listModel<Optional> * wish_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetail_Rating_Comment_listModel, Optional> *comment_list;



@end



