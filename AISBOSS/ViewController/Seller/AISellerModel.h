//
//  AISellerModel.h
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kSeller_ButtonType                     @"ButtonType"
#define kSeller_ButtonImageNormal              @"ButtonImageNormal"
#define kSeller_ButtonImageHighLighted         @"ButtonImageHighLighted"
#define kSeller_ButtonImageSelected            @"ButtonImageSelected"

#define kSeller_Stage                          @"Stage"
#define kSeller_StageImage                     @"StageImage"
#define kSeller_ProgressPercent                @"ProgressPercent"

#define kSeller_GoodsIcon                      @"GoodsIcon"
#define kSeller_GoodsClass                     @"GoodsClass"
#define kSeller_GoodsName                      @"GoodsName"
//


#define kSeller_SellerIcon                     @"SellerIcon"
#define kSeller_SellerName                     @"SellerName"
#define kSeller_MessageNum                     @"MessageNum"
#define kSeller_GoodsPrice                     @"GoodsPrice"
#define kSeller_SellerIcons                     @"SellerIcons"
#define kSeller_Timestamp                      @"Timestamp"
#define kSeller_Location                       @"Location"
#define kSeller_ButtonType                         @"ButtonType"
#define kSeller_Progress                       @"Progress"
#define kSeller_Goods                          @"Goods"
#define kSeller_ColorType                      @"ColorType"

@interface AISellerModel : NSObject


@property (nonatomic, strong) UIImage *sellerIcon;

@property (nonatomic, strong) NSString *sellerName;

@property (nonatomic, strong) NSString *messageNum;

@property (nonatomic, strong) NSString *goodsPrice;

@property (nonatomic, strong) NSArray *sellerIcons;

@property (nonatomic, strong) NSString *timestamp;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) NSInteger buttonType;

@property (nonatomic, strong) NSDictionary *progress;

@property (nonatomic, strong) NSDictionary *goods;

@property (nonatomic, assign) NSInteger colorType;


- (id)initWithContent:(NSDictionary *)content;


@end
