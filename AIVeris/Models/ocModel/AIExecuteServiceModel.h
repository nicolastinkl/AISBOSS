//
//  AIExecuteServiceModel.h
//  AIVeris
//
//  Created by 刘先 on 16/5/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

#pragma mark - AIGrabOrderInfoModel

@protocol AIGrabOrderInfoModel @end

@interface AIGrabOrderInfoModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *service_thumbnail_icon;
@property(nonatomic,strong) NSString<Optional> *result;

@end

@protocol AIGrabOrderParamModel @end