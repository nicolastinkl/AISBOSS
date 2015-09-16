//
//  AIScrollLabel.m
//  AITrans
//
//  Created by 王坜 on 15/9/16.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIScrollLabel.h"
#define kScrollRate    30

@interface AIScrollLabel ()
{
    BOOL _isScrolling;
    UILabel *_scrollLabel;
    CGFloat _fontSize;
}

@property (nonatomic, strong) NSString *scrollText;

@property (nonatomic, strong) UIColor *textColor;

@end

@implementation AIScrollLabel

#pragma mark - 构造函数
- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
              color:(UIColor *)color
       scrollEnable:(BOOL)enable
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnable = enable;
        self.scrollText = text;
        self.textColor = color;
        self.clipsToBounds = YES;
        _fontSize = CGRectGetHeight(frame);
        [self makeScrollLabel];
    }
    
    return self;
}

- (void)makeScrollLabel
{
    
    _scrollLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _scrollLabel.text = self.scrollText;
    _scrollLabel.textAlignment = NSTextAlignmentLeft;
    _scrollLabel.font = [UIFont systemFontOfSize:_fontSize];
    _scrollLabel.textColor = self.textColor;
    _scrollLabel.backgroundColor = [UIColor clearColor];
    _scrollLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:_scrollLabel];
}


- (CGSize)textHorizontalSize
{
    CGSize size = CGSizeZero;
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect frame = [self.scrollText boundingRectWithSize:CGSizeMake(INFINITY, CGRectGetHeight(self.bounds)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    size = frame.size;
    
    return size;
}


#pragma mark - 开始滚动

- (void)startScrollAnimationWithLabel:(UILabel *)label
{
    if (!self.scrollEnable || label == nil) return;
    
    CGFloat pathLength = CGRectGetWidth(self.bounds) + CGRectGetWidth(label.frame);
    CGFloat duration = pathLength / kScrollRate;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = label.frame;
        frame.origin.x -= pathLength;
        label.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = label.frame;
        frame.origin.x = CGRectGetWidth(weakSelf.bounds);
        label.frame = frame;
        
        [weakSelf startScrollAnimationWithLabel:label];
    }];
    
}

- (void)startScroll
{
    if (!self.scrollEnable || _isScrolling) return;
    _isScrolling = YES;
    // 设置Label的Frame
    CGSize size = [self textHorizontalSize];
    
    if (size.width <= CGRectGetWidth(self.bounds)) {
        return;
    }
    
    _scrollLabel.frame = CGRectMake(0, -2, size.width, size.height);
    
    // 开始动画
    // step 1 : 将文本从左侧移除视图
    CGFloat duration = size.width / kScrollRate;
    __weak UILabel *label = _scrollLabel;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = label.frame;
        frame.origin.x -= size.width;
        label.frame = frame;
    } completion:^(BOOL finished) {
        // step 2 : 将文本移至视图最右侧末端
        CGRect frame = label.frame;
        frame.origin.x = CGRectGetWidth(weakSelf.bounds);
        label.frame = frame;
        
        // step 3 : 重复从最右端移动至最左端
        [weakSelf startScrollAnimationWithLabel:label];
    }];
    
    

}

#pragma mark - 停止滚动
- (void)stopScroll
{
    if (!self.scrollEnable || !_isScrolling) return;
    _isScrolling = NO;
    [_scrollLabel removeFromSuperview];
    [self makeScrollLabel];
    
}

@end
