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
    CGFloat _textLeftMargin;
    CGFloat _textRightMargin;
    CGFloat _fontSize;
    CGFloat _tinyMargin;
    
    AIServiceLabelType _curType;
    
    UPLabel *_titleLabel;
    
    UPLabel *_numberView;
    
    UIImageView *_checkView;
    
    BOOL _isSelected;
}



@end

@implementation AIServiceLabel
@synthesize selectionImageView = _checkView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(AIServiceLabelType)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _curType = type;
        self.labelTitle = title;
        [self makeProperties];
        [self makeTitle];
        [self makeStyle];
        [self resetFrame];
        [self addTapGestureRecognizer];
    }
    
    return self;
}

#pragma mark - 构造基本属性，背景色、圆角等
- (void)makeProperties
{
    _isSelected = YES;
    _maxWidth = CGRectGetWidth(self.frame);
    _maxHeight = CGRectGetHeight(self.frame);
    _textLeftMargin = [AITools displaySizeFrom1080DesignSize:34];
    _textRightMargin = [AITools displaySizeFrom1080DesignSize:16];
    _fontSize = [AITools displaySizeFrom1080DesignSize:35];
    _tinyMargin = [AITools displaySizeFrom1080DesignSize:5];
    self.layer.cornerRadius = _maxHeight / 2;
}

#pragma mark - 构造title

- (void)makeTitle
{
    CGSize titleSize = [self.labelTitle sizeWithFont:[AITools myriadLightSemiCondensedWithSize:_fontSize] forWidth:300];
    CGRect frame = CGRectMake(_textLeftMargin, 0, titleSize.width, CGRectGetHeight(self.frame));
    _titleLabel = [AIViews normalLabelWithFrame:frame text:self.labelTitle fontSize:_fontSize color:Color_MiddleWhite];
    [self addSubview:_titleLabel];

}


#pragma mark - 构造数字

- (void)makeNumber
{
    
    NSString *number = @"88";
    CGSize size = [number sizeWithFont:[AITools myriadLightSemiCondensedWithSize:_fontSize] forWidth:300];
    CGFloat x = _textLeftMargin + _textRightMargin + CGRectGetWidth(_titleLabel.frame);
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


- (void)selected:(UITapGestureRecognizer *)gesture
{
    _isSelected = !_isSelected;
    self.selectionImageView.alpha = _isSelected ? 1 : 0.25;
}


- (void)selectedAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(serviceLabelDidSelected:)]) {
        [self.delegate serviceLabelDidSelected:button.selected];
    }
    
}

- (void)makeCheckBox
{
    CGFloat x = _textLeftMargin + _textRightMargin + CGRectGetWidth(_titleLabel.frame);
    CGFloat height = CGRectGetHeight(self.frame) - _tinyMargin * 2;
    CGRect frame = CGRectMake(x, _tinyMargin, height, height);
    
    _checkView = [[UIImageView alloc] initWithFrame:frame];
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
    CGFloat width = _textLeftMargin + _textRightMargin + CGRectGetWidth(_titleLabel.frame);
    switch (_curType) {
        case AIServiceLabelTypeNumber:
            break;
        case AIServiceLabelTypeSelection:
        {
            CGFloat aw = CGRectGetWidth(_checkView.frame);
            width += aw + _tinyMargin;
        }
            break;
        case AIServiceLabelTypeNormal:
        default:
            break;
    }
    
    frame.size.width = width;
    self.frame = frame;
}


#pragma mark - 添加点击事件

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected:)];
    [self addGestureRecognizer:gesture];
}

@end
