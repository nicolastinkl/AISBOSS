//
//  AIParamedicView.h
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"
#import "AIBuyerParamsDelegate.h"
#import "AIServiceTypes.h"

@interface AIParamedicView : UIView<AIServiceTypesDelegate>

@property (nonatomic, weak) id<AIBuyerParamsDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model;

@end
