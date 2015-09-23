//
//  AIMessageWrapper.h
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIMessage;
@interface AIMessageWrapper : NSObject

/*说明:获取服务列表
 */
+ (AIMessage *)getServiceListWithServiceID:(NSString *)serviceID;

/*!
 *  @author tinkl, 15-09-23 10:09:22
 *
 *  获取服务详情
 */
+ (AIMessage *)getServiceSchemeWithServiceID:(NSString *)SchemeID;


@end
