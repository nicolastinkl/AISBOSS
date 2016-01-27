//
//  ProposalServiceDetailBaseView.m
//  AIVeris
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "ProposalServiceDetailBaseView.h"
#import "AIDetailText.h"
#import "AITools.h"
#import "AIViews.h"
#import "Veris-Swift.h"

@interface ProposalServiceDetailBaseView ()

@property (nonatomic, strong) PriceAndStepperView *priceView;
@end

@implementation ProposalServiceDetailBaseView

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model shouldShowParams:(BOOL)should {
    self = [super initWithFrame:frame];

    if (self) {
        _sideMargin = [AITools displaySizeFrom1080DesignSize:35];
        _shouldShowParams = should;
        self.detailModel = model;
    }

    return self;
}

- (CGFloat)addDetailText:(CGFloat)positionY {
    CGFloat width = [self contentViewWidth];
    CGRect textFrame = CGRectMake(_sideMargin, positionY, width, 0);
    AIDetailText *detailText = [[AIDetailText alloc] initWithFrame:textFrame titile:self.detailModel.service_intro_title detail:self.detailModel.service_intro_content];

    [self addSubview:detailText];

    return CGRectGetHeight(detailText.frame);
}

- (CGFloat)addPriceView:(CGFloat)positionY {
    CGFloat totalWidth = self.width;
    CGFloat totalHeight = [AITools displaySizeFrom1080DesignSize:97] + 20;
    NSString *price = [NSString stringWithFormat:@"%@ %ld %@", self.detailModel.service_price.unit, (NSInteger)self.detailModel.service_price.price, self.detailModel.service_price.billing_mode];

    CGRect frame = CGRectMake(0, positionY, totalWidth, totalHeight);

    __weak ProposalServiceDetailBaseView *weakself = self;
    PriceAndStepperView *priceView = [[PriceAndStepperView alloc]initWithFrame:frame price:price showStepper:YES defaultValue:0 minValue:0 maxValue:-1 onValueChanged:^(PriceAndStepperView *stepper) {
    }];

    [self addSubview:priceView];

    return totalHeight;
}

- (CGFloat)contentViewWidth {
    return CGRectGetWidth(self.frame) - _sideMargin * 2;
}

- (NSAttributedString *)attrAmountWithAmount:(NSString *)amount {
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

@end
