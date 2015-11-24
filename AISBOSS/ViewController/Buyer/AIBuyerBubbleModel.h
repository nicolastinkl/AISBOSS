//
//  AIBuyerBubbleModel.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIOrderPreModel.h"
#import "ProposalModel.h"

@protocol AIBuyerBubbleProportModel


@end

@interface AIBuyerBubbleProportModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;

@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;

@end


@interface AIBuyerBubbleModel : JSONModel

@property (assign, nonatomic) int bubbleType;
@property (assign, nonatomic) NSInteger bubbleSize;

@property (assign, nonatomic) NSInteger proposal_id;
@property (assign, nonatomic) NSInteger proposal_id_new;
@property (assign, nonatomic) NSInteger service_id;
@property (assign, nonatomic) NSInteger order_times;

@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;
@property (strong, nonatomic) NSString<Optional> * proposal_name;
@property (strong, nonatomic) NSString<Optional> * proposal_price;

@property (strong, nonatomic) NSArray<AIBuyerBubbleProportModel,Optional> * service_list;

@end

@protocol AIBuyerBubbleModel @end
@interface AIProposalPopListModel : JSONModel

@property (nonatomic, strong) NSArray<AIBuyerBubbleModel, Optional> *proposal_list;

@end


/// 新建详情parem list model

@protocol AIProposalListChildServiceProviderModel @end
@interface AIProposalListChildServiceProviderModel : JSONModel

@property (assign, nonatomic) NSInteger provider_id;
@property (assign, nonatomic) NSInteger provider_grade; //评分
@property (strong, nonatomic) NSString<Optional> * provider_name;
@property (strong, nonatomic) NSString<Optional> * provider_portrait_icon;

@end

@protocol AIProposalListContentChildModel @end
@interface AIProposalListContentChildModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * name;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> * icon;


@end

@protocol AIProposalListContentModel @end
@interface AIProposalListContentModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * title;
@property (strong, nonatomic) NSString<Optional> * descriptionContent;
//@property (strong, nonatomic) AIProposalListContentChildModel<Optional> * list;

@property (nonatomic, strong) ParamModel< Optional> *param;

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
@property (assign, nonatomic) NSInteger type; //类型:  语音 文本
@property (strong, nonatomic) NSString<Optional> * text;
@property (assign, nonatomic) NSInteger audio_length;
@property (strong, nonatomic) NSString<Optional> * audio_url;

@end


@interface AIProposalHopeModel : JSONModel

@property (strong, nonatomic) NSArray<AIProposalNotesModel,Optional> * label_list;
@property (strong, nonatomic) NSArray<AIProposalHopeAudioTextModel,Optional> * hope_list;

@end


/**
 *  @author tinkl, 15-11-23 10:11:32
 *
 *  @viewcontroller AIBuyerDetailViewController
 *  @brief  child list 列表模型
 *
 */

@protocol AIProposalListChildModel @end
@interface AIProposalListChildModel : JSONModel

@property (assign, nonatomic) NSInteger type;
@property (strong,nonatomic) AIProposalListChildServiceProviderModel<Optional> *service_provider;   //服务提供者模型
@property (strong,nonatomic) AIServiceModel<Optional> * service_price;//服务价格模型
@property (strong,nonatomic) AIProposalListContentModel<Optional> * service_content; //服务通用数据模型
@property (strong,nonatomic) AIProposalHopeModel<Optional> * service_hope; //服务心愿单

@end



