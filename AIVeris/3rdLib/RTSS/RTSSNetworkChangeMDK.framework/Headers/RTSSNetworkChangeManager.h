//
//  RTSSNetworkChangeManager.h
//  RTSSNetworkChangeMDK
//
//  Created by 王晓睿 on 16/5/16.
//  Copyright © 2016年 王晓睿. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RTSSNetworkChangeManager : NSObject

+ (RTSSNetworkChangeManager *)sharedManager;

/**
 *  @brief 根据不同渠道的AppId区分。2020实验室APP 的AppID：	4623d1ac-b802-4f0d-8a74-60aaa2a64b9c
 */
@property (nonatomic,copy) NSString *appid;


// token 依赖于 tokenType
// tokenType:  0:token为CustomerId 1:token为手机号
- (void)setTokenType:(int)tokenType token:(NSString *)token;

// 设置pushMessage发送地址和端口
- (void)setServerHost:(NSString *)serverHost serverPort:(short)serverPort;

// 开始监听网络切换
- (void)startNotifierNetworkChange;

// 停止监听网络切换
- (void)stopNotifierNetworkChange;

@end
