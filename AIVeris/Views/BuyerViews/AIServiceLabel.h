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

@class AIServiceLabel;
@protocol AIServiceLabelDelegate <NSObject>

- (void)serviceLabel:(AIServiceLabel *)serviceLabel isSelected:(BOOL)selected;

@end

@interface AIServiceLabel : UIView

@property (nonatomic, weak) id<AIServiceLabelDelegate> delegate;

@property (nonatomic, strong) NSString *labelTitle;

@property (nonatomic, readonly) UIImageView *selectionImageView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(AIServiceLabelType)type isSelected:(BOOL)selected;


@end
