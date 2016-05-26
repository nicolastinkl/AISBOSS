//
//  AIOpeningView.h
//  DataStructure
//
//  Created by 王坜 on 15/7/15.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *AIUserTypeCustomer = @"101";
static NSString *AIUserTypeProvider = @"101";

@protocol AIOpeningViewDelegate <NSObject>

- (void)didOperatedWithDirection:(NSInteger)direction;// 0:center 1:up 2:down 3:lef 4:right

@end

@interface AIOpeningView : UIView

@property (nonatomic, weak) id<AIOpeningViewDelegate> delegate;

@property (nonatomic, strong) UIView *rootView;

@property (nonatomic, weak) UIView *centerTappedView;

@property (nonatomic, weak) UIView *leftDirectionView;
@property (nonatomic, weak) UIView *upDirectionView;
@property (nonatomic, weak) UIView *rightDirectionView;
@property (nonatomic, weak) UIView *downDirectionView;

+ (instancetype)instance;


- (void)show;

- (void)hide;

- (void)loading;

@end
