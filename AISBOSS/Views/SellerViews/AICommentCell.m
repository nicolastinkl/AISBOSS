//
//  AICommentCell.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AICommentCell.h"
#import "UIImageView+WebCache.h"
#import "AIViews.h"
#import "AIStarRate.h"
#import "AITools.h"
#import "UP_NSString+Size.h"

@interface AICommentCell ()
{
    CGFloat _commonMargin;
    CGFloat _nameFontSize;
    CGFloat _timeFontSize;
    CGFloat _commentFontSize;
    
    UIImageView *_headImageView;
    UPLabel *_nameLabel;
    AIStarRate *_starRate;
    UPLabel *_timeLabel;
    UPLabel *_commentLabel;
}

@property (nonatomic, strong) AIMusicCommentsModel *commentModel;

@end

@implementation AICommentCell

- (id)initWithFrame:(CGRect)frame model:(AIMusicCommentsModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.commentModel = model;
        [self makeProperties];
    }
    
    return self;
}

#pragma mark - 构造基本属性
- (void)makeProperties
{
    _commonMargin = 15;
    _nameFontSize = 16;
    _timeFontSize = 16;
    _commentFontSize = 16;
}

#pragma mark - 构造Subview

- (void)makeSubViews
{
    [self makeHeadIcon];
    [self makeName];
    [self makeRate];
    [self makeTime];
    [self makeComment];
    [self resetFrame];
}

#pragma mark - 构造头像

- (void)makeHeadIcon
{
    CGFloat size = [AITools displaySizeFrom1080DesignSize:210];
    CGRect frame = CGRectMake(0, 0, size, size);
    _headImageView = [[UIImageView alloc] initWithFrame:frame];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headIcon] placeholderImage:[UIImage imageNamed:@"Placehold"]];
    [self addSubview:_headImageView];
}

#pragma mark - 构造姓名

- (void)makeName
{
    CGFloat x = CGRectGetWidth(_headImageView.frame) + _commonMargin;
    CGFloat y = _commonMargin;
    CGFloat width = CGRectGetWidth(self.frame) - x;
    CGFloat height = _nameFontSize;
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    _nameLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.name fontSize:_nameFontSize color:[UIColor whiteColor]];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_nameLabel];
    
}

#pragma mark - 构造rate

- (void)makeRate
{
    CGFloat x = CGRectGetWidth(_headImageView.frame) + _commonMargin;
    CGFloat y = CGRectGetHeight(_nameLabel.frame) + _commonMargin;
    CGFloat height = _timeFontSize;

    CGRect frame = CGRectMake(x, y, 0, height);
    
    _starRate = [[AIStarRate alloc] initWithFrame:frame rate:self.commentModel.rate];
    [self addSubview:_starRate];
}

#pragma mark - 构造time

- (void)makeTime
{
    CGFloat x = CGRectGetWidth(_starRate.frame) + _commonMargin;
    CGFloat y = CGRectGetMinY(_starRate.frame);
    CGFloat width = CGRectGetWidth(self.frame) - x;
    CGFloat height = _timeFontSize;
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    _timeLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.time fontSize:_timeFontSize color:[UIColor whiteColor]];
    _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_timeLabel];
}

#pragma mark - 构造comment

- (void)makeComment
{
    CGFloat y = CGRectGetMaxY(_starRate.frame) + _commonMargin;
    CGFloat width = CGRectGetWidth(self.frame);
    CGSize size = [self.commentModel.comment sizeWithFontSize:_commentFontSize forWidth:width];
    
    CGRect frame = CGRectMake(0, y, width, size.height);
    
    _commentLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.comment fontSize:_commentFontSize color:[UIColor whiteColor]];
    _commentLabel.numberOfLines = 0;
    _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_commentLabel];
}


#pragma mark - 重新计算高度

- (void)resetFrame
{
    CGRect frame = self.frame;
    
    frame.size.height = CGRectGetMaxY(_commentLabel.frame);
    
    self.frame = frame;
}


@end
