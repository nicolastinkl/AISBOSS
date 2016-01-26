//
//  AIServiceTypes.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceTypes.h"
#import "AITools.h"
#import "AIViews.h"

#define kRadioButtonTag   999


@interface AIServiceTypes ()
{
    CGFloat _radioSize;
    CGFloat _radioMargin;
    CGFloat _fontSize;
    CGFloat _topMargin;
    
    //
    UPLabel *_titleLabel;
    
    NSInteger _selectedIndex;
    NSInteger _lastIndex;
}

@property (nonatomic, strong) AIServiceTypesModel *serviceTypesModel;

@end

@implementation AIServiceTypes

- (id)initWithFrame:(CGRect)frame model:(AIServiceTypesModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.serviceTypesModel = model;
        [self makeProperties];
        [self makeTitle];
        [self makeRadios];
    }
    
    return self;
}



#pragma mark - 基本属性

- (void)makeProperties
{
    _selectedIndex = -1;
    _radioSize = [AITools displaySizeFrom1080DesignSize:46];
    _radioMargin = [AITools displaySizeFrom1080DesignSize:40];
    _fontSize = [AITools displaySizeFrom1080DesignSize:42];
    _topMargin = [AITools displaySizeFrom1080DesignSize:35];
}

#pragma mark - Title

- (void)makeTitle
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _fontSize);
    _titleLabel = [AIViews normalLabelWithFrame:frame text:_serviceTypesModel.title fontSize:_fontSize color:[UIColor whiteColor]];
    _titleLabel.font = [AITools myriadSemiCondensedWithSize:_fontSize];
    [self addSubview:_titleLabel];
}

#pragma mark - Radios

- (void)makeRadios
{
    CGFloat y = CGRectGetMaxY(_titleLabel.frame) + _topMargin;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat margin = _radioSize + _radioMargin - 2;
    
    for (NSInteger i = 0; i < _serviceTypesModel.typeOptions.count; i++) {
        
        AIOptionModel *optionModel = [_serviceTypesModel.typeOptions objectAtIndex:i];
        CGRect frame = CGRectMake(0, y, width, _radioSize);
        UIView *radioView = [[UIView alloc] initWithFrame:frame];
        radioView.tag = i;
        [self addSubview:radioView];
        
        //
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setImage:[UIImage imageNamed:@"Type_Off"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"Type_On"] forState:UIControlStateSelected];
        radioButton.frame = CGRectMake(0, 0, _radioSize, _radioSize);
        radioButton.userInteractionEnabled = NO;
        radioButton.tag = kRadioButtonTag;

        [radioView addSubview:radioButton];
        
        //
  
        if (optionModel.isSelected) {
            _selectedIndex = i;
            radioButton.selected = YES;
        }
        
        CGFloat x = _radioSize + _radioMargin;
        CGFloat strWidth = width - x;
        CGRect strFrame = CGRectMake(x, 0, strWidth, _radioSize);
        NSString *radio = optionModel.desc;
        
        UPLabel *label = [AIViews normalLabelWithFrame:strFrame text:radio fontSize:_fontSize color:[UIColor whiteColor]];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.userInteractionEnabled = NO;
        label.font = [AITools myriadLightSemiCondensedWithSize:_fontSize];
        [radioView addSubview:label];
        
        //
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [radioView addGestureRecognizer:gesture];
        
        
        //
        
        y += margin;
        
    }
    
    
    // reset frame
    y -= _radioMargin;
    
    CGRect frame = self.frame;
    frame.size.height = y;
    
    self.frame = frame;
    
}

#pragma mark - 设置单选

- (void)action:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    
    if (view.tag == _selectedIndex) {
        return;
    }
    
    UIButton *button = [view viewWithTag:kRadioButtonTag];
    button.selected = !button.selected;
    BOOL select = button.selected;
    
    /////
    
    if (_selectedIndex != view.tag) {
        UIView *preView = [self viewWithTag:_selectedIndex];
        UIButton *preButton = [preView viewWithTag:kRadioButtonTag];
        preButton.selected = !select;
        
    }
    
    _selectedIndex = view.tag;
    
    /*
    if ([self.delegate respondsToSelector:@selector(didSelectServiceTypeAtIndex:value:parentModel:)]) {
        [self.delegate didSelectServiceTypeAtIndex:_selectedIndex value:[_serviceTypesModel.param_value objectAtIndex:_selectedIndex] parentModel:_serviceTypesModel];
    }
    */
}



@end
