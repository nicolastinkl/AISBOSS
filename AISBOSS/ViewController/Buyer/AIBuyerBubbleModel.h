//
//  AIBuyerBubbleModel.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIOrderPreModel.h"

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

@protocol AIBuyerBubbleModel


@end


@interface AIProposalPopListModel : JSONModel

@property (nonatomic, strong) NSArray<AIBuyerBubbleModel, Optional> *proposal_list;

@end


@protocol AIProposalListChildServiceProviderModel


@end


@interface AIProposalListChildServiceProviderModel : JSONModel

@property (assign, nonatomic) NSInteger provider_id;
@property (assign, nonatomic) NSInteger provider_grade; //评分
@property (strong, nonatomic) NSString<Optional> * provider_name;
@property (strong, nonatomic) NSString<Optional> * provider_portrait_icon;

@end

@protocol AIProposalListContentChildModel

@end

@interface AIProposalListContentChildModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * name;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString<Optional> * icon;


@end

@protocol AIProposalListContentModel

@end

@interface AIProposalListContentModel : JSONModel

@property (strong, nonatomic) NSString<Optional> * title;
@property (strong, nonatomic) NSString<Optional> * descriptionContent;
@property (strong, nonatomic) AIProposalListContentChildModel<Optional> * list;

@end

@protocol AIProposalCommentodel

@end

@interface AIProposalCommentodel : JSONModel
@property (strong, nonatomic) NSString<Optional> * title;
@property (strong, nonatomic) NSArray<Optional> * label;

@end


/**
 *  @author tinkl, 15-11-23 10:11:32
 *
 *  @brief  child list 列表模型
 *
 */
@interface AIProposalListChildModel : JSONModel

@property (assign, nonatomic) NSInteger type;

@property (strong,nonatomic) AIProposalListChildServiceProviderModel<Optional> *service_provider;   //服务提供者模型
@property (strong,nonatomic) AIServiceModel<Optional> * service_price;//服务价格模型
@property (strong,nonatomic) AIProposalListContentModel<Optional> * service_content; //服务通用数据模型
@property (strong,nonatomic) AIProposalCommentodel<Optional> * service_comment; //服务最新评价

@end



