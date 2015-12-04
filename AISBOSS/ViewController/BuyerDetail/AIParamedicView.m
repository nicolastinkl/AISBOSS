//
//  AIParamedicView.m
//  AIVeris
//
//  Created by 王坜 on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIParamedicView.h"
#import "AIServiceCoverage.h"
#import "AIDetailText.h"


#import "AITools.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"

@interface AIParamedicView ()
{
    CGFloat _sideMargin;
}

@property (nonatomic, strong) AIProposalServiceDetailModel *detailModel;

@end


@implementation AIParamedicView


- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.detailModel = model;
        [self makeProperties];
        [self makeSubViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeProperties];
        [self makeSubViews];
    }
    
    return self;
}


- (void)makeProperties
{
    _sideMargin = [AITools displaySizeFrom1080DesignSize:35];
}


- (NSAttributedString *)attrAmountWithAmount:(NSString *)amount
{
    
    if (amount == nil || amount.length == 0) {
        return nil;
    }
    // find range
    
    NSRange anchorRange = [amount rangeOfString:@"/"];
    
    if (anchorRange.location == NSNotFound) {
        return nil;
    }
    
    NSRange headRange = NSMakeRange(0, anchorRange.location - 1);
    
    NSRange tailRange = NSMakeRange(anchorRange.location, amount.length - anchorRange.location);
    
    UIFont *headFont = [AITools myriadSemiboldSemiCnWithSize:[AITools displaySizeFrom1080DesignSize:63]];
    UIFont *tailFont = [AITools myriadLightSemiCondensedWithSize:[AITools displaySizeFrom1080DesignSize:42]];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:amount];
    [attriString addAttribute:NSFontAttributeName value:headFont range:headRange];
    [attriString addAttribute:NSFontAttributeName value:tailFont range:tailRange];
    
    
    return attriString;
}

- (void)makeSubViews
{
    CGFloat y = [AITools displaySizeFrom1080DesignSize:32];
    CGFloat width = CGRectGetWidth(self.frame) - _sideMargin * 2;
    //
    CGRect textFrame = CGRectMake(_sideMargin, y, width, 0);

    AIDetailText *detailText = [[AIDetailText alloc] initWithFrame:textFrame titile:self.detailModel.service_intro_title detail:self.detailModel.service_intro_content];
    [self addSubview:detailText];
    
    //
    y += CGRectGetHeight(detailText.frame) + [AITools displaySizeFrom1080DesignSize:34] - 4;
    [self addLineViewAtY:y];
    //
    y += [AITools displaySizeFrom1080DesignSize:38];
    
    CGRect coverageFrame = CGRectMake(_sideMargin, y, width, 0);

    AIServiceCoverage *corverage = [[AIServiceCoverage alloc] initWithFrame:coverageFrame model:_detailModel.service_param_list.firstObject];
    [self addSubview:corverage];
    
    //
    //
    y += [AITools displaySizeFrom1080DesignSize:70] + CGRectGetHeight(corverage.frame);
    
    CGFloat imageHeight = [AITools displaySizeFrom1080DesignSize:97];
    UIImage *image = [UIImage imageNamed:@"Wave_BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight);
    [self addSubview:imageView];
    //
    UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight) text:_detailModel.service_price.original fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
    
    amLabel.attributedText = [self attrAmountWithAmount:_detailModel.service_price.original];
    amLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:amLabel];
    
    
    //
    y += [AITools displaySizeFrom1080DesignSize:14] + imageHeight;
    [self addLineViewAtY:y];
    y += 1;
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;

}

- (void)addLineViewAtY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
}

@end
