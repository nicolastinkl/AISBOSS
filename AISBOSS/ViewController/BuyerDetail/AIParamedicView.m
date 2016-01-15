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
#import "PKYStepper.h"


#import "AITools.h"
#import "AIViews.h"
#import "UP_NSString+Size.h"
#import "Veris-Swift.h"

@interface AIParamedicView ()


@property (nonatomic, strong) NSMutableDictionary *selectedParamsDic;
@property (nonatomic, strong) NSMutableDictionary *defaultParamsDic;
@property AIProposalServiceDetailParamModel *coverageModel;

@end


@implementation AIParamedicView


- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetailModel *)model shouldShowParams:(BOOL)should
{
    self = [super initWithFrame:frame model:model shouldShowParams:should];
    
    if (self) {
        [self makeSubViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeSubViews];
    }
    
    return self;
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
    CGFloat viewHeight = 0;
    CGFloat y = [AITools displaySizeFrom1080DesignSize:32];
    
    viewHeight = [self addDetailText:y];

    y += viewHeight + [AITools displaySizeFrom1080DesignSize:34] - 4;
    
    
    [self addLineViewAtY:y];
    
    if (_shouldShowParams) {
        y += [AITools displaySizeFrom1080DesignSize:38];
        
        viewHeight = [self addServiceCoverage:y];
        
        if (viewHeight > 0) {
            y += viewHeight + [AITools displaySizeFrom1080DesignSize:70];
        }
        
        viewHeight = [self addPriceView:y];
        y += [AITools displaySizeFrom1080DesignSize:14] + viewHeight;
        
        
        [self addLineViewAtY:y];
    }
    
    
    
    
    y += 1;
    
    // reset frame
    CGRect myFrame = self.frame;
    myFrame.size.height = y;
    self.frame = myFrame;

}


- (CGFloat) addServiceCoverage: (CGFloat) positionY
{
    CGFloat viewHeight = 0;
    CGFloat width = [self contentViewWidth];
    
    AIServiceCoverage *serviceCoverage;
    
    CGRect coverageFrame = CGRectMake(self.sideMargin, positionY, width, 0);
    
    for (int i = 0; i < self.detailModel.service_param_list.count; i++)
    {
        AIProposalServiceDetailParamModel *param = [self.detailModel.service_param_list objectAtIndex:i];
        
        if ([param.param_name isEqual: @"Service Coverage"]) {
            _coverageModel = param;
            serviceCoverage = [[AIServiceCoverage alloc] initWithFrame:coverageFrame model:param];
            
            [self initSelectedParamsDic: param.param_value];
        }
    }
    
    if (serviceCoverage != nil) {
        [self addSubview:serviceCoverage];
        serviceCoverage.delegate = self;
        viewHeight = CGRectGetHeight(serviceCoverage.frame);
    }
    
    return viewHeight;
}


- (void) initSelectedParamsDic: (NSArray *)paramValues
{
    if (_defaultParamsDic == nil) {
        _defaultParamsDic = [[NSMutableDictionary alloc]init];
    }
    
    for (int i = 0; i < paramValues.count; i++)
    {
        AIProposalServiceDetailParamValueModel *model = [paramValues objectAtIndex:i];
        
        BOOL selected = model.is_default;
        
        if (selected) {
            NSString *serviceId = [NSString stringWithFormat:@"%ld",(long)model.sid];
            _defaultParamsDic[serviceId] = model;
        }
    }
}


- (void)addLineViewAtY:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [AITools colorWithR:0xa1 g:0xa4 b:0xba a:0.4];
    
    [self addSubview:line];
    
}

- (BOOL)isArray:(NSArray *)a contains:(id)obj {
    BOOL result = NO;
//    a
    return result;
}

- (BOOL)isArrayA:(NSArray *)a equalToArrayB:(NSArray *)b
{
    BOOL isSame = YES;
    if (a.count == b.count) {
        for (NSString *defaultKey in a) {
            for (NSString *selectedKey in b) {
                if (![selectedKey isEqualToString:defaultKey]) {
                    isSame = NO;
                    break;
                }
            }
        }
    }
    else
    {
        isSame = NO;
    }
    
    return isSame;
}


- (NSDictionary *)insertDicA:(NSDictionary *)a toDicB:(NSDictionary *)b
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSArray *defaultKeys = a.allKeys;
    NSArray *selectedKeys = b.allKeys;
    
    for (NSString *defaultKey in defaultKeys) {
        [dic setObject:a[defaultKey] forKey:defaultKey];
    
        for (NSString *selectedKey in selectedKeys) {
            if (![selectedKey isEqualToString:defaultKey]) {
               
                [dic setObject:b[selectedKey] forKey:selectedKey];
            }
            else
            {
                
            }
        }
    }
    
    return dic;
}


#pragma mark - AIBuyerParamsDelegate
- (NSArray *)getSelectedParams
{
    //
    NSArray *defaultKeys = _defaultParamsDic.allKeys;
    NSArray *selectedKeys = _selectedParamsDic.allKeys;
    
    BOOL isSame = [self isArray:defaultKeys contains:selectedKeys];

    if (_selectedParamsDic != nil && [_selectedParamsDic count] > 0 && !isSame) {
        return [self findSubmitData];
    } else {
        return nil;
    }
}

- (NSArray *) findSubmitData
{
    
    
    NSMutableArray *params = [[NSMutableArray alloc]init];
    
    JSONModel *model = [AIServiceDetailTool createServiceSubmitModel:self.detailModel param:_coverageModel paramContentDic:_selectedParamsDic];
    
    if (model) {
        [params addObject:model];
    }
    
//    NSEnumerator *enumeratorObject = [_selectedParamsDic objectEnumerator];
    
//    for (AIProposalServiceDetailParamValueModel *object in enumeratorObject) {
//        
//        AIProposalServiceParamRelationModel *m = [AIServiceDetailTool findParamRelated:self.detailModel selectedParamValue: object];
//        if (m) {
//            JSONModel *submitData = [AIServiceDetailTool createServiceSubmitModel:self.detailModel relation:m];
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
        _selectedParamsDic = [[NSMutableDictionary alloc]initWithDictionary:_defaultParamsDic];
    }
   
    NSString *serviceId = [NSString stringWithFormat:@"%ld",(long)labelModel.sid];
    if (selected) {
        _selectedParamsDic[serviceId] = labelModel;
    } else {
        [_selectedParamsDic removeObjectForKey: serviceId];
    }
}

- (void) serviceSelectedCountChanged: (PKYStepper *) stepper count: (float) count
{
    stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
}

@end
