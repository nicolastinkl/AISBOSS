//
//  AIMusicTherapyView.h
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"
#import "AIServiceCoverage.h"

#import "AIBuyerParamsDelegate.h"


@interface AIMusicTherapyView : UIView<AIServiceCoverageDelegate>

@property (nonatomic, weak) id<AIBuyerParamsDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model;


@end
