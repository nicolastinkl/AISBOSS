//
//  AIStarRate.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIStarRate.h"
#import "AITools.h"

@interface AIStarRate ()
{
    CGFloat _maxRate;
    CGFloat _starMargin;
    NSMutableArray *stars;
    
    UIView *_contentView;
}


@end

@implementation AIStarRate

- (id)initWithFrame:(CGRect)frame rate:(CGFloat)rate
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _displayRate = rate;
        [self makeProperties];
        [self makeStars];
    }
    
    return self;
}


#pragma mark - 设置Rate

- (void)setDisplayRate:(CGFloat)displayRate
{
    if (displayRate > _maxRate) {
        _displayRate = _maxRate;
    }
    else if (displayRate < 0)
    {
        _displayRate = 0;
    }
    else
    {
        _displayRate = displayRate;
    }
    
    
    [_contentView removeFromSuperview];
    
    [self makeProperties];
    [self makeStars];
}

#pragma mark - 构造基本属性

- (void)makeProperties
{
    _maxRate = 5.0;
    _starMargin = [AITools displaySizeFrom1080DesignSize:8];
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    
}

#pragma mark - 构造Stars

- (CGFloat)addStarImageWithName:(NSString *)name atX:(CGFloat)x
{
    CGFloat size = CGRectGetHeight(self.frame);
    UIImage *star = [UIImage imageNamed:name];
    UIImageView *starView = [[UIImageView alloc] initWithImage:star];
    starView.frame = CGRectMake(x, 0, size, size);
    [_contentView addSubview:starView];
    
    return x + size + _starMargin;
}

- (void)makeStars
{
    CGFloat lr = _displayRate ;
    CGFloat x = 0;
    
    while (lr >= 1) {
        x = [self addStarImageWithName:@"Yellow_Star" atX:x];
        lr -= 1;
    }
    
    if (lr > 0) {
        x = [self addStarImageWithName:@"Half_Star" atX:x];
    }
    
    CGFloat or = _maxRate - _displayRate;
    
    while (or >= 1) {
        x = [self addStarImageWithName:@"Gray_Star" atX:x];
        or -= 1;
    }
    
    CGRect frame = self.frame;
    frame.size.width = x - _starMargin;
    self.frame = frame;
    
}



@end
