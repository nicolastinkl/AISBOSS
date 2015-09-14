//
//  AISellerModel.m
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellerModel.h"


@interface AISellerModel ()

@property (nonatomic, strong) NSDictionary *sellerContent;

@end

@implementation AISellerModel

- (id)initWithContent:(NSDictionary *)content
{
    self = [super init];
    if (self) {
        self.sellerContent = content;
        [self parseContent:content];
    }
    
    return self;
}


- (void)parseContent:(NSDictionary *)content
{
    self.sellerIcon = [UIImage imageNamed:[content objectForKey:kSeller_SellerIcon]];
    self.sellerName = [content objectForKey:kSeller_SellerName];
    self.messageNum = [content objectForKey:kSeller_MessageNum];
    self.goodsPrice = [content objectForKey:kSeller_GoodsPrice];
    self.sellerIcons = [content objectForKey:kSeller_SellerIcons];
    self.timestamp  = [content objectForKey:kSeller_Timestamp];
    self.location   = [content objectForKey:kSeller_Location];
    self.buttonType     = [[content objectForKey:kSeller_ButtonType] integerValue];
    self.progress   = [content objectForKey:kSeller_Progress];
    self.goods      = [content objectForKey:kSeller_Goods];
    self.colorType = [[content objectForKey:kSeller_ColorType] integerValue];
}

@end
