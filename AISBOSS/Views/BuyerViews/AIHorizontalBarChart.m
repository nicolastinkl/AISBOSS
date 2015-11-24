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
    
    
}

@property (nonatomic, strong) AIMusicChartModel *chartModel;

@end

@implementation AIHorizontalBarChart

- (id)initWithFrame:(CGRect)frame model:(AIMusicChartModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.chartModel = model;
        [self makeProperties];
        [self makeTitle];
        [self makeChart];
        [self makeNumber];
    }
    
    return self;
}


#pragma mark - 基本属性

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
    
    CGRect frame = CGRectMake(0, 0, width, _maxHeight);
    
    _titleLabel = [AIViews normalLabelWithFrame:frame text:self.chartModel.title fontSize:_maxHeight color:[UIColor whiteColor]];
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
    _backgroundView.layer.borderColor = [UIColor blueColor].CGColor;
    _backgroundView.layer.borderWidth = 1;
    
    [self addSubview:_backgroundView];
    
    //
    frame.size.width = width * self.chartModel.percentage;
    _charView = [[UIView alloc] initWithFrame:frame];
    _charView.backgroundColor = [UIColor blueColor];
    
    [self addSubview:_charView];
    
}

#pragma mark - 构造number

- (void)makeNumber
{
    CGFloat width = _maxWidth * _numberRate;
    CGFloat x = CGRectGetMaxX(_backgroundView.frame) + _margin;
    
    CGRect frame = CGRectMake(x, 0, width, _maxHeight);
    
    _numberLabel = [AIViews normalLabelWithFrame:frame text:self.chartModel.number fontSize:_maxHeight color:[UIColor whiteColor]];
    _numberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_numberLabel];
}



@end
