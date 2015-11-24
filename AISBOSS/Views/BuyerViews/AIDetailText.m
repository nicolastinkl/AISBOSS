//
//  AIDetailText.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIDetailText.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"
#import "AITools.h"

@interface AIDetailText ()
{
    UPLabel *_titleLabel;
    
    UPLabel *_detailLabel;
    
    CGFloat _textMargin;
    
    CGFloat _titleFontSize;
    CGFloat _detailFontSize;
}

@end

@implementation AIDetailText

- (instancetype)initWithFrame:(CGRect)frame titile:(NSString *)title detail:(NSString *)detail
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _textMargin = 10;
        _titleFontSize = 20;
        _detailFontSize = 18;
        
        self.titleString = title;
        self.detailString = detail;
        
        
        [self resetFrame];
    }
    
    
    return self;
}


#pragma mark - 构造子VIew

- (UPLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
            textColor:(UIColor *)textColor
                 font:(UIFont *)font
             fontSize:(CGFloat)fontSize
{
    CGSize size = [text sizeWithFontSize:fontSize forWidth:frame.size.width];
    frame.size = size;
    
    UPLabel *label = [AIViews wrapLabelWithFrame:frame text:text fontSize:fontSize color:textColor];
    label.font = font;
    
    return label;
}








#pragma mark - 设置字符串


#pragma mark - 构造titleLabel
- (void)setTitleString:(NSString *)titleString
{
    _titleString = [titleString copy];
    
    if (_titleLabel == nil && titleString.length > 0) {
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGRect frame = CGRectMake(0, 0, width, _titleFontSize);
        _titleLabel = [self labelWithFrame:frame text:titleString textColor:[UIColor whiteColor] font:[AITools myriadCondWithSize:_titleFontSize] fontSize:_titleFontSize];
        [self addSubview:_titleLabel];
    
    }
    
    _titleLabel.text = titleString;
    
    [self resetFrame];
}

#pragma mark - 构造detailLabel
- (void)setDetailString:(NSString *)detailString
{
    _detailString = [detailString copy];
    
    if (_detailLabel == nil && detailString.length > 0) {
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat y = CGRectGetMaxY(_titleLabel.frame) + _textMargin;
        CGRect frame = CGRectMake(0, y, width, _titleFontSize);
        _detailLabel = [self labelWithFrame:frame text:detailString textColor:[UIColor whiteColor] font:[AITools myriadCondWithSize:_titleFontSize] fontSize:_titleFontSize];
        [self addSubview:_detailLabel];
        
    }
    
    _detailLabel.text = detailString;
    
    [self resetFrame];
}



#pragma mark - 重新设置Frame

- (void)resetFrame
{
    CGRect frame = self.frame;
    
    CGFloat height = CGRectGetHeight(_titleLabel.frame) + CGRectGetHeight(_detailLabel.frame) + _textMargin;
    
    frame.size.height = height;
    
    self.frame = frame;
}


@end
