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

- (NSArray *)getSelectedParams{
    return @[];
}

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model
{
    self = [super initWithFrame:frame];

    if (self) {
        _sideMargin = [AITools displaySizeFrom1080DesignSize:35];

        self.detailModel = model;
    }

    return self;
}

- (PKYStepper *)selectedCounter {
    return self.priceView.stepper;
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
    CGFloat totalHeight = [AITools displaySizeFrom1080DesignSize:97];
    NSString *price = [NSString stringWithFormat:@"%@ %ld %@", self.detailModel.service_price.unit, (NSInteger)self.detailModel.service_price.price, self.detailModel.service_price.billing_mode];
    
    CGRect frame = CGRectMake(0, positionY, totalWidth, totalHeight);
    
    __weak ProposalServiceDetailBaseView *weakself = self;
    PriceAndStepperView *priceView = [[PriceAndStepperView alloc]initWithFrame:frame price:price showStepper:YES defaultValue:0 minValue:0 maxValue:-1 onValueChanged:^(PKYStepper * stepper, float newValue) {
       [weakself serviceSelectedCountChanged:stepper count:newValue];
    }];
    
    [self addSubview:priceView];

    return totalHeight;
//
////    bg image
//    {
//        UIImage *backgroundImage = [UIImage imageNamed:@"Wave_BG"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
//        imageView.frame = CGRectMake(0, positionY, CGRectGetWidth(self.frame), totalHeight);
//        [self addSubview:imageView];
//    }
//
////    stepper
//    {
//        CGFloat counterWidth = 120;
//        self.selectedCounter = [[PKYStepper alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) -  counterWidth - self.sideMargin, positionY, counterWidth, totalHeight)];
//        [self.selectedCounter setBorderColor:[UIColor whiteColor]];
//        [self.selectedCounter setBorderWidth:0.5];
//        [self.selectedCounter setLabelTextColor:[UIColor whiteColor]];
//        self.selectedCounter.countLabel.layer.borderWidth = 0.5;
//        self.selectedCounter.buttonWidth = 34;
//        [self.selectedCounter setButtonTextColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.selectedCounter setButtonTextColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [self.selectedCounter setButtonFont:[AITools myriadSemiCondensedWithSize:29]];
//        [self.selectedCounter.decrementButton setTitle:@"-" forState:UIControlStateNormal];
//        self.selectedCounter.countLabel.text = @"0";
//        [self.selectedCounter setup];
//
//        __weak ProposalServiceDetailBaseView *weakself = self;
//        [self.selectedCounter setValueChangedCallback:^(PKYStepper *stepper, float newValue) {
//            [weakself serviceSelectedCountChanged:stepper count:newValue];
//        }];
//
//        [self addSubview:self.selectedCounter];
//    }
//
////    title label
//    {
//        UILabel *selectedTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.selectedCounter.origin.x, self.selectedCounter.origin.y - 20, self.selectedCounter.width, 20)];
//
//        selectedTitle.textColor = [UIColor whiteColor];
//        selectedTitle.font = [AITools myriadSemiCondensedWithSize:15];
//        selectedTitle.text = @"Selected Amount";
//        selectedTitle.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:selectedTitle];
//    }
//
//
//    //price label
//    {
//        NSString *price = [NSString stringWithFormat:@"%@ %ld %@", self.detailModel.service_price.unit, (NSInteger)self.detailModel.service_price.price, self.detailModel.service_price.billing_mode];
//        UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(self.sideMargin, positionY, totalWidth - self.selectedCounter.width - self.sideMargin, totalHeight) text:price fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
//
//        amLabel.attributedText = [self attrAmountWithAmount:price];
//
//        [self addSubview:amLabel];
//    }
//
//    return totalHeight;
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

- (void)serviceSelectedCountChanged:(PKYStepper *)stepper count:(float)count {
    stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
}

@end
