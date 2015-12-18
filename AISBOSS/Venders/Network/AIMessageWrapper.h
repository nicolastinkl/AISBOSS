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

/*说明：新增心愿单笔记
 *  @author Wang Li, 15-09-23 10:09:22
 *
 *
 */
+ (AIMessage *)addWishNoteWithWishID:(NSInteger)wishID type:(NSString *)type content:(NSString *)content;

/*说明：删除心愿单笔记
 *  @author Wang Li, 15-09-23 10:09:22
 *
 *
 */
+ (AIMessage *)deleteWishNoteWithWishID:(NSInteger)wishID noteID:(NSInteger)noteID;

@end
