//
//  AIServiceCoverage.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIServiceDetailUIModel.h"

@protocol AIServiceCoverageDelegate <NSObject>

//- (void)didChooseServiceLabelModel:(AIProposalServiceDetailParamValueModel *)labelModel isSelected:(BOOL)selected;

@end


@interface AIServiceCoverage : UIView
@property (nonatomic, weak) id<AIServiceCoverageDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame model:(AIServiceCoverageModel *)model;

@end
