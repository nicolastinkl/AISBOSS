//
//  AIServiceDetailUIModel.m
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceDetailUIModel.h"

@implementation AIServiceDetailUIModel

@end


// case Input =                  "Input"          // 输入控件
@implementation AIInputViewModel

@end

// case Price =                  "Price"          // 价格

@implementation AIPriceModel

- (id) init
{
    self = [super init];
    
    if (self) {
        _price = @"";
        _totalPriceDesc = @"";
        _billingMode = @"";
        _currency = @"";
        
    }
    
    return self;
}


@end

@implementation AIPriceViewModel


- (id) init
{
    self = [super init];
    
    if (self) {
        _finalPrice = @"";
        _totalPriceDesc = @"";
        _defaultNumber = 0;
        _minNumber = 0;
        _maxNumber = 0;
        _defaultPrice = [[AIPriceModel alloc] init ];
    }
    
    return self;
}


@end

// case Calendar =               "Calendar"       // 日历

@implementation AICanlendarViewModel

@end

// case SingalOption =           "SingalOption"   // 单选
@implementation AIOptionModel

@end

@implementation AIServiceTypesModel

@end

// case ComplexLabel =           "ComplexLabel"   // 复合标签组

@implementation AIComplexLabelModel

@end

@implementation AIComplexLabelsModel

@end

// case TitleLabel =             "TitleLabels"    // 彩色标签

@implementation AIServiceCoverageModel

@end

// case Picker =                 "Picker"         // pick选择

@implementation AIPickerViewModel

@end

// case TextDetail =             "TextDetail"     // 描述信息

@implementation AIDetailTextModel

@end

// case Services =               "Services"       // 切换服务商

@implementation AIServiceProviderModel

@end


@implementation AIServiceProviderViewModel

@end
