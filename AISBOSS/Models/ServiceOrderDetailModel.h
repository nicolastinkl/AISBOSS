//
//  ServiceOrderDetailModel.h
//  AIVeris
//
//  Created by Rocky on 15/10/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#ifndef ServiceOrderDetailModel_h
#define ServiceOrderDetailModel_h

#import "JSONModel.h"

@protocol GoodsDetailItemModel

@end

@protocol GoodsList

@end


@interface GoodsListMode : JSONModel

@property (nonatomic, strong) NSArray<GoodsDetailItemModel, Optional> *item_list;

@end


@interface GoodsDetailItemModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *item_desc;
@property (nonatomic, strong) NSString<Optional> *item_price;
@property (nonatomic, strong) NSString<Optional> *item_state;
@property (nonatomic, strong) NSString<Optional> *item_url;

@end

#endif /* ServiceOrderDetailModel_h */
