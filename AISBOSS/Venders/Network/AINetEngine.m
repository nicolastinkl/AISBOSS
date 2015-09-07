//
//  AINetEngine.m
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AINetEngine.h"
//#import "AITrans-Swift.h"
#import "AFNetworking.h"

#define kTimeoutIntervalForRequest     60

#define kKeyForDesc                    @"desc"
#define kKeyForData                    @"data"
#define kKeyForResultCode              @"result_code"
#define kKeyForResultMsg               @"result_msg"
#define kSuccessCode                   1

@interface AINetEngine ()
{
    NSMutableArray *_activitedTask;
    NSURLSessionConfiguration *_sessionConfiguration;
    AFHTTPSessionManager *_sessionManager;
    
}

@end

@implementation AINetEngine


+ (instancetype)defaultEngine
{
    static AINetEngine *gInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        gInstance = [[AINetEngine alloc] init];
    });
    
    return gInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _activitedTask = [[NSMutableArray alloc] init];
        
        // 创建sessionManager
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        
        _sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        _sessionManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    }
    
    return self;
}

- (void)addHeaders:(NSDictionary *)headers
{
    for (NSString *key in headers.allKeys) {
        id value = [headers objectForKey:key];
        [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

- (void)removeHeaders:(NSDictionary *)headers
{
    
}

#pragma mark - 发送POST请求

- (void)postMessage:(AIMessage *)message success:(net_success_block)success fail:(net_fail_block)fail
{
    // 设置头部
    [self addHeaders:message.header];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *curTask = [_sessionManager POST:message.url parameters:message.body success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf parseSuccessResponseWithTask:task
                                responseObject:responseObject
                                       success:success
                                          fail:fail];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf parseFailResponseWithTask:task
                                      error:error
                                    success:success fail:fail];
    }];
    
    // 添加到task队列
    message.uniqueID = curTask.taskIdentifier;
    [_activitedTask addObject:curTask];

}

#pragma mark - 发送GET请求

- (void)getMessage:(AIMessage *)message success:(net_success_block)success fail:(net_fail_block)fail
{
    // 设置头部
    [self addHeaders:message.header];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *curTask = [_sessionManager GET:message.url parameters:message.body success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf parseSuccessResponseWithTask:task
                                responseObject:responseObject
                                       success:success
                                          fail:fail];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf parseFailResponseWithTask:task
                                      error:error
                                    success:success
                                       fail:fail];

    }];
    
    // 添加到task队列
    message.uniqueID = curTask.taskIdentifier;
    [_activitedTask addObject:curTask];
}

#pragma mark - 取消当前请求

- (void)cancelMessage:(AIMessage *)message
{
    for (NSURLSessionDataTask *task in _activitedTask) {
        if (task.taskIdentifier == message.uniqueID) {
            [task cancel];
            [_activitedTask removeObject:task];
            break;
        }
    }
    
}


#pragma mark - 取消所有请求

- (void)cancelAllMessages
{
    for (NSURLSessionDataTask *task in _activitedTask) {
        [task cancel];
    }
    
    [_activitedTask removeAllObjects];
}

#pragma mark - Member Method

- (void)removeCompletedTask:(NSURLSessionDataTask *)task
{
    [_activitedTask removeObject:task];
}

- (void)parseSuccessResponseWithTask:(NSURLSessionDataTask *)task
                      responseObject:(id)responseObject
                             success:(net_success_block)success
                                fail:(net_fail_block)fail
{
    [self removeCompletedTask:task];
    NSDictionary *response = (NSDictionary *)responseObject;
    if (!response && fail) {
        fail(AINetErrorFormat, @"报文格式错误");
    }
    
    NSDictionary *des = [response objectForKey:kKeyForDesc];
    
    NSNumber *resultCode = [des objectForKey:kKeyForResultCode];
    
    if ([resultCode isEqualToNumber:[NSNumber numberWithInteger:kSuccessCode]] && success) {
        success(response);
    }
    else
    {
        NSString *errorDes = [des objectForKey:kKeyForResultMsg];
        fail(AINetErrorFormat, errorDes);
    }
}

- (void)parseFailResponseWithTask:(NSURLSessionDataTask *)task
                            error:(NSError *)error
                          success:(net_success_block)success
                             fail:(net_fail_block)fail
{
    [self removeCompletedTask:task];
    
    AINetError netError = [self netErrorFromNSError:error];
    if (fail && netError != AINetErrorCancelled) {
        fail(netError, [error localizedDescription]);
    }
}

- (AINetError)netErrorFromNSError:(NSError *)error
{
    AINetError netError = AINetErrorBadNet;
    
    if (error.code == NSURLErrorCancelled) {
        netError = AINetErrorCancelled;
    }
    
    return netError;
}


@end
