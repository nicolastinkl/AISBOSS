//
//  AIScrollLabel.h
//  AITrans
//
//  Created by 王坜 on 15/9/16.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIScrollLabel : UIView

@property (nonatomic, assign) BOOL scrollEnable;  //  控制是否能滚动


/*说明:构造函数，窗体的高度将设置为Label的字体Size
 *
 *text       滚动文本内容
 *enable     滚动开关
 *
 */
- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
              color:(UIColor *)color
       scrollEnable:(BOOL)enable;



/*说明:开始滚动
 */
- (void)startScroll;

/*说明:停止滚动
 */
- (void)stopScroll;


@end
