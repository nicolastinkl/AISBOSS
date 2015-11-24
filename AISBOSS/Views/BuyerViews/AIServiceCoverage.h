//
//  AIServiceCoverage.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AIServiceCoverageDelegate <NSObject>

- (void)didChooseServiceTag:(id)serviceTag;

@end


@interface AIServiceCoverage : UIView
@property (nonatomic, weak) id<AIServiceCoverageDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame labels:(NSArray *)labels;


@end
