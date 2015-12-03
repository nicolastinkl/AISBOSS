//
//  AIHorizontalBarChart.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIHorizontalBarChart.h"
#import "AITools.h"

#import "AIViews.h"

@interface AIHorizontalBarChart ()
{
    CGFloat _titleRate;
    CGFloat _chartRate;
    CGFloat _numberRate;
    CGFloat _maxWidth;
    CGFloat _maxHeight;
    CGFloat _margin;
    
    UPLabel *_titleLabel;
    UPLabel *_numberLabel;
    
    UIView *_backgroundView;
    UIView *_charView;
    
    //
    NSString *_name;
    NSInteger _number;
    CGFloat _rate;
}


@end

@implementation AIHorizontalBarChart

- (id)initWithFrame:(CGRect)frame name:(NSString *)name number:(NSInteger)number rate:(CGFloat)rate
{
    self = [super initWithFrame:frame];
    
    if (self) {

        _name = [name copy];
        _number = number;
        _rate = [self modifyRate:rate];
        
        [self makeProperties];
        [self makeTitle];
        [self makeChart];
        [self makeNumber];
    }
    
    return self;
}



#pragma mark - 基本属性

- (CGFloat)modifyRate:(CGFloat)rate
{
    CGFloat mRate = rate;
    
    if (mRate<0.01 && mRate > 0) {
        mRate = 0.01;
    }
    
    return mRate;
}

- (void)makeProperties
{
    
    _maxWidth = [AITools displaySizeFrom1080DesignSize:1080] - [AITools displaySizeFrom1080DesignSize:35] * 2;
    _maxHeight = CGRectGetHeight(self.frame);
    _margin = [AITools displaySizeFrom1080DesignSize:28];
    _titleRate = [AITools displaySizeFrom1080DesignSize:150] / _maxWidth;
    _chartRate = [AITools displaySizeFrom1080DesignSize:700] / _maxWidth;
    _numberRate = 1 - _titleRate -  _chartRate;
}


#pragma mark - 构造title

- (void)makeTitle
{
    CGFloat width = _maxWidth *_titleRate;
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    
    CGFloat y = (_maxHeight - fontSize) / 2;
    
    CGRect frame = CGRectMake(0, y, width, fontSize);
    
    _titleLabel = [AIViews normalLabelWithFrame:frame text:_name fontSize:fontSize color:Color_MiddleWhite];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];
}

#pragma mark - 构造chart

- (void)makeChart
{
    CGFloat width = _maxWidth * _chartRate;
    CGFloat x = _maxWidth *_titleRate + _margin;
    
    CGRect frame = CGRectMake(x, 0, width, _maxHeight);
    
    _backgroundView = [[UIView alloc] initWithFrame:frame];
    _backgroundView.layer.borderColor = [AITools colorWithR:0x29 g:0x4c b:0xe3].CGColor;
    _backgroundView.layer.borderWidth = 1;
    [self addSubview:_backgroundView];
    
    //
    frame.size.width = width * _rate;
    _charView = [[UIView alloc] initWithFrame:frame];
    _charView.backgroundColor = [AITools colorWithR:0x29 g:0x4c b:0xe3];
    
    [self addSubview:_charView];
    
}

#pragma mark - 构造number

- (void)makeNumber
{
    CGFloat width = _maxWidth * _numberRate;
    CGFloat x = CGRectGetMaxX(_backgroundView.frame) + _margin;
    CGFloat fontSize = [AITools displaySizeFrom1080DesignSize:42];
    
    CGFloat y = (_maxHeight - fontSize) / 2;
    CGRect frame = CGRectMake(x, y, width, fontSize);
    
    _numberLabel = [AIViews normalLabelWithFrame:frame text:[NSString stringWithFormat:@"%ld", _number] fontSize:fontSize color:Color_MiddleWhite];
    _numberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_numberLabel];
}



@end
