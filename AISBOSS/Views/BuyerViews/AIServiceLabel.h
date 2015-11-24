//
//  AIServiceLabel.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, AIServiceLabelType) {
    AIServiceLabelTypeNormal,
    AIServiceLabelTypeSelection,
    AIServiceLabelTypeNumber,
};


@protocol AIServiceLabelDelegate <NSObject>

- (void)serviceLabelDidSelected:(BOOL)selected;

@end

@interface AIServiceLabel : UIView

@property (nonatomic, weak) id<AIServiceLabelDelegate> delegate;

@property (nonatomic, strong) NSString *labelTitle;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(AIServiceLabelType)type;


@end
