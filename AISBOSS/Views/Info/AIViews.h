//
//  AIViews.h
//  DataStructure
//
//  Created by 王坜 on 15/7/13.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPLabel.h"

@interface AIViews : UIView

/*说明:构造单行垂直居中的Label
 *
 */

+ (UPLabel *)normalLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                         fontSize:(CGFloat)fontSize
                            color:(UIColor *)color;
/*说明:构造多行垂直居中的Label
 *
 */
+ (UPLabel *)wrapLabelWithFrame:(CGRect)frame
                           text:(NSString *)text
                       fontSize:(CGFloat)fontSize
                          color:(UIColor *)color;


/*说明:构造基本属性的Button
 *
 */
+ (UIButton *)baseButtonWithFrame:(CGRect)frame normalTitle:(NSString *)normalTitle;


/*说明:构造基本的ImageView
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;



/*说明:等待Loading
 */
+ (BOOL)showAnimationLoadingOnView:(UIView *)view;

+ (BOOL)stopAnimationLoadingOnView:(UIView *)view;


@end
