//
//  AIServiceDetailUIModel.h
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"


/*
 
 case Input =                  "Input"          // 输入控件
 case TitleLabel =             "TitleLabels"    // 彩色标签
 case Price =                  "Price"          // 价格
 case TextDetail =             "TextDetail"     // 描述信息
 case SingalOption =           "SingalOption"   // 单选
 case ComplexLabel =           "ComplexLabel"   // 复合标签组
 case Picker =                 "Picker"         // pick选择
 case Calendar =               "Calendar"       // 日历
 case Services =               "Services"       // 切换服务商
 
 */



@interface AIServiceDetailUIModel : JSONModel

@end

// case Input =                  "Input"          // 输入控件
@protocol AIInputViewModel

@end

@interface AIInputViewModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSString<Optional> *defaultText;

@property (nonatomic, strong) NSString<Optional> *tail;

@end

// case Price =                  "Price"          // 价格
@protocol AIPriceModel

@end

@interface AIPriceModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *price;

@property (nonatomic, strong) NSString<Optional> *currency;

@property (nonatomic, strong) NSString<Optional> *billingMode;

@property (nonatomic, strong) NSString<Optional> *totalPriceDesc;

@end




@protocol AIPriceViewModel

@end

@interface AIPriceViewModel : JSONModel



@property (nonatomic, strong) AIPriceModel<Optional> *defaultPrice;

@property (nonatomic, assign) NSInteger defaultNumber;

@property (nonatomic, assign) NSInteger maxNumber;

@property (nonatomic, assign) NSInteger minNumber;

@property (nonatomic, strong) NSString<Optional> *finalPrice;

@property (nonatomic, strong) NSString<Optional> *totalPriceDesc;


@end
// case Calendar =               "Calendar"       // 日历
@protocol AICanlendarViewModel

@end

@interface AICanlendarViewModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *identifier;

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSString<Optional> *calendar; // default 0 : 月日

@end
// case SingalOption =           "SingalOption"   // 单选

@protocol AIOptionModel

@end

@interface AIOptionModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *identifier;

@property (nonatomic, strong) NSString<Optional> *desc;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString<Optional> *displayColor;

@end


@protocol AIServiceTypesModel

@end

@interface AIServiceTypesModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSArray<Optional> *typeOptions;

@property (nonatomic, strong) NSDictionary<Optional> *params;

@end

// case TextDetail =             "TextDetail"     // 描述信息
@protocol AIDetailTextModel
@end

@interface AIDetailTextModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSString<Optional> *content;

@end



// case ComplexLabel =           "ComplexLabel"   // 复合标签组

@protocol AIComplexLabelModel

@end

@interface AIComplexLabelModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *atitle;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger paramKey;
@property (nonatomic, strong) NSString<Optional> *adesc;
@property (nonatomic, strong) NSArray<Optional> *sublabels;
@property (nonatomic, assign) BOOL isSelected;


@end


@protocol AIComplexLabelsModel

@end

@interface AIComplexLabelsModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSArray<Optional> *selected_label_id;
@property (nonatomic, strong) NSArray<Optional> *labels;
// params
@property (nonatomic, strong) NSArray<Optional> *paramSource;
@property (nonatomic, strong) NSArray<Optional> *paramKey;

// fadeBack







@end

// case TitleLabel =             "TitleLabels"    // 彩色标签
@protocol AIServiceCoverageModel

@end

@interface AIServiceCoverageModel : JSONModel


@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSArray<Optional> *options;

@property (nonatomic, strong) NSDictionary<Optional> *params;

@property (nonatomic, assign) NSInteger modelType;

@end
// case Picker =                 "Picker"         // pick选择
@protocol AIPickerViewModel

@end

@interface AIPickerViewModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *identifierPick;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *tailUnit;
@property (nonatomic, strong) NSArray<Optional, AIOptionModel> *options;
@property (nonatomic, strong) id defaultValue; // 当类型是数字为NSNumber对象，其他为字符串


@property (nonatomic, assign) BOOL isNumberType;
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, assign) NSInteger minNumber;

@end





// case Services =               "Services"       // 切换服务商

@protocol AIServiceProviderModel



@end

@interface AIServiceProviderModel : JSONModel

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, strong) NSString<Optional> *name;

@property (nonatomic, strong) NSString<Optional> *icon;

@property (nonatomic, assign) BOOL isSelected;

@end


@protocol AIServiceProviderViewModel

@end

@interface AIServiceProviderViewModel : JSONModel

@property (nonatomic, strong) NSArray<Optional> *providers;

@end

