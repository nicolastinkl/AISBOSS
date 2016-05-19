//
//  MessageBusManager.h
//  MQTTMDK
//
//  Created by shengyp on 15/11/16.
//  Copyright © 2015年 shengyp. All rights reserved.
//

#import "MQTTKit.h"

@interface MessageBusManager : NSObject

+ (NSString *)getClientId;
// saas业务平台接口规范
+ (NSString *)getDeviceMotionTopic;
+ (NSString *)getHealthTopic;
+ (NSString *)getIBeaconTopic;
+ (NSString *)getShakeTopic;
+ (NSString *)getNetworkChangeTopic;
// 其他
+ (NSString *)getIotTopic;
+ (NSString *)getCarInstructionTopic;
+ (NSString *)getCarStateTopic;
+ (NSString *)getRedEnvelopeTopic;
+ (NSString *)getRedEnvelopeCountTopic;
+ (NSString *)getBuyNowTopic;
+ (NSString *)getMessageDataTopic;

#define messageDataTopic @"/World"

+ (MessageBusManager*)getMBManager;

- (void)connectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

- (void)connectToHost:(NSString *)host port:(unsigned short)port completionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

- (void)disconnectWithCompletionHandler:(MQTTDisconnectionHandler)completionHandler;

- (void)setDisconnectWithCompletionHandler:(MQTTDisconnectionHandler)completionHandler;

- (void)initWithClientId:(NSString *)clientId;

- (void)subscribeTopic:(NSString *)topic completionHandler:(MQTTSubscriptionCompletionHandler)completionHandler;

- (void)subscribeTopic:(NSString *)topic receiveMessageHandler:(MQTTMessageHandler)messageHandler;

- (void)subscribeTopic:(NSString *)topic receiveMessageHandler:(MQTTMessageHandler)messageHandler completionHandler:(MQTTSubscriptionCompletionHandler)completionHandler;

- (void)publishMessage:(NSString *)payload toTopic:(NSString *)topic completionHandler:(void (^)(int mid))completionHandler;

@end
