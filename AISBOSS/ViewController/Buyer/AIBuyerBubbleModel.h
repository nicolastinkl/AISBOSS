//
//  AIBuyerBubbleModel.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol AIBuyerBubbleProportModel


@end

@interface AIBuyerBubbleProportModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;

@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;

@end


@interface AIBuyerBubbleModel : JSONModel

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
