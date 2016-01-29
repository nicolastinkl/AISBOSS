//
//  AIProposalServiceParser.m
//  AIVeris
//
//  Created by 王坜 on 16/1/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIProposalServiceParser.h"
#import "AIServiceDetailUIModel.h"

@interface AIProposalServiceParser ()

@property (nonatomic, strong) NSArray *displayParams;

@property (nonatomic, strong) NSArray *relatedParams;

@property (nonatomic, strong) NSArray *serviceParams;

@property (nonatomic, strong) NSNumber *serviceID;

@end

@implementation AIProposalServiceParser

- (id)initWithServiceID:(NSInteger)serviceID serviceParams:(NSArray *)params relatedParams:(NSArray *)relatedParams displayParams:(NSArray *)displayParams
{
    self = [super init];
    
    if (self) {
        if (displayParams) {
            self.serviceParams = params;
            self.displayParams = displayParams;
            self.relatedParams = relatedParams;
            self.serviceID = [NSNumber numberWithInteger:serviceID];
    
            self.displayModels = [[NSMutableArray alloc] init];
            [self parseParams:displayParams];
        }
    }
    
    return self;
}
#pragma mark - 解析

- (void)parseParams:(NSArray *)params
{
    
    @try {
        NSUInteger number = params.count;
        if ( params != nil && number > 0){
            
            for (NSDictionary *param in params) {
                if ([param isKindOfClass:[NSDictionary class]]) {
                    
                    NSNumber *type = [param objectForKey:@"ui_template_type"];
                    if (type) {
                        switch (type.integerValue) {
                            case 1: // title + detail
                                [self parse1WithParam:param];
                                break;
                            case 2: // 单选checkbox组
                                [self parse2WithParam:param];
                                break;
                            case 3: // 金额展示
                                [self parse3WithParam:param];
                                break;
                            case 4: // 标签组复合控件，可多选，单选，可分层
                                [self parse4WithParam:param];
                                break;
                            case 5: // 时间，日历
                                [self parse5WithParam:param];
                                break;
                            case 6: // 输入框
                                [self parse6WithParam:param];
                                break;
                            case 7: // 普通标签：title + 标签组
                                [self parse7WithParam:param];
                                break;
                            case 8: // 切换服务标签
                                [self parse8WithParam:param];
                                break;
                            case 9: // picker控件
                                [self parse9WithParam:param];
                                break;
                                
                            default:
                                break;
                        }
                    }
                } }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
#pragma mark - 解析保存参数

// 判断是否有关联参数
- (BOOL)isExistRelParams
{
    return (_relatedParams != nil && _relatedParams.count > 0);
}

// 判断是否有服务参数
- (BOOL)isExistServiceParams
{
    return (_serviceParams != nil && _serviceParams.count > 0);
}

- (void)parserBaseSavedParams:(NSDictionary *)params forModel:(JSONModel *)model
{
    
    model.serviceParams = _serviceParams;
    model.relatedParams = _relatedParams;
    model.displayParams = params;

    if ([[params objectForKey:@"ui_template_content"] isMemberOfClass:[NSDictionary class]]) {
        
        NSDictionary *content = [params objectForKey:@"ui_template_content"];
        NSNumber *isPriceRelated = [content objectForKey:@"is_price_related"];
        model.isPriceRelated = isPriceRelated.boolValue;
        model.service_id_save = _serviceID;
        model.source_save = [content objectForKey:@"param_source"];
    }
    
    
    /*
     NSString *paramSource = [content objectForKey:@"param_source"];
     
     
     if ([paramSource isEqualToString:@"product"]) { // 产品类型
     NSArray *param_value = [content objectForKey:@"param_value"];
     if (param_value.count > 0 && _relatedParams.count > 0) { // 有关联参数
     model.product_id_save = [content objectForKey:@"param_source_id"];
     }
     else
     {
     model.product_id_save = [content objectForKey:@"param_source_id"];
     }
     
     
     model.product_id_save = [content objectForKey:@"param_source_id"];
     //model.role_id_save =
     
     
     }else if ([paramSource containsString:@"param"]) { // offerring类型
     
     }else { // 其他普通参数
     
     }
     */
    
    
    
    
    

}

#pragma mark - 解析 1  title + detail

- (void)parse1WithParam:(NSDictionary *)param
{
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIDetailTextModel *model = [[AIDetailTextModel alloc] init];

    model.title = [content objectForKey:@"title"];
    model.content = [content objectForKey:@"detail"];
    
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];

    // 设置控件类型
    [model setDisplayType:1];
    [_displayModels addObject:model];
    
}

#pragma mark - 解析 2 单选checkbox组
- (void)parse2WithParam:(NSDictionary *)param
{
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIServiceTypesModel *model = [[AIServiceTypesModel alloc] init];
    model.title = [content objectForKey:@"param_name"];
    
    NSArray *pArray = [content objectForKey:@"param_value"];
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in pArray) {
        AIOptionModel *option = [[AIOptionModel alloc] init];
        option.identifier = [dic objectForKey:@"id"];
        option.desc = [dic objectForKey:@"content"];
        option.isSelected = [[dic objectForKey:@"is_default"] isEqualToNumber:[NSNumber numberWithInteger:1]];
        [options addObject:option];
    }
    
    model.typeOptions = options;
    model.params = nil;
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];

    // 设置控件类型
    [model setDisplayType:2];
    [_displayModels addObject:model];
    
}

#pragma mark - 解析 3 金额展示
- (void)parse3WithParam:(NSDictionary *)param
{
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIPriceViewModel *model = [[AIPriceViewModel alloc] init];
    NSNumber *defaultNumber = [content objectForKey:@"default_number"];
    NSNumber *maxNumber = [content objectForKey:@"max_number"];
    NSNumber *minNumber = [content objectForKey:@"min_number"];
    model.defaultNumber = defaultNumber.integerValue;
    model.minNumber = minNumber.integerValue;
    model.maxNumber = maxNumber.integerValue;
    
    NSDictionary *priceDic = [content objectForKey:@"default_price"];
    AIPriceModel *priceM = [[AIPriceModel alloc] init];
    
    if (content[@"total_price_desc"] && [content[@"total_price_desc"] length]) {
        priceM.totalPriceDesc = content[@"total_price_desc"];
        model.totalPriceDesc = content[@"total_price_desc"];
    }else {
        priceM.price = [NSString stringWithFormat:@"%@", [priceDic objectForKey:@"price"] ?: @"0"];
        priceM.currency = [priceDic objectForKey:@"unit"];
        priceM.billingMode = [priceDic objectForKey:@"billing_mode"];
        model.defaultPrice = priceM;
    }
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];
    
    // 设置控件类型
    [model setDisplayType:3];
    [_displayModels addObject:model];
    
}

#pragma mark - 解析 4 标签组复合控件，可多选，单选，可分层
- (void)parse4WithParam:(NSDictionary *)param
{
    NSArray *list = [param objectForKey:@"ui_template_content"];
    NSDictionary *content = [list objectAtIndex:0];
    AIComplexLabelsModel *model = [[AIComplexLabelsModel alloc] init];
    model.title = [content objectForKey:@"param_name"];
    
   
    void(^recursiveBlock)(NSArray *,AIComplexLabelModel *) = ^(NSArray *inputArray,AIComplexLabelModel *parentLabel) {
        
    };
    
    NSMutableArray *level1 = [NSMutableArray array];
    for (NSDictionary *dic in [content objectForKey:@"param_value"]) {
        AIComplexLabelModel *sModel = [[AIComplexLabelModel alloc] init];
        sModel.atitle = [dic objectForKey:@"content"];
        NSNumber *ide = [dic objectForKey:@"id"];
        sModel.identifier = ide.integerValue;
        sModel.sublabels = [[NSMutableArray alloc] init];
        NSNumber *se = [dic objectForKey:@"is_default"];
        sModel.isSelected = se.boolValue;
        [level1 addObject:sModel];
    }
    
    
    model.labels = [self makeComplexArrayWithArray:level1];
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];

    // 设置控件类型
    [model setDisplayType:4];
    [_displayModels addObject:model];
    
}


- (NSArray *)makeComplexArrayWithArray:(NSArray *)array
{
    for ( AIComplexLabelModel *model in array) {
        for (NSDictionary *dic in self.relatedParams) {
            NSDictionary *param = [dic objectForKey:@"param"];
            
            if ([[param objectForKey:@"param_value_key"] isKindOfClass:[NSNumber class]]){
                NSNumber *value_key = [param objectForKey:@"param_value_key"];
                if (value_key.integerValue == model.identifier) {
                    NSDictionary *rel_param = [dic objectForKey:@"rel_param"];
                    NSNumber *subLabelsKey = [rel_param objectForKey:@"param_key"];
                    
                    for (NSDictionary *service_dic in self.serviceParams) {
                        NSNumber *ffkey = [service_dic objectForKey:@"param_key"];
                        if (subLabelsKey.integerValue == ffkey.integerValue) {
                            NSArray *param_value = [service_dic objectForKey:@"param_value"];
                            NSMutableArray *subLabels = [[NSMutableArray alloc] init];
                            
                            for (NSDictionary *subParam in param_value) {
                                AIComplexLabelModel *sModel = [[AIComplexLabelModel alloc] init];
                                sModel.atitle = [subParam objectForKey:@"content"];
                                NSNumber *ide = [subParam objectForKey:@"id"];
                                sModel.identifier = ide.integerValue;
                                NSNumber *se = [subParam objectForKey:@"is_default"];
                                sModel.adesc = [subParam objectForKey:@"param_description"];;
                                sModel.isSelected = se.boolValue;
                                
                                [subLabels addObject:sModel];
                            }
                            
                            model.sublabels = subLabels;
                            break;
                            
                        }
                    }
                    
                }
                
            }//end
            
            
        }
    }
    
    return array;
}

#pragma mark - 解析 5 时间，日历
- (void)parse5WithParam:(NSDictionary *)param
{
    AICanlendarViewModel *model = [[AICanlendarViewModel alloc] init];
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];
    
    // 设置控件类型
    [model setDisplayType:5];
    [_displayModels addObject:model];
}

#pragma mark - 解析 6 输入框
- (void)parse6WithParam:(NSDictionary *)param
{
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIInputViewModel *model = [[AIInputViewModel alloc] init];
    model.title = [content objectForKey:@"param_name"];
    model.defaultText = [content objectForKey:@"default_value"];
    model.tail = [content objectForKey:@"unit"];
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];

    // 设置控件类型
    [model setDisplayType:6];
    [_displayModels addObject:model];
}

#pragma mark - 解析 7 普通标签：title + 标签组
- (void)parse7WithParam:(NSDictionary *)param
{
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIServiceCoverageModel *model = [[AIServiceCoverageModel alloc] init];
    
    model.title = [content objectForKey:@"param_name"];
    
    NSArray *array = [content objectForKey:@"param_value"];
    
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in array) {
        AIOptionModel *option = [[AIOptionModel alloc] init];
        option.identifier = [dic objectForKey:@"id"];
        option.desc = [dic objectForKey:@"content"];
        option.isSelected = [[dic objectForKey:@"is_default"] isEqualToNumber:[NSNumber numberWithInteger:1]];
        [options addObject:option];
    }
    
    model.options = options;
    model.params = nil;
    model.modelType = 0;
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];
    
    
    // 设置控件类型
    [model setDisplayType:7];
    [_displayModels addObject:model];
}

#pragma mark - 解析 8 切换服务标签
- (void)parse8WithParam:(NSDictionary *)param
{
    NSArray *content = [param objectForKey:@"ui_template_content"];
    AIServiceProviderViewModel *model = [[AIServiceProviderViewModel alloc] init];
    
    NSMutableArray *providers = [NSMutableArray array];
    for (NSDictionary *dic in content) {
        AIServiceProviderModel *provider = [[AIServiceProviderModel alloc] init];
        NSNumber *ide = [dic objectForKey:@"service_id"];
        provider.identifier = ide.integerValue;
        provider.name = [dic objectForKey:@"service_name"];
        provider.icon = [dic objectForKey:@"service_thumbnail_icon"];
        provider.isSelected = NO;
        
        [providers addObject:provider];
        
    }
    
    model.providers = providers;
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];
    
    [model setDisplayType:8];
    [_displayModels addObject:model];
}

#pragma mark - 解析 9 picker控件
- (void)parse9WithParam:(NSDictionary *)param
{
    AIServiceProviderViewModel *model = [[AIServiceProviderViewModel alloc] init];
    
    NSMutableArray *providers = [NSMutableArray array];
    AIServiceProviderModel *provider = [[AIServiceProviderModel alloc] init];
     
    provider.identifier = 123;
    provider.name = @"asdfq34";
    provider.icon = @"";
    provider.isSelected = NO;
    
    [providers addObject:provider];
    model.providers = providers;
    
    
    // 设置基本参数
    [self parserBaseSavedParams:param forModel:model];
    
    [model setDisplayType:9];
    [_displayModels addObject:model];
    
}



@end
