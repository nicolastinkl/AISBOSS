//
//  AIProposalServiceCellModel.h
//  AIVeris
//
//  Created by 刘先 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

/*
 * 机票模型
 */
@protocol PlaneTicketModel

@end

@interface PlaneTicketModel : JSONModel

// 到达时间
@property (nonatomic, strong) NSString<Optional> *arrival_time;
// 到达地点
@property (nonatomic, strong) NSString<Optional> *arrival_place;
// 到达机场名，航站楼，登机口描述
@property (nonatomic, strong) NSString<Optional> *arrival_desc;
// 出发时间
@property (nonatomic, strong) NSString<Optional> *departure_time;
// 出发地点
@property (nonatomic, strong) NSString<Optional> *departure_place;
// 出发机场名，航站楼，登机口描述
@property (nonatomic, strong) NSString<Optional> *departure_desc;

@end



/*
 * 打车模型
 */
@protocol TaxiModel

@end

@interface TaxiModel : JSONModel

// 上车地点
@property (nonatomic, strong) NSString<Optional> *pickup_location;
// 上车时间
@property (nonatomic, strong) NSString<Optional> *pickup_time;
// 目的地点
@property (nonatomic, strong) NSString<Optional> *destination;

@end



/*
 * 纯文字描述模型
 */
@protocol TextDescModel

@end

@interface TextDescModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *desc;

@end



/*
 * 酒店模型
 */
@protocol HotelModel

@end

@interface HotelModel : JSONModel

// 入住时间
@property (nonatomic, strong) NSString<Optional> *checkin_time;
// 离店时间
@property (nonatomic, strong) NSString<Optional> *checkout_time;
// 服务设施描述
@property (nonatomic, strong) NSArray<TextDescModel, Optional> *facility_desc;

@end



/**
 *  @author wantsor, 15-11-24 10:11:32
 *
 *  @view ServiceCardDetailFlag
 *  @brief   气泡详情中的服务参数卡片标准显示模版内容模型
 *
 */
@protocol ServiceCellStadandParamModel

@end

@interface ServiceCellStadandParamModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *param_key;
@property (nonatomic, strong) NSString<Optional> *param_name;
@property (nonatomic, strong) NSString<Optional> *param_icon;
@property (nonatomic, strong) NSString<Optional> *param_value;
@property (nonatomic, strong) NSString<Optional> *product_key;
@property (nonatomic, strong) NSString<Optional> *product_name;

@end

//@protocol ServiceCellSubParamListModel
//
//@end
//
//@interface ServiceCellSubParamListModel : JSONModel
//
//@property (nonatomic, strong) NSString<Optional> *param_key;
//@property (nonatomic, strong) NSString<Optional> *param_name;
//@property (nonatomic, strong) NSString<Optional> *param_icon;
//
//@end


/**
 *  @author wantsor, 15-11-24 10:11:32
 *
 *  @view ServiceCardDetailShopping
 *  @brief   气泡详情中的购物清单参数卡片内容模型
 *
 */
@protocol ServiceCellShoppingItemModel

@end

@interface ServiceCellShoppingItemModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *item_intro;
@property (nonatomic, strong) NSString<Optional> *item_icon;

@end

/**
 *  @author wantsor, 15-11-24 10:11:32
 *
 *  @view ServiceCardDetailFlag
 *  @brief   气泡详情中的服务参数卡片内容模型
 *
 */
@protocol ServiceCellProductParamModel

@end
@interface ServiceCellProductParamModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *param_key;
@property (nonatomic, strong) NSString<Optional> *product_name;
@property (nonatomic, strong) NSString<Optional> *product_sub_name;
@property (nonatomic, strong) NSArray<ServiceCellStadandParamModel,Optional> *param_list;
@property (nonatomic, strong) NSArray<ServiceCellShoppingItemModel,Optional> *item_list;
@end


@interface ServiceCellStandardParamListModel : JSONModel

@property (nonatomic, strong) NSArray<ServiceCellStadandParamModel,Optional> *param_list;

@end


@interface ServiceCellShoppingModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *product_name;
@property (nonatomic, strong) NSString<Optional> *product_sub_name;
@property (nonatomic, strong) NSArray<ServiceCellShoppingItemModel,Optional> *item_list;

@end
