//
//  AINetEngine.h
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIMessage.h"

typedef NS_ENUM(NSInteger, AINetError) {
    AINetErrorFormat,                         // 报文格式错误
    AINetErrorBadNet,                         // 网络请求失败
    AINetErrorCancelled,                      // 网络请求取消
};

typedef void(^net_success_block)(NSDictionary *response);
typedef void(^net_fail_block)(AINetError error, NSString *errorDes);


@interface AINetEngine : NSObject

/*说明:获取网络单例
 */
+ (instancetype)defaultEngine;

/*说明:发送POST请求
 */
- (void)postMessage:(AIMessage *)message success:(net_success_block)success fail:(net_fail_block)fail;

/*说明:发送GET请求
 */
- (void)getMessage:(AIMessage *)message success:(net_success_block)success fail:(net_fail_block)fail;


/*说明:取消当前请求
 */
- (void)cancelMessage:(AIMessage *)message;

/*说明:取消所有请求
 */
- (void)cancelAllMessages;

@end
