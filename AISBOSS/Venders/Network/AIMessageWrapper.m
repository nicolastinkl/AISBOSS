//
//  AIMessageWrapper.m
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIMessageWrapper.h"
#import "AIMessage.h"
#import "AIServerConfig.h"


@implementation AIMessageWrapper


#pragma mark - 获取服务列表

+ (AIMessage *)getServiceListWithServiceID:(NSString *)serviceID
{
    AIMessage *message = [AIMessage message];
    [message.body setObject:serviceID forKey:kKey_ServiceID];
    message.url = kURL_GetServiceList;
    
    return message;
}


+ (AIMessage *)getServiceSchemeWithServiceID:(NSString *)SchemeID
{
    AIMessage *message = [AIMessage message];
    
    NSDictionary *body = @{@"data":@{@"sheme_id":@(401)},@"desc":@{@"data_mode":@"0",@"digest":@""}};
    
    [message.body addEntriesFromDictionary:body];

    message.url = kURL_GetSchemeList;
    return message;
    
}
@end
