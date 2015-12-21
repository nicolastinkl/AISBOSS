//
//  ProposalModel.h
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@protocol ServiceOrderModel
@end

@protocol ParamModel
@end

@protocol AIProposalServiceDetailParamModel
@end

@protocol AIProposalServiceDetailParamValueModel
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
@property (strong, nonatomic) NSArray<AIProposalHopeAudioTextModel, Optional> * hope_list;

@end


//气泡详情页使用
@protocol AIProposalServicePriceModel @end
@interface AIProposalServicePriceModel : JSONModel
@property (strong, nonatomic) NSString<Optional> * original;
@property (strong, nonatomic) NSString<Optional> * discount;
@property (strong, nonatomic) NSString<Optional> * saved;

@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) NSString<Optional> * billing_mode;
@property (strong, nonatomic) NSString<Optional> * unit;
@end





// 服务参数设置标记
typedef NS_ENUM(NSInteger, ParamSettingFlag) {
    ParamSettingFlagUnset,
    ParamSettingFlagSet
};


@class AIBueryDetailCell;




@interface AIProposalServiceDetailParamModel : JSONModel

@property (assign, nonatomic) NSInteger param_key;
@property (assign, nonatomic) NSInteger param_type;
@property (strong, nonatomic) NSString<Optional> * param_name;
@property (strong, nonatomic) NSString<Optional> * param_source;
@property (assign, nonatomic) NSInteger param_source_id;
@property (strong, nonatomic) NSString<Optional> * value;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailParamValueModel, Optional> * param_value;

@end


// 关系中的相关参数
@protocol AIRelationParamItemModel
@end

@interface AIRelationParamItemModel : JSONModel

@property (assign, nonatomic) long param_service;
@property (assign, nonatomic) long param_role;
@property (assign, nonatomic) long param_key;
@property (strong, nonatomic) NSString<Optional> * param_value;
@property (assign, nonatomic) long param_value_key;

@end


// 关系
@protocol AIParamRelationModel
@end

@interface AIParamRelationModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * relationship;

@end



//服务参数关系
@protocol AIProposalServiceParamRelationModel
@end

@interface AIProposalServiceParamRelationModel : JSONModel

@property (nonatomic, strong) AIRelationParamItemModel<Optional> * param;
@property (nonatomic, strong) AIParamRelationModel<Optional> * relationship;
@property (nonatomic, strong) AIRelationParamItemModel<Optional> * rel_param;

@end



@protocol AIProposalServiceModel @end


@interface AIProposalServiceModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;
@property (strong, nonatomic) NSString<Optional> * state;
@property (assign, nonatomic) NSInteger set_flag;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) NSInteger service_rating_level;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;
@property (strong, nonatomic) NSString<Optional> * service_desc;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailParamModel, Optional> * service_param_list;
@property (nonatomic, strong) NSArray<AIProposalServiceParamRelationModel, Optional> * service_param_rel_list;
@property (assign, nonatomic) NSInteger param_setting_flag;
@property (nonatomic, assign) NSInteger service_del_flag;
@property (nonatomic, assign) NSInteger is_deletable;

@property (nonatomic, strong) AIBueryDetailCell<Optional> *cell;


@property (assign, nonatomic) NSInteger is_main_flag;
@property (assign, nonatomic) NSInteger is_delemode;

@property (strong, nonatomic) AIProposalServicePriceModel<Optional> * service_price;

@property (strong, nonatomic) NSString<Optional> * service_rating_icon;
@property (strong, nonatomic) ParamModel<Optional> * service_param;

@property (strong, nonatomic) AIProposalHopeModel<Optional> * wish_list; //服务心愿单


@end

@protocol AIProposalProvider @end
@interface AIProposalProvider : JSONModel

@property (assign, nonatomic) NSInteger            provider_id;
@property (strong, nonatomic) NSString<Optional> * provider_phone;

@end

/**
 *  @author tinkl, 15-11-24 09:11:55
 *
 *  @brief  Proposal详情模型
 *
 */
@protocol AIProposalInstModel @end

@interface AIProposalInstModel : JSONModel

@property (assign, nonatomic) NSInteger proposal_id;
@property (strong, nonatomic) NSString<Optional> * proposal_name;
@property (strong, nonatomic) NSString<Optional> * proposal_desc;
@property (strong, nonatomic) NSString<Optional> * proposal_owner;
@property (assign, nonatomic) NSInteger order_times;
@property (nonatomic, strong) NSArray<AIProposalServiceModel, Optional> *service_list;
@property (strong, nonatomic) NSString<Optional> * proposal_price;
@property (strong, nonatomic) NSString<Optional> * proposal_origin;
@property (strong, nonatomic) NSString<Optional> * order_total_price;
@property (nonatomic, strong) AIProposalProvider<Optional> * proposal_provider;

@end

//==================================== AIProposalServiceDetailModel =============================================

//service_intro_img_list
@protocol AIProposalServiceDetailIntroImgModel @end
@interface AIProposalServiceDetailIntroImgModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * service_intro_img;

@end

//service_provider
@protocol AIProposalServiceDetailProviderModel @end
@interface AIProposalServiceDetailProviderModel : JSONModel

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (strong, nonatomic) NSString<Optional> * portrait_icon;

@end

//service_param_list


@interface AIProposalServiceDetailParamValueModel : JSONModel

@property (assign, nonatomic) long id;
@property (strong, nonatomic) NSString<Optional> * content;
@property (assign, nonatomic) BOOL is_default;
@property (strong, nonatomic) NSString<Optional> * source;
//@property (strong, nonatomic) NSString<Optional> * value_key;
//@property (strong, nonatomic) NSString<Optional> * value_display;

@end




// service_rating
@protocol AIProposalServiceDetailRatingItemModel @end
@interface AIProposalServiceDetailRatingItemModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * name;
@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) NSInteger priority;
@end

//comment
@protocol AIProposalServiceDetailRatingCommentModel @end
@interface AIProposalServiceDetailRatingCommentModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * time;
@property (strong, nonatomic) NSString<Optional> * content;
@property (assign, nonatomic) NSInteger rating_level;
@property (nonatomic, strong) AIProposalServiceDetailProviderModel<Optional> * service_customer;

@end

@protocol AIProposalServiceDetailRatingModel @end
@interface AIProposalServiceDetailRatingModel : JSONModel

@property (assign, nonatomic) NSInteger reviews;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailRatingItemModel, Optional> * rating_level_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailRatingCommentModel, Optional> * comment_list;
@end

//wish list

@protocol AIProposalServiceDetailLabelModel @end
@interface AIProposalServiceDetailLabelModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * content;
@property (assign, nonatomic) NSInteger selected_num;
@property (assign, nonatomic) NSInteger selected_flag;
@property (assign, nonatomic) NSInteger label_id;

@end

@protocol AIProposalServiceDetailHopeModel @end
@interface AIProposalServiceDetailHopeModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * text;
@property (strong, nonatomic) NSString<Optional> * audio_url;
@property (assign, nonatomic) NSInteger type;//1 text  2 audio
@property (strong, nonatomic) NSString<Optional> *noteType;//1 text  2 audio
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) NSInteger hope_id;

@end

@protocol AIProposalServiceDetail_WishModel @end
@interface AIProposalServiceDetail_WishModel : JSONModel
@property (nonatomic, assign) NSInteger wish_id;
@property (strong, nonatomic) NSString<Optional> * intro;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailLabelModel, Optional> * label_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailHopeModel, Optional> * hope_list;

@end

/**
 *  @author tinkl, 15-12-01 10:12:26
 *
 *  @brief  心愿详情界面 url: http://171.221.254.231:3000/findServiceDetail
 *  @ViewController AIServiceContentViewController
 */
@interface AIProposalServiceDetailModel : JSONModel

@property (assign, nonatomic) long service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_intro_title;
@property (strong, nonatomic) NSString<Optional> * service_intro_content;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_url;
@property (strong, nonatomic) ParamModel<Optional> * service_param;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailIntroImgModel, Optional> *service_intro_img_list;
@property (nonatomic, strong) AIProposalServicePriceModel<Optional> * service_price;
@property (strong, nonatomic) NSString<Optional> * service_guarantee;
@property (strong, nonatomic) NSString<Optional> * service_restraint;
@property (strong, nonatomic) NSString<Optional> * service_process;
@property (strong, nonatomic) NSString<Optional> * service_exectime;
@property (nonatomic, strong) AIProposalServiceDetailProviderModel<Optional> * service_provider;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailParamModel, Optional> * service_param_list;
@property (nonatomic, strong) NSArray<AIProposalServiceParamRelationModel, Optional> * service_param_rel_list;

@property (nonatomic, strong) AIProposalServiceDetailRatingModel<Optional> * service_rating;
@property (nonatomic, strong) AIProposalServiceDetail_WishModel<Optional> * wish_list;
@property (nonatomic, strong) NSArray<AIProposalServiceDetailRatingCommentModel, Optional> *comment_list;

@end



