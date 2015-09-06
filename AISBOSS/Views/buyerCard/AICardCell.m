//
//  AICardCell.m
//  MessageList
//
//  Created by 王坜 on 15/7/19.
//  Copyright (c) 2015年 刘超. All rights reserved.
//

#import "AICardCell.h"

#import "RegexKitLite.h"
#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "AITools.h"
#import "CustomMethod.h"

#define kTopMargin            3
#define kSideMargin           10
#define kContentMargin        5
#define kImageSize            17

#define kCycleSize            7

#define kFillSize             4

#define kLineWidth            1

#define kTextFont             10



@interface AICardCell ()
{
    CGFloat _cellHeight;
    UIImageView *_indicatorImageView;
    UIImageView *_topLineView;
    UIImageView *_bottomLineView;
    UIView *_borderCycleView;
    UIView *_fillCycleView;
    
    OHAttributedLabel *_hyperLineLabel;
}

@property (nonatomic, strong) NSDictionary *emojiDic;

@property (nonatomic, copy) NSString *hyperlinkText;

@end


@implementation AICardCell

- (void)makeTextView
{
    
}


- (id)initWithFrame:(CGRect)frame content:(NSDictionary *)content position:(AICardPosition)position
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self makeLocalDatasWithContent:content position:position];
        [self makeSubViews];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame hyperlinkText:(NSString *)hyperlinkText
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.hyperlinkText = hyperlinkText;
   
    }
    
    return self;
}

#pragma mark - Method

- (void)makeLocalDatasWithContent:(NSDictionary *)content position:(AICardPosition)position
{
    NSArray *wk_paceImageNumArray = [[NSArray alloc]initWithObjects:@"airplane@2x.png", nil];
    NSArray *wk_paceImageNameArray = [[NSArray alloc]initWithObjects:@"[飞机]", nil];
    self.emojiDic = [[NSDictionary alloc] initWithObjects:wk_paceImageNumArray forKeys:wk_paceImageNameArray];
    
    //
    self.hyperlinkText = [content objectForKey:kCell_HyperText];
    self.hyperLinkArray = [content objectForKey:kCell_HyperKeys];
    NSString *imageName = [content objectForKey:kCell_IndicatorImage];
    self.indicatorImage = imageName?[UIImage imageNamed:imageName]:nil;
    NSString *colorHex = [content objectForKey:kCell_IndicatorColor];
    self.indicatorColor = [AITools colorWithHexString:colorHex];
    self.shouldShowTopLine = (position == AICardPositionAtMiddle || position == AICardPositionAtLast);
    self.shouldShowBottomLine = (position == AICardPositionAtMiddle || position == AICardPositionAtFirst);
}





- (void)makeSubViews
{
    _cellHeight = kTopMargin *2;
    CGFloat labelWidth = CGRectGetWidth(self.frame) -kSideMargin*2 - kContentMargin*3 - kImageSize;
    
    // make label
    _hyperLineLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(kSideMargin+kCycleSize+kContentMargin , kTopMargin, labelWidth, 40)];
    [self creatAttributedLabel:self.hyperlinkText Label:_hyperLineLabel maxWidth:labelWidth];
    [CustomMethod drawImage:_hyperLineLabel];
    [self addSubview:_hyperLineLabel];
    
    
    _cellHeight += CGRectGetHeight(_hyperLineLabel.frame) > kImageSize ? CGRectGetHeight(_hyperLineLabel.frame) : kImageSize;
    
    if (CGRectGetHeight(_hyperLineLabel.frame) < kImageSize) {
        CGRect labelframe = _hyperLineLabel.frame;
        labelframe.origin.y = (_cellHeight - CGRectGetHeight(_hyperLineLabel.frame)) / 2;
        _hyperLineLabel.frame = labelframe;
    }

    
    
    // make imageView
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame)-kSideMargin-kImageSize, (_cellHeight-kImageSize)/2, kImageSize, kImageSize);
    _indicatorImageView = [[UIImageView alloc] initWithFrame:frame];
    _indicatorImageView.image = self.indicatorImage;
    _indicatorImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_indicatorImageView];
    

    // make top line
    UIImage *lineImage = [UIImage imageNamed:@"connection_line"];
    if (self.shouldShowTopLine) {
        _topLineView = [[UIImageView alloc] initWithImage:lineImage];
        _topLineView.frame = CGRectMake(kSideMargin+kCycleSize/2, 0, kLineWidth, (_cellHeight-kCycleSize)/2);
        [self addSubview:_topLineView];
    }
    
    // make cycle View
    _borderCycleView = [[UIView alloc] initWithFrame:CGRectMake(kSideMargin, (_cellHeight-kCycleSize)/2, kCycleSize, kCycleSize)];
    _borderCycleView.backgroundColor = [UIColor clearColor];
    _borderCycleView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderCycleView.layer.borderWidth = kLineWidth;
    _borderCycleView.layer.cornerRadius = kCycleSize/2;
    [self addSubview:_borderCycleView];
    
    if (self.indicatorColor) {
        
        _fillCycleView = [[UIView alloc] initWithFrame:CGRectMake(kSideMargin+1, (_cellHeight-kCycleSize)/2+1, kFillSize, kFillSize)];
        _fillCycleView.backgroundColor = self.indicatorColor ?: [UIColor clearColor];
        _fillCycleView.layer.cornerRadius = kFillSize/2;
        _fillCycleView.center = _borderCycleView.center;
        [self addSubview:_fillCycleView];
    }
    
    // make bottom line
    if (self.shouldShowBottomLine) {
        _topLineView = [[UIImageView alloc] initWithImage:lineImage];
        _topLineView.frame = CGRectMake(kSideMargin+kCycleSize/2, CGRectGetMaxY(_borderCycleView.frame), kLineWidth, (_cellHeight-kCycleSize)/2);
        [self addSubview:_topLineView];
    }
    
    
    // reset frame
    frame = self.frame;
    frame.size.height = _cellHeight;
    self.frame = frame;
}

#pragma mark - 构造AttributeLabel
- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label maxWidth:(CGFloat)maxWidth
{
    [label setNeedsDisplay];
    //NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
    
    NSString *text = [CustomMethod transformString:o_text emojiDic:self.emojiDic];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:kTextFont]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString *string = attString.string;
    
    if ([emailArr count]) {
        for (NSString *emailStr in emailArr) {
            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
        }
    }
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([self.hyperLinkArray count]) {
        for (NSString *httpStr in self.hyperLinkArray) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
}

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    NSString *requestString = [linkInfo.URL absoluteString];
    NSLog(@"%@",requestString);
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }
    
    return NO;
}



@end
