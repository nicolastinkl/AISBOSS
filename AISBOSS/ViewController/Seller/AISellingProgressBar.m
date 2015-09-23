//
//  AISellingProgressBar.m
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellingProgressBar.h"
#import "AIViews.h"
#import "AITools.h"
#import "UP_NSString+Size.h"

#define kIndicatorSize 10
#define kMaring2       2
#define kFontSize      10

#define kProgress_Percent         @"Percent"
#define kProgress_Indicator       @"Indicator"
#define kProgress_Schedule        @"Schedule"


@interface AISellingProgressBar ()
{
    UILabel *_progressLabel;
    UIImageView *_progressIndicator;
    UIView *_progressView;
}

@property (nonatomic, strong) NSDictionary *content;

@end



@implementation AISellingProgressBar
@synthesize progressLabel = _progressLabel;
@synthesize progressIndicator = _progressIndicator;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    
    return self;
}



- (void)setProgressContent:(NSDictionary *)content
{
    if (!content) {
        return;
    }
    
    self.backgroundColor = [AITools colorWithR:0x4c g:0x56 b:0x7d];
    
    [self setHidden:NO];
    self.content = content;
    NSString *indicator = [content objectForKey:kProgress_Indicator];
    NSString *schedule = [content objectForKey:kProgress_Schedule];
    NSString *percentStr = [content objectForKey:kProgress_Percent];
    
    CGFloat width = percentStr.integerValue * CGRectGetWidth(self.frame) / 100;
    [AITools resetWidth:width forView:_progressView];
    
    UIImage *image = [UIImage imageNamed:indicator];
    _progressIndicator.image = image;
    _progressLabel.text = schedule;
    CGRect frame = _progressIndicator.frame;
    frame.origin.y = (CGRectGetHeight(self.frame) - kIndicatorSize)/2;
    _progressIndicator.frame = frame;
    
    CGFloat x = 0;
    width = CGRectGetWidth(self.frame);
    if (image) {
        self.backgroundColor = [AITools colorWithR:0x73 g:0x49 b:0x36];
        CGSize size = [schedule sizeWithFontSize:kFontSize forWidth:width-kIndicatorSize-kMaring2];
        x = (width - kIndicatorSize - kMaring2 - size.width)/2;
        [AITools resetOriginalX:x forView:_progressIndicator];
        x += kIndicatorSize + kMaring2;
        [AITools resetOriginalX:x forView:_progressLabel];
        [AITools resetWidth:width-x forView:_progressLabel];
        _progressLabel.textAlignment = NSTextAlignmentLeft;
    }
}


- (void)makeSubViews
{
    [self makeProgress];
    [self makeLabel];
    [self makeIndicator];
}

- (void)makeProgress
{
    self.backgroundColor = [AITools colorWithR:0x4c g:0x56 b:0x7d];
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.clipsToBounds = YES;
    
//    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Seller_BarBG"]];
//    bgView.frame = self.bounds;
//    bgView.alpha = 0.5;
//    [self addSubview:bgView];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.progressPercent*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _progressView.backgroundColor = [AITools colorWithR:0x1a g:0xe0 b:00];
    
    [self addSubview:_progressView];
}

- (void)makeLabel
{
    _progressLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) text:@"" fontSize:kFontSize color:[UIColor colorWithWhite:0.9 alpha:1]];
    _progressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_progressLabel];
}

- (void)makeIndicator
{
    UIImage *image = [UIImage imageNamed:@""];
    _progressIndicator = [[UIImageView alloc] initWithImage:image];
    _progressIndicator.frame = CGRectMake(0, 0, kIndicatorSize, kIndicatorSize);
    [self addSubview:_progressIndicator];
}


@end
