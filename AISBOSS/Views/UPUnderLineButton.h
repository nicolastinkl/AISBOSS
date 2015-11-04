//
//  UPUnderLineButton.h
//  UPPayPluginEx
//
//  Created by liwang on 13-5-23.
//
//

#import <UIKit/UIKit.h>

@interface UPUnderLineButton : UIView

@property(nonatomic, weak)id  mTarget;
@property(nonatomic, assign)SEL   mSelector;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightColor;

- (UPUnderLineButton *)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

- (UPUnderLineButton *)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font normalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor action:(void(^)(void))action;


@end
