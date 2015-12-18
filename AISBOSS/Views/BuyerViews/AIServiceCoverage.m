//
//  AIServiceCoverage.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceCoverage.h"
#import "AIViews.h"
#import "AIServiceLabel.h"
#import "AITools.h"
#import "UP_NSString+Size.h"


@interface AIServiceCoverage () <AIServiceLabelDelegate>
{
    UPLabel *_titleLabel;
    
    CGFloat _titleMargin;
    
    CGFloat _labelMargin;
    
    CGFloat _titleFontSize;
}


@property (nonatomic, strong) AIProposalServiceDetailParamModel *coverageModel;

@end

@implementation AIServiceCoverage


- (instancetype)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailParamModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.coverageModel = model;
        [self makeProperties];
        [self makeTitle];
        [self makeTags];
    }
    
    return self;
}

#pragma mark - 构造基本属性，背景色、圆角等
- (void)makeProperties
{
    _titleMargin = [AITools displaySizeFrom1080DesignSize:51];
    _labelMargin = [AITools displaySizeFrom1080DesignSize:30];
    _titleFontSize = [AITools displaySizeFrom1080DesignSize:42];
}

#pragma mark - 构造title

- (void)makeTitle
{
    UIFont *font = [AITools myriadSemiCondensedWithSize:_titleFontSize];
    CGSize size = [_coverageModel.param_name sizeWithFont:font forWidth:300];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), size.height);
    _titleLabel = [AIViews normalLabelWithFrame:frame text:_coverageModel.param_name fontSize:_titleFontSize color:Color_HighWhite];
    _titleLabel.font = font;
    [self addSubview:_titleLabel];
}

#pragma mark - 构造标签


- (NSArray *)makeColors
{
    NSArray *colors = @[[AITools colorWithHexString:@"1c789f"],
                        [AITools colorWithHexString:@"7b3990"],
                        [AITools colorWithHexString:@"619505"],
                        [AITools colorWithHexString:@"f79a00"],
                        [AITools colorWithHexString:@"d05126"],
                        [AITools colorWithHexString:@"b32b1d"]];
    
    return colors;
}



- (void)makeTags
{
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(_titleLabel.frame) + _titleMargin;
    CGFloat height = [AITools displaySizeFrom1080DesignSize:67];
    NSArray *colors = [self makeColors];
    
    
    for (NSInteger i = 0; i < self.coverageModel.param_value.count; i++) {
        
        AIProposalServiceDetailParamValueModel *model = [self.coverageModel.param_value objectAtIndex:i];
        
        
        CGRect frame = CGRectMake(x, y, 100, height);
        NSString *title = model.content;
        AIServiceLabel *label = [[AIServiceLabel alloc] initWithFrame:frame title:title type:AIServiceLabelTypeSelection isSelected:YES];
        label.delegate = self;
        label.backgroundColor = [colors objectAtIndex:i];
        label.selectionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Coverage%ld", i]];
        
        [self addSubview:label];
        
        if (CGRectGetMaxX(label.frame) > CGRectGetWidth(self.frame)) {
            x = 0;
            y +=  _labelMargin + height;
            frame = CGRectMake(x, y, CGRectGetWidth(label.frame), height);
            label.frame = frame;
        }
        
        x += _labelMargin + CGRectGetWidth(label.frame);
        
    }
    
    CGRect frame = self.frame;
    frame.size.height = y + height;
    
    self.frame = frame;
}


#pragma mark - AIServiceLabelDelegate


- (void)serviceLabel:(AIServiceLabel *)serviceLabel isSelected:(BOOL)selected
{
    if ([self.delegate respondsToSelector:@selector(didChooseServiceLabelModel: isSelected:)]) {
        
        for (AIProposalServiceDetailParamValueModel *model in self.coverageModel.param_value) {
            if ([model.content isEqualToString:serviceLabel.labelTitle]) {
                [self.delegate didChooseServiceLabelModel:model isSelected:selected];
                break;
            }
        }
    }
}

@end
