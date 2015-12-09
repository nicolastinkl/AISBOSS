//
//  AIServiceCoverage.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"

@protocol AIServiceCoverageDelegate <NSObject>

- (void)didChooseServiceLabelModel:(AIProposalServiceDetail_Param_Value_listModel *)labelModel;

@end


@interface AIServiceCoverage : UIView
@property (nonatomic, weak) id<AIServiceCoverageDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame model:(AIProposalServiceDetail_Param_listModel *)model;

@end
