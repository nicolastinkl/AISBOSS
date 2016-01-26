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

@end

@implementation AIProposalServiceParser

- (id)initWithServiceParams:(NSArray *)params relatedParams:(NSArray *)relatedParams displayParams:(NSArray *)displayParams
{
    self = [super init];
    
    if (self) {
        if (displayParams) {
            self.serviceParams = params;
            self.displayParams = displayParams;
            self.relatedParams = relatedParams;
    
            self.displayModels = [[NSMutableArray alloc] init];
            [self parseParams:displayParams];
        }
    }
    
    return self;
}
#pragma mark - 解析

- (void)parseParams:(NSArray *)params
{
    for (NSDictionary *param in params) {
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
                case 5: // picker控件，时间，日历
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
                    
                default:
                    break;
            }
        }
    }
}


#pragma mark - 解析 1

- (void)parse1WithParam:(NSDictionary *)param
{
    /*
     "ui_template_type":1,
     "ui_template_content":{
     "atom_ui_template_type":-1,
     "title":"Category Notes",
     "detail":"1.Planning the event,coordinating the activities,onsite supervising,€800\n2.Designing and making exhibition board,€20/m2\n3.Onsite service,€10/per service staff "
     }
     */
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIDetailTextModel *model = [[AIDetailTextModel alloc] init];

    model.title = [content objectForKey:@"title"];
    model.content = [content objectForKey:@"detail"];
    
    [model setDisplayType:1];
    [_displayModels addObject:model];
    
}

#pragma mark - 解析 2
- (void)parse2WithParam:(NSDictionary *)param
{
    /*
     "ui_template_type":2,
     "ui_template_content":{
     "param_key":100000000609,
     "atom_ui_template_type":1,
     "param_name":"Rental duration",
     "param_source":"offering_param",
     "param_source_id":"",
     "param_type":"",
     "max_cardinality":0,
     "min_cardinality":0,
     "is_customized":0,
     "is_price_related":1,
     "param_value":[
     {
     "id":100000002224,
     "content":"Half day",
     "is_default":0,
     "source":"offering"
     },
     {
     "id":100000002226,
     "content":"One day",
     "is_default":0,
     "source":"offering"
     }
     ]
     }
     
     NSArray *colors = @[[AITools colorWithHexString:@"1c789f"],
     [AITools colorWithHexString:@"7b3990"],
     [AITools colorWithHexString:@"619505"],
     [AITools colorWithHexString:@"f79a00"],
     [AITools colorWithHexString:@"d05126"],
     [AITools colorWithHexString:@"b32b1d"]];
     
     
     @property (nonatomic, strong) NSString<Optional> *identifier;
     
     @property (nonatomic, strong) NSString<Optional> *desc;
     
     @property (nonatomic, assign) BOOL isSelected;
     
     @property (nonatomic, strong) NSString<Optional> *displayColor;
     */
    
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
    [model setDisplayType:2];
    [_displayModels addObject:model];
    
}

#pragma mark - 解析 3
- (void)parse3WithParam:(NSDictionary *)param
{
    /*
     
     "ui_template_type":3,
     "ui_template_content":{
     "param_key":800402,
     "param_name":"RESOURCE_AMOUNT",
     "atom_ui_template_type":-1,
     "default_price":{
     "price":800,
     "billing_mode":"floating",
     "unit":"€"
     },
     "default_number":0,
     "min_number":1,
     "max_number":10
     }
     
     */
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
    
    priceM.price = [NSString stringWithFormat:@"%@", [priceDic objectForKey:@"price"] ?: @"0"];
    priceM.currency = [priceDic objectForKey:@"unit"];
    priceM.billingMode = [priceDic objectForKey:@"billing_mode"];
    model.defaultPrice = priceM;
    [model setDisplayType:3];
    [_displayModels addObject:model];
    
    
    
}

#pragma mark - 解析 4
- (void)parse4WithParam:(NSDictionary *)param
{
    /*"ui_template_type":4,
     "ui_template_content":[
     {
     "atom_ui_template_type":1,
     "param_key":100000001414,
     "is_display":1,
     "param_type":2,
     "param_name":"Western buffet",
     "param_source":"product",
     "param_source_id":100000001414,
     "max_cardinality":1,
     "mix_cardinality":1,
     "is_price_related":0,
     "is_customized":0,
     "param_value":[
     {
     "id":100000000400,
     "content":"Tea break",
     "is_default":0,
     "source":"product"
     },
     {
     "id":100000000401,
     "content":"Chinese buffet",
     "is_default":0,
     "source":"product"
     },
     {
     "id":100000000402,
     "content":"Western buffet",
     "is_default":0,
     "source":"product"
     }
     ]
     
     @property (nonatomic, strong) NSString<Optional> *title;
     @property (nonatomic, assign) NSInteger identifier;
     @property (nonatomic, strong) AIDetailTextModel<Optional> *desc;
     @property (nonatomic, strong) NSArray<Optional> *sublabels;
     
     
     @property (nonatomic, strong) NSString<Optional> *title;
     @property (nonatomic, strong) NSArray<Optional> *selected_label_id;
     @property (nonatomic, strong) NSArray<Optional> *labels;
     */
    NSArray *list = [param objectForKey:@"ui_template_content"];
    NSDictionary *content = [list objectAtIndex:0];
    AIComplexLabelsModel *model = [[AIComplexLabelsModel alloc] init];
    model.title = [content objectForKey:@"param_name"];
    
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
    [model setDisplayType:4];
    [_displayModels addObject:model];
    
}


- (NSArray *)makeComplexArrayWithArray:(NSArray *)array
{
    for ( AIComplexLabelModel *model in array) {
        for (NSDictionary *dic in self.relatedParams) {
            NSDictionary *param = [dic objectForKey:@"param"];
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
        }
    }
    
    return array;
}

#pragma mark - 解析 5
- (void)parse5WithParam:(NSDictionary *)param
{
    /*
     "ui_template_type":5,
     "ui_template_content":{
     "param_key":100000000608,
     "param_name":"Event Time",
     "atom_ui_template_type":-1,
     "param_source":"offering_param",
     "param_source_id":"",
     "max_cardinality":0,
     "min_cardinality":0,
     "is_customized":0,
     "is_price_related":0,
     "param_type":"",
     "value":"",
     "param_value":[
     {
     "id":"",
     "content":"",
     "is_default":0,
     "source":""
     }
     ]
     }
     */
    
    AICanlendarViewModel *model = [[AICanlendarViewModel alloc] init];
    [model setDisplayType:5];
    [_displayModels addObject:model];
}

#pragma mark - 解析 6
- (void)parse6WithParam:(NSDictionary *)param
{
    /*
     
     "ui_template_content":{
     "param_key":100000000800,
     "param_name":"Event Capacity",
     "atom_ui_template_type":-1,
     "param_source":"offering_param",
     "param_source_id":"",
     "max_cardinality":500,
     "min_cardinality":1,
     "is_customized":1,
     "is_price_related":0,
     "param_type":"1",
     "value":"",
     "param_value":[
     {
     "id":"",
     "content":"",
     "is_default":0,
     "source":""
     }
     ]
     }
     
     */
    NSDictionary *content = [param objectForKey:@"ui_template_content"];
    AIInputViewModel *model = [[AIInputViewModel alloc] init];
    model.title = [content objectForKey:@"param_name"];
    model.defaultText = [content objectForKey:@""];
    model.tail = [content objectForKey:@"value"];
    [model setDisplayType:6];
    [_displayModels addObject:model];
}

#pragma mark - 解析 7
- (void)parse7WithParam:(NSDictionary *)param
{
    /*
     "ui_template_type":7,
     "ui_template_content":{
     "param_key":100000000611,
     "param_name":"Service Coverage",
     "atom_ui_template_type":2,
     "param_source":"offering_param",
     "param_source_id":"",
     "param_type":"",
     "max_cardinality":4,
     "min_cardinality":0,
     "is_customized":0,
     "is_price_related":0,
     "param_value":[
     {
     "id":100000002228,
     "content":"Board design ",
     "is_default":0,
     "source":"offering"
     },
     {
     "id":100000002233,
     "content":"Event planning ",
     "is_default":0,
     "source":"offering"
     },
     {
     "id":100000002222,
     "content":"Onsite service",
     "is_default":0,
     "source":"offering"
     },
     {
     "id":100000002422,
     "content":"Professional presenter",
     "is_default":0,
     "source":"offering"
     }
     ]
     }
     
     @property (nonatomic, strong) NSString<Optional> *title;
     
     @property (nonatomic, strong) NSArray<Optional, AIOptionModel> *options;
     
     @property (nonatomic, strong) NSDictionary<Optional> *params;
     
     @property (nonatomic, assign) NSInteger modelType;
     */
    
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
    [model setDisplayType:7];
    [_displayModels addObject:model];
}

#pragma mark - 解析 8
- (void)parse8WithParam:(NSDictionary *)param
{
    /*
     "ui_template_type":8,
     "ui_template_content":[
     {
     "service_id":900001001202,
     "service_name":"Venue Rental",
     "service_thumbnail_icon":"http://171.221.254.231:3000/upload/proposal/TyDUxO7UXgHeL.png"
     },
     {
     "service_id":900001001600,
     "service_name":"Venue Rental",
     "service_thumbnail_icon":"http://171.221.254.231:3000/upload/proposal/TyDUxO7UXgHeL.png"
     }
     ]

     */
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
    [model setDisplayType:8];
    [_displayModels addObject:model];
}
@end
