//
//  AIProposalServiceCellModel.h
//  AIVeris
//
//  Created by 刘先 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

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
 *  @view ServiceCardDetailFlag
 *  @brief   气泡详情中的服务参数卡片内容模型
 *
 */
@interface ServiceCellProductParamModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *product_name;
@property (nonatomic, strong) NSArray<ServiceCellStadandParamModel,Optional> *param_list;

@end


@interface ServiceCellStandardParamListModel : JSONModel

@property (nonatomic, strong) NSArray<ServiceCellStadandParamModel,Optional> *param_list;

@end

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

@interface ServiceCellShoppingModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *product_name;
@property (nonatomic, strong) NSString<Optional> *product_sub_name;
@property (nonatomic, strong) NSArray<ServiceCellShoppingItemModel,Optional> *item_list;

@end
