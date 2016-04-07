//
//  AINetEngine.m
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AINetEngine.h"
#import "ProposalModel.h"
#import "AFNetworking.h"

#define kTimeoutIntervalForRequest     60

#define kKeyForDesc                    @"desc"
#define kKeyForData                    @"data"
#define kKeyForResultCode              @"result_code"
#define kKeyForResultMsg               @"result_msg"
#define kSuccessCode                   @"200"
#define kSuccessCode_1                 @"1"

@interface AINetEngine ()
{
    NSURLSessionConfiguration *_sessionConfiguration;
    AFHTTPSessionManager *_sessionManager;
    
}

@property (nonatomic, strong) NSMutableDictionary *commonHeaders;

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
        self.commonHeaders = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addHeaders:(NSDictionary *)headers
{
    NSMutableDictionary *allHeaders = [[NSMutableDictionary alloc] init];
    [allHeaders addEntriesFromDictionary:self.commonHeaders];
    [allHeaders addEntriesFromDictionary:headers];
    
    NSLog(@"allHeaders:%@\n", allHeaders);
    
    for (NSString *key in allHeaders.allKeys) {
        id value = [allHeaders objectForKey:key];
        [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}



#pragma mark - 发送POST请求

- (void)postMessage:(AIMessage *)message success:(net_success_block)success fail:(net_fail_block)fail
{
    // 设置头部
    [self addHeaders:message.header];
    	
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *curTask = [_sessionManager POST:message.url parameters:message.body success:^(NSURLSessionDataTask *task, id responseObject) {    
        
        if (responseObject) {
            NSInteger length = [[NSString stringWithFormat:@"%@",responseObject] length];
            NSLog(@"responseObject lenght:%ld",(long)length);
            if (length > 170 && [responseObject isKindOfClass:[NSDictionary class]]) {
                //长度200 判断不准确，长度200以下也可能是成功的  {"data":{"result":"1"},"desc":{"result_code":"200","result_msg":"success","data_mode":"0","digest":""}}
                
                [weakSelf parseSuccessResponseWithTask:task
                                        responseObject:responseObject
                                               success:success
                                                  fail:nil];
            }else{
                [weakSelf parseFailResponseWithTask:task
                                              error:[NSError errorWithDomain:@"Null Data" code:-1 userInfo:nil]                                            success:nil fail:fail];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf parseFailResponseWithTask:task
                                      error:error
                                    success:nil fail:fail];
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


#pragma mark - 设置通用header

#pragma mark - 增加默认header

- (void)configureCommonHeaders:(NSDictionary *)header
{
    [self.commonHeaders addEntriesFromDictionary:header];
}


- (void)removeCommonHeaders
{
    [self.commonHeaders removeAllObjects];
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
    
    
    NSDictionary *response = nil;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        response = (NSDictionary *)responseObject;
    }
    
    if (!response && fail) {
        fail(AINetErrorFormat, @"报文格式错误");
        return;
    }

    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray * newRes = (NSArray *)responseObject;
        if (newRes.count <= 0 ){
            fail(AINetErrorFormat, @"返回值为空");
            return;
        }
        
    }
    
    NSDictionary *des = [response objectForKey:kKeyForDesc];
    id returnResponseObject = [response objectForKey:kKeyForData];
    
    NSString *resultCode = [NSString stringWithFormat:@"%@",[des objectForKey:kKeyForResultCode]];
    
    if ([resultCode isKindOfClass:[NSString class]] && ([resultCode isEqualToString:kSuccessCode] || [resultCode isEqualToString:kSuccessCode_1] ) && success) {

        success(returnResponseObject);
    } else {
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


- (void)testPostMessage:(AIMessage *)message{
    
    [self postMessage:message success:^(id responseObject) {
        NSError *myerror = nil;
        AIProposalInstModel * proModel = [[AIProposalInstModel alloc] initWithDictionary:responseObject error:&myerror];
        JMLog(@"myerror.description: %@ %@", myerror.description,proModel.proposal_name);
 
    } fail:^(AINetError error, NSString *errorDes) {
        JMLog(@"errorDes: %@", errorDes);
    }];
}

@end
