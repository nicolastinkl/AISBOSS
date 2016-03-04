//
//  AIServiceParamBaseView.h
//  AIVeris
//
//  Created by 王坜 on 16/1/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIServiceParamBaseView : UIControl

- (NSDictionary *)productParams;

- (NSDictionary *)serviceParams;

- (NSArray *)serviceParamsList;

- (NSArray *)productParamsList;

- (NSDictionary *)priceRelatedParam;

@end
