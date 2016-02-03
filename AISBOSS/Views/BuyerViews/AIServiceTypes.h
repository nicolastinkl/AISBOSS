//
//  AIServiceTypes.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIServiceDetailUIModel.h"
#import "AIServiceParamBaseView.h"

typedef void (^QueryPriceBlock)(NSDictionary *);

@protocol AIServiceTypesDelegate <NSObject>

//- (void)didSelectServiceTypeAtIndex:(NSInteger)index value:(AIProposalServiceDetailParamValueModel *) model parentModel:(AIProposalServiceDetailParamModel*) parentModel;

@end


@interface AIServiceTypes : AIServiceParamBaseView

@property (nonatomic, weak) id<AIServiceTypesDelegate> delegate;
@property (nonatomic, strong) QueryPriceBlock queryPriceBlock;
@property (nonatomic, strong) AIServiceTypesModel *serviceTypesModel;

- (id)initWithFrame:(CGRect)frame model:(AIServiceTypesModel *)model;

@end
