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

+ (AIMessage *)addWishNoteWithWishID:(NSInteger)wishID type:(NSString *)type content:(NSString *)content  duration:(NSInteger)duration
{
    AIMessage *message = [AIMessage message];
    NSDictionary *body = @{@"data":@{@"wish_id":@(wishID),@"note_type":type,@"note_content":content,@"duration":@(duration)},@"desc":@{@"data_mode":@"0",@"digest":@""}};
    
    [message.body addEntriesFromDictionary:body];
    
    message.url = kURL_AddWishNote;
    return message;
}


+ (AIMessage *)deleteWishNoteWithWishID:(NSInteger)wishID noteID:(NSInteger)noteID
{
    AIMessage *message = [AIMessage message];
    
    NSDictionary *body = @{@"data":@{@"wish_id":@(wishID),@"note_id":@(noteID)},@"desc":@{@"data_mode":@"0",@"digest":@""}};
    
    [message.body addEntriesFromDictionary:body];
    
    message.url = kURL_DelWishNote;
    return message;
}


+ (AIMessage *) updateWiskListTagStateWishID:(NSInteger)wishID tagID:(NSInteger)tagID isChoose:(Boolean) ischoose{
    AIMessage *message = [AIMessage message];
    
    NSDictionary *body = @{@"data":@{@"wish_id":@(wishID),@"tag_list":@[@{@"id":@(tagID),@"is_chosen":@(ischoose)}]},@"desc":@{@"data_mode":@"0",@"digest":@""}};
    
    [message.body addEntriesFromDictionary:body];
    
    message.url = kURL_UpateWishTagListID;
    return message;
}



@end
