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
#import "Veris-Swift.h"

@interface AIParamedicView ()
{
    CGFloat _sideMargin;
}

@property (nonatomic, strong) AIProposalServiceDetailModel *detailModel;
@property (nonatomic, strong) NSMutableDictionary *selectedParamsDic;
@property AIProposalServiceDetailParamModel *coverageModel;

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

    AIServiceCoverage *corverage = [self addServiceCoverage:coverageFrame];

    if (corverage) {
        y += [AITools displaySizeFrom1080DesignSize:70] + CGRectGetHeight(corverage.frame);
    }    
    
    CGFloat imageHeight = [AITools displaySizeFrom1080DesignSize:97];
    UIImage *image = [UIImage imageNamed:@"Wave_BG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight);
    [self addSubview:imageView];
    //
    
    NSString *price = [NSString stringWithFormat:@"%@ %ld %@", _detailModel.service_price.unit, (NSInteger)_detailModel.service_price.price, _detailModel.service_price.billing_mode];
    UPLabel *amLabel = [AIViews normalLabelWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), imageHeight) text:price fontSize:[AITools displaySizeFrom1080DesignSize:63] color:[AITools colorWithR:0xf7 g:0x9a b:0x00]];
    
    amLabel.attributedText = [self attrAmountWithAmount:price];
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

- (AIServiceCoverage *) addServiceCoverage: (CGRect) frame
{
    AIServiceCoverage *serviceCoverage;
    
    for (int i = 0; i < _detailModel.service_param_list.count; i++)
    {
        AIProposalServiceDetailParamModel *param = [_detailModel.service_param_list objectAtIndex:i];
        
        if ([param.param_name isEqual: @"Service Coverage"]) {
            _coverageModel = param;
            serviceCoverage = [[AIServiceCoverage alloc] initWithFrame:frame model:param];
            break;
        }
    }
    
    if (serviceCoverage != nil) {
        [self addSubview:serviceCoverage];
        serviceCoverage.delegate = self;
    }
    
    return serviceCoverage;
}


- (void)addLineViewAtY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
    
}


#pragma mark - AIBuyerParamsDelegate
- (NSArray *)getSelectedParams
{
    if (_selectedParamsDic != nil && [_selectedParamsDic count] > 0) {
        return [self findSubmitData];
    } else {
        return nil;
    }
}

- (NSArray *) findSubmitData
{
    
    
    NSMutableArray *params = [[NSMutableArray alloc]init];
    
    JSONModel *model = [AIServiceDetailTool createServiceSubmitModel:_detailModel param:_coverageModel paramContentDic:_selectedParamsDic];
    
    if (model) {
        [params addObject:model];
    }
    
//    NSEnumerator *enumeratorObject = [_selectedParamsDic objectEnumerator];
    
//    for (AIProposalServiceDetailParamValueModel *object in enumeratorObject) {
//        
//        AIProposalServiceParamRelationModel *m = [AIServiceDetailTool findParamRelated:_detailModel selectedParamValue: object];
//        if (m) {
//            JSONModel *submitData = [AIServiceDetailTool createServiceSubmitModel:_detailModel relation:m];
//            if (submitData) {
//                [params addObject:submitData];
//            }
//        }
//    }
    return params;
}


#pragma mark - AIServiceTypesDelegate

- (void)didSelectedAtIndex:(NSInteger)index
{
    
}

#pragma mark - AIServiceCoverageDelegate
- (void)didChooseServiceLabelModel:(AIProposalServiceDetailParamValueModel *)labelModel isSelected:(BOOL)selected
{
    if (_selectedParamsDic == nil) {
        _selectedParamsDic = [[NSMutableDictionary alloc]init];
    }
   
    NSString *serviceId = [NSString stringWithFormat:@"%ld",labelModel.id];
    if (selected) {
        _selectedParamsDic[serviceId] = labelModel;
    } else {
        [_selectedParamsDic removeObjectForKey: serviceId];
    }
}

@end
