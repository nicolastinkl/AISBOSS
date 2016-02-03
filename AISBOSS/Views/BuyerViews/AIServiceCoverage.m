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


@property (nonatomic, strong) AIServiceCoverageModel *coverageModel;

@property (nonatomic, strong) NSMutableArray *selectedLabels;

@property (nonatomic, strong) NSMutableArray *defaultLabels;

@end

@implementation AIServiceCoverage


- (instancetype)initWithFrame:(CGRect)frame model:(AIServiceCoverageModel *)model {
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
- (void)makeProperties {
    _titleMargin = [AITools displaySizeFrom1080DesignSize:51];
    _labelMargin = [AITools displaySizeFrom1080DesignSize:30];
    _titleFontSize = [AITools displaySizeFrom1080DesignSize:42];

    self.selectedLabels = [[NSMutableArray alloc] init];
    self.defaultLabels =  [[NSMutableArray alloc] init];
}

#pragma mark - 构造title

- (void)makeTitle {
    if (![self.coverageModel.title isKindOfClass:[NSString class]] | !self.coverageModel.title.length) return;

    UIFont *font = [AITools myriadSemiCondensedWithSize:_titleFontSize];
    CGSize size = [_coverageModel.title sizeWithFont:font forWidth:300];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), size.height);
    _titleLabel = [AIViews normalLabelWithFrame:frame text:_coverageModel.title fontSize:_titleFontSize color:Color_HighWhite];
    _titleLabel.font = font;
    [self addSubview:_titleLabel];
}

#pragma mark - 构造标签


- (UIColor *)makeColorsAtIndex:(NSInteger)index {
    NSArray *colors = @[[AITools colorWithHexString:@"1c789f"],
                        [AITools colorWithHexString:@"7b3990"],
                        [AITools colorWithHexString:@"619505"],
                        [AITools colorWithHexString:@"f79a00"],
                        [AITools colorWithHexString:@"d05126"],
                        [AITools colorWithHexString:@"b32b1d"]];

    UIColor *color = [colors objectAtIndex:index % 6];

    return color;
}

- (void)makeTags {
    if (self.coverageModel.options.count == 0) return;

    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(_titleLabel.frame) + _titleMargin;
    CGFloat height = [AITools displaySizeFrom1080DesignSize:67];

    for (NSInteger i = 0; i < self.coverageModel.options.count; i++) {
        AIOptionModel *model = [self.coverageModel.options objectAtIndex:i];

        CGRect frame = CGRectMake(x, y, 100, height);
        NSString *title = model.desc;
        AIServiceLabel *label = [[AIServiceLabel alloc] initWithFrame:frame title:title type:AIServiceLabelTypeSelection isSelected:model.isSelected];
        label.delegate = self;
        label.backgroundColor = [self makeColorsAtIndex:i];
        label.selectionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Coverage%ld", i]];

        [self addSubview:label];

        if (model.isSelected) {
            [_defaultLabels addObject:model];
            [self.selectedLabels addObject:model];
        }
        
        if (CGRectGetMaxX(label.frame) > CGRectGetWidth(self.frame)) {
            x = 0;
            y += _labelMargin + height;
            frame = CGRectMake(x, y, CGRectGetWidth(label.frame), height);
            label.frame = frame;
        }

        x += _labelMargin + CGRectGetWidth(label.frame);
    }
    
    self.selectedLabels = [[NSMutableArray alloc] initWithArray:_defaultLabels];

    CGRect frame = self.frame;
    frame.size.height = y + height;

    self.frame = frame;
}

#pragma mark - AIServiceLabelDelegate


- (NSArray *)productParamsList
{
    NSString *source = [_coverageModel.displayParams objectForKey:@"param_source"];
    
    if (![source isEqualToString:@"product"]) {
        return nil;
    }
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSString *product_id = nil;
    NSString *role_id = [_coverageModel.displayParams objectForKey:@"param_source_id"];
    
    for (AIOptionModel *model in _selectedLabels) {
        product_id = model.identifier;
        NSString *product_name = model.desc;
        NSDictionary *productParams = @{@"product_name" : product_name?:@"",@"product_id" : product_id?:@"", @"service_id":_coverageModel.service_id_save?:@"", @"role_id":role_id?: @""};
        [params addObject:productParams];
    }

    return params;
}


- (NSArray *)serviceParamsList
{
    NSString *source = [_coverageModel.displayParams objectForKey:@"param_source"];
    
    if ([source isEqualToString:@"product"]) {
        return nil;
    }
    
    NSNumber *param_key = [_coverageModel.displayParams objectForKey:@"param_key"];
    NSString *role_id = [_coverageModel.displayParams objectForKey:@"param_source_id"];
    BOOL isProduct = [source isEqualToString:@"product"];
    NSMutableArray *params = [[NSMutableArray alloc] init];

    
    NSMutableArray *paramValues = [[NSMutableArray alloc] init];
    NSMutableArray *paramsIDs = [[NSMutableArray alloc] init];
    NSString *productID = nil;
    
    for (AIOptionModel *model in _selectedLabels) {
        productID = isProduct ? model.identifier : @"";
        [paramsIDs addObject:model.identifier ?: @""];
        [paramValues addObject:model.desc ?: @""];
    }
    
    
    NSDictionary *serviceParams = @{@"source":source?:@"" ,@"role_id":role_id ?: @"", @"service_id":_coverageModel.service_id_save ?: @"", @"product_id": productID ?: @"", @"param_key": param_key ?: @"", @"param_value":paramValues, @"param_value_id":paramsIDs};
    [params addObject:serviceParams];
    

    return params;
}

- (void)insertModel:(AIOptionModel *)model {
    for (AIOptionModel *m in _selectedLabels) {
        if (model == m) {
            return;
        }
    }

    [_selectedLabels addObject:model];
}

- (void)serviceLabel:(AIServiceLabel *)serviceLabel isSelected:(BOOL)selected {
    for (AIOptionModel *model in _coverageModel.options) {
        if ([model.desc isEqualToString:serviceLabel.labelTitle]) {
            
            if (selected) {
                [self insertModel:model];
            }
            else if ([_selectedLabels containsObject:model])
            {
                [_selectedLabels removeObject:model];
            }
            
            break;
        }
    }
}

@end
