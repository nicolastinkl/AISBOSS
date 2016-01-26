//
//  AIServiceTypes.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIServiceDetailUIModel.h"


@protocol AIServiceTypesDelegate <NSObject>

//- (void)didSelectServiceTypeAtIndex:(NSInteger)index value:(AIProposalServiceDetailParamValueModel *) model parentModel:(AIProposalServiceDetailParamModel*) parentModel;

@end


@interface AIServiceTypes : UIView

@property (nonatomic, weak) id<AIServiceTypesDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(AIServiceTypesModel *)model;

@end
