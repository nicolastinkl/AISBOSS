//
//  AIServiceLabel.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceLabel.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"
#import "AITools.h"

@interface AIServiceLabel ()
{
    AIServiceLabelType _labelType;
    CGFloat _maxWidth;
    CGFloat _maxHeight;
    CGFloat _textMargin;
    CGFloat _fontSize;
    CGFloat _tinyMargin;
    
    AIServiceLabelType _curType;
    
    UPLabel *_titleLabel;
    
    UPLabel *_numberView;
    
    UIButton *_checkView;
}



@end

@implementation AIServiceLabel

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(AIServiceLabelType)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.labelTitle = title;
        [self makeProperties];
        [self makeTitle];
        [self makeStyle];
        [self resetFrame];
    }
    
    return self;
}

#pragma mark - 构造基本属性，背景色、圆角等
- (void)makeProperties
{
    _maxWidth = CGRectGetWidth(self.frame);
    _maxHeight = CGRectGetHeight(self.frame);
    _textMargin = 15;
    _fontSize = 16;
    _tinyMargin = 5;
    self.layer.cornerRadius = _maxHeight / 2;
    self.backgroundColor = [UIColor brownColor];
}

#pragma mark - 构造title

- (void)makeTitle
{
    CGSize titleSize = [self.labelTitle sizeWithFontSize:_fontSize forWidth:300];
    CGRect frame = CGRectMake(_textMargin, 0, titleSize.width, CGRectGetHeight(self.frame));
    _titleLabel = [AIViews normalLabelWithFrame:frame text:self.labelTitle fontSize:_fontSize color:[UIColor colorWithWhite:0.5 alpha:0.8]];
    [self addSubview:_titleLabel];

}


#pragma mark - 构造数字

- (void)makeNumber
{
    
    NSString *number = @"88";
    CGSize size = [number sizeWithFontSize:_fontSize forWidth:300];
    CGFloat x = _textMargin * 2 + CGRectGetWidth(_titleLabel.frame);
    CGFloat height = CGRectGetHeight(self.frame) - _tinyMargin * 2;
    CGFloat standardWidth = height;
    height = size.width < standardWidth ? height : size.width + _tinyMargin * 2;

    CGRect frame = CGRectMake(x, _tinyMargin, size.width, height);
    _numberView = [AIViews normalLabelWithFrame:frame text:self.labelTitle fontSize:_fontSize color:[UIColor colorWithWhite:0.5 alpha:0.8]];
    _numberView.layer.cornerRadius = height / 2;
    _numberView.layer.masksToBounds = YES;
    _numberView.backgroundColor = [UIColor purpleColor];
    [self addSubview:_numberView];
    
}

#pragma mark - 构造勾选

- (void)selectedAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(serviceLabelDidSelected:)]) {
        [self.delegate serviceLabelDidSelected:button.selected];
    }
    
}

- (void)makeCheckBox
{
    UIImage *normalImage = [UIImage imageNamed:@""];
    UIImage *selectedImage = [UIImage imageNamed:@""];
    //CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:normalImage.size];
    CGFloat x = _textMargin * 2 + CGRectGetWidth(_titleLabel.frame);
    CGFloat height = CGRectGetHeight(self.frame) - _tinyMargin * 2;
    CGRect frame = CGRectMake(x, _tinyMargin, height, height);
    
    _checkView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _checkView.frame = frame;
    [_checkView setImage:normalImage forState:UIControlStateNormal];
    [_checkView setImage:selectedImage forState:UIControlStateSelected];
    _checkView.layer.cornerRadius = height / 2;
    [_checkView addTarget:selectedImage action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkView];
    
}

#pragma mark - 设置样式

- (void)makeStyle
{
    switch (_curType) {
        case AIServiceLabelTypeNormal:
            
            break;
        case AIServiceLabelTypeNumber:
            [self makeNumber];
            break;
        case AIServiceLabelTypeSelection:
            [self makeCheckBox];
            break;
            
        default:
            break;
    }
}

#pragma mark - 重置frame

- (void)resetFrame
{
    CGRect frame = self.frame;
    CGFloat width = width = _textMargin * 2 + CGRectGetWidth(_titleLabel.frame);
    switch (_curType) {
        case AIServiceLabelTypeNumber:
        {
            width += CGRectGetWidth(_numberView.frame);
        }
            break;
        case AIServiceLabelTypeSelection:
        {
            width += CGRectGetWidth(_checkView.frame);
        }
            break;
        case AIServiceLabelTypeNormal:
        default:
            break;
    }
    
    frame.size.width = width;
    self.frame = frame;
}


@end
