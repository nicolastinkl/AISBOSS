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
    
    UPLabel *_nameLabel;
    AIStarRate *_starRate;
    UPLabel *_timeLabel;
    UPLabel *_commentLabel;
}

@property (nonatomic, strong) AIProposalServiceDetailRatingCommentModel *commentModel;

@end

@implementation AICommentCell

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailRatingCommentModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.commentModel = model;
        [self makeProperties];
        [self makeSubViews];
    }
    
    return self;
}

#pragma mark - 构造基本属性
- (void)makeProperties
{
    _commonMargin = [AITools displaySizeFrom1080DesignSize:26];;
    _nameFontSize = [AITools displaySizeFrom1080DesignSize:42];
    _timeFontSize = [AITools displaySizeFrom1080DesignSize:42];
    _commentFontSize = [AITools displaySizeFrom1080DesignSize:42];
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
    CGFloat size = [AITools displaySizeFrom1080DesignSize:114];
    CGRect frame = CGRectMake(0, 0, size, size);
    self.defaultIcon = [[UIImageView alloc] initWithFrame:frame];
    
    UIImage *defaut = [UIImage imageNamed:@"MusicHead1"];
    [self.defaultIcon sd_setImageWithURL:[NSURL URLWithString:self.commentModel.service_customer.portrait_icon] placeholderImage:defaut];
    [self addSubview:self.defaultIcon];
}

#pragma mark - 构造姓名

- (void)makeName
{
    CGFloat x = CGRectGetWidth(self.defaultIcon.frame) + _commonMargin;
    CGFloat y = _commonMargin - 5;
    CGFloat width = CGRectGetWidth(self.frame) - x;
    CGFloat height = _nameFontSize;
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    _nameLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.service_customer.name fontSize:_nameFontSize color:[UIColor whiteColor]];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.font = [AITools myriadSemiCondensedWithSize:_nameFontSize];
    [self addSubview:_nameLabel];
    
}

#pragma mark - 构造rate

- (void)makeRate
{
    CGFloat x = CGRectGetWidth(self.defaultIcon.frame) + _commonMargin;
    CGFloat y = CGRectGetHeight(_nameLabel.frame) + _commonMargin;
    CGFloat height = [AITools displaySizeFrom1080DesignSize:25];

    CGRect frame = CGRectMake(x, y, 0, height);
    
    _starRate = [[AIStarRate alloc] initWithFrame:frame rate:self.commentModel.rating_level];
    [self addSubview:_starRate];
}

#pragma mark - 构造time

- (void)makeTime
{
    CGFloat x = CGRectGetMaxX(_starRate.frame) + _commonMargin;
    CGFloat y = CGRectGetMinY(_starRate.frame) - 2;
    CGFloat width = CGRectGetWidth(self.frame) - x;
    CGFloat height = _timeFontSize;
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    _timeLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.time fontSize:_timeFontSize color:[UIColor whiteColor]];
    _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_timeLabel];
}

#pragma mark - 构造comment

- (NSAttributedString *)fixedString:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = [AITools displaySizeFrom1080DesignSize:18];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attrStr addAttribute:NSFontAttributeName value:[AITools myriadLightSemiCondensedWithSize:_commentFontSize] range:NSMakeRange(0, string.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:Color_MiddleWhite range:NSMakeRange(0, string.length)];
    
    return attrStr;
}


- (void)makeComment
{
    CGFloat y = CGRectGetMaxY(self.defaultIcon.frame) + [AITools displaySizeFrom1080DesignSize:25];
    CGFloat width = CGRectGetWidth(self.frame);
    UIFont *font = [AITools myriadLightSemiCondensedWithSize:_commentFontSize];;
    CGSize size = [self.commentModel.content sizeWithFont:font forWidth:width];
    
    CGRect frame = CGRectMake(0, y, width, size.height);
    
    _commentLabel = [AIViews normalLabelWithFrame:frame text:self.commentModel.content fontSize:_commentFontSize color:Color_MiddleWhite];
    _commentLabel.numberOfLines = 0;
    _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _commentLabel.attributedText = [self fixedString:self.commentModel.content];
    [_commentLabel sizeToFit];
    
    
    [self addSubview:_commentLabel];
}


#pragma mark - 重新计算高度

- (void)resetFrame
{
    CGRect frame = self.frame;
    
    CGFloat height = CGRectGetMaxY(_commentLabel.frame);
    
    frame.size.height = height;
    
    self.frame = frame;
}


@end
