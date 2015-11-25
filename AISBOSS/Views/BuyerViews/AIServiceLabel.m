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
    _maxWidth = CGRectGetWidth(self.frame);
    _maxHeight = CGRectGetHeight(self.frame);
    _textMargin = 10;
    _fontSize = 14;
    _tinyMargin = 5;
    self.layer.cornerRadius = _maxHeight / 2;
    self.backgroundColor = [UIColor brownColor];
}

#pragma mark - 构造title

- (void)makeTitle
{
    CGSize titleSize = [self.labelTitle sizeWithFont:[AITools myriadLightSemiCondensedWithSize:_fontSize] forWidth:300];
    CGRect frame = CGRectMake(_textMargin, 0, titleSize.width, CGRectGetHeight(self.frame));
    _titleLabel = [AIViews normalLabelWithFrame:frame text:self.labelTitle fontSize:_fontSize color:Color_MiddleWhite];
    [self addSubview:_titleLabel];

}


#pragma mark - 构造数字

- (void)makeNumber
{
    
    NSString *number = @"88";
    CGSize size = [number sizeWithFont:[AITools myriadLightSemiCondensedWithSize:_fontSize] forWidth:300];
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


- (void)selected:(UITapGestureRecognizer *)gesture
{
    _checkView.selected = !_checkView.selected;
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
    UIImage *normalImage = [UIImage imageNamed:@"Type_Off"];
    UIImage *selectedImage = [UIImage imageNamed:@"Type_On"];
    //CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:normalImage.size];
    CGFloat x = _textMargin * 2 + CGRectGetWidth(_titleLabel.frame);
    CGFloat height = CGRectGetHeight(self.frame) - _tinyMargin * 2;
    CGRect frame = CGRectMake(x, _tinyMargin, height, height);
    
    _checkView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _checkView.frame = frame;
    [_checkView setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_checkView setBackgroundImage:selectedImage forState:UIControlStateSelected];
    _checkView.layer.cornerRadius = height / 2;
    [_checkView addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    _checkView.userInteractionEnabled = NO;
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
    CGFloat width = _textMargin * 2 + CGRectGetWidth(_titleLabel.frame);
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
