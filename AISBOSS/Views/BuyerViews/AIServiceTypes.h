//
//  AIServiceTypes.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"


@protocol AIServiceTypesDelegate <NSObject>

- (void)didSelectServiceTypeAtIndex:(NSInteger)index;

@end


@interface AIServiceTypes : UIView

@property (nonatomic, weak) id<AIServiceTypesDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailParamModel *)model;

@end
