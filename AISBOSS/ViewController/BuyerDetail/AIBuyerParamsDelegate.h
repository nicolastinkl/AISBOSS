//
//  AIBuyerParamsDelegate.h
//  AIVeris
//
//  Created by 王坜 on 15/12/9.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AIBuyerParamsDelegate <NSObject>

@optional

- (void)didChangeParams:(NSDictionary *)params;


@end

