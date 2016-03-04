//
//  ProposalServiceDetailBaseView.h
//  AIVeris
//
//  Created by Rocky on 16/1/6.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"
#import "PKYStepper.h"
#import "AIBuyerParamsDelegate.h"

@interface ProposalServiceDetailBaseView: UIView <AIBuyerParamsDelegate>
{
    BOOL _shouldShowParams;
}
@property (nonatomic, strong) AIProposalServiceDetailModel *detailModel;

@property (nonatomic, assign) CGFloat sideMargin;

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model shouldShowParams:(BOOL)should;
- (CGFloat) addDetailText: (CGFloat) positionY;
- (CGFloat) addPriceView: (CGFloat) positionY;
- (CGFloat) contentViewWidth;

@end
