//
//  AIBuyerModels.h
//  AIVeris
//
//  Created by 王坜 on 15/11/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface AIBuyerModels : JSONModel

@end



#pragma mark - 详情评论部分

@interface AIMusicCommentsModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *headIcon;

@property (nonatomic, strong) NSString<Optional> *name;

@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, strong) NSString<Optional> *time;

@property (nonatomic, strong) NSString<Optional> *comment;

@end


#pragma mark - 统计部分

@interface AIMusicChartModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, assign) CGFloat percentage;

@property (nonatomic, strong) NSString<Optional> *number;

@end





#pragma mark - ServiceType

@interface AIMusicServiceTypesModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSArray<Optional> *types;

@property (nonatomic, assign) NSInteger defaultTypeIndex;


@end


#pragma mark - ServiceCoverage


@interface AIParamedicCoverageModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSArray<Optional> *labels;

@end
























