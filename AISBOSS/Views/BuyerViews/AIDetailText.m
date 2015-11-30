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
        
        _textMargin = [AITools displaySizeFrom1080DesignSize:37] - 4;
        _titleFontSize = [AITools displaySizeFrom1080DesignSize:46];
        _detailFontSize = [AITools displaySizeFrom1080DesignSize:42];
        
        self.titleString = title;
        self.detailString = detail;
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
    CGSize size = [text sizeWithFont:font forWidth:frame.size.width];
    frame.size = size;
    
    UPLabel *label = [AIViews wrapLabelWithFrame:frame text:text fontSize:fontSize color:textColor];
    label.font = font;
    
    return label;
}



- (NSAttributedString *)fixedString:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = [AITools displaySizeFrom1080DesignSize:18];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attrStr addAttribute:NSFontAttributeName value:[AITools myriadLightSemiCondensedWithSize:_titleFontSize] range:NSMakeRange(0, string.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[AITools colorWithR:0xc7 g:0xcb b:0xe2 a:0.7] range:NSMakeRange(0, string.length)];
    
    return attrStr;
}






#pragma mark - 设置字符串


#pragma mark - 构造titleLabel
- (void)setTitleString:(NSString *)titleString
{
    _titleString = [titleString copy];
    
    if (_titleLabel == nil && titleString.length > 0) {
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGRect frame = CGRectMake(0, 0, width, _titleFontSize);
        _titleLabel = [self labelWithFrame:frame text:titleString textColor:[UIColor whiteColor] font:[AITools myriadSemiCondensedWithSize:_titleFontSize] fontSize:_titleFontSize];
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
        CGRect frame = CGRectMake(0, y, width, _detailFontSize);
        _detailLabel = [self labelWithFrame:frame text:detailString textColor:[UIColor whiteColor] font:[AITools myriadLightSemiCondensedWithSize:_titleFontSize] fontSize:_detailFontSize];
        
        _detailLabel.textColor = [AITools colorWithR:0xc7 g:0xcb b:0xe2 a:0.7];
        
        [self addSubview:_detailLabel];
        
    }
    
    _detailLabel.text = detailString;
    
    _detailLabel.attributedText = [self fixedString:detailString];
    [_detailLabel sizeToFit];
    
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
