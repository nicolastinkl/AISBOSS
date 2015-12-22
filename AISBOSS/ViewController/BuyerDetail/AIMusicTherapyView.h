//
//  AIMusicTherapyView.h
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"

#import "AIServiceTypes.h"
#import "AIBuyerParamsDelegate.h"


@interface AIMusicTherapyView : UIView<AIServiceTypesDelegate, AIBuyerParamsDelegate>


- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model;


@end
