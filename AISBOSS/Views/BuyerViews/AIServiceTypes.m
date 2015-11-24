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


@interface AIServiceTypes ()
{
    CGFloat _radioSize;
    CGFloat _radioMargin;
    CGFloat _fontSize;
    CGFloat _topMargin;
    
    //
    UPLabel *_titleLabel;
    
    
}

@property (nonatomic, strong) AIMusicServiceTypesModel *serviceTypesModel;

@end

@implementation AIServiceTypes

- (id)initWithFrame:(CGRect)frame model:(AIMusicServiceTypesModel *)model
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
    _radioSize = [AITools displaySizeFrom1080DesignSize:46];
    _radioMargin = [AITools displaySizeFrom1080DesignSize:42];
    _fontSize = [AITools displaySizeFrom1080DesignSize:42];
    _topMargin = [AITools displaySizeFrom1080DesignSize:42];
}

#pragma mark - Title

- (void)makeTitle
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _fontSize);
    _titleLabel = [AIViews normalLabelWithFrame:frame text:self.serviceTypesModel.title fontSize:_fontSize color:[UIColor whiteColor]];
    _titleLabel.font = [AITools myriadSemiCondensedWithSize:_fontSize];
    [self addSubview:_titleLabel];
}

#pragma mark - Radios

- (void)makeRadios
{
    CGFloat y = CGRectGetMaxY(_titleLabel.frame) + _topMargin;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat margin = _radioSize + _radioMargin;
    
    for (NSInteger i = 0; i < self.serviceTypesModel.types.count; i++) {
        
        CGRect frame = CGRectMake(0, y, width, _radioSize);
        UIView *radioView = [[UIView alloc] initWithFrame:frame];
        radioView.tag = i;
        [self addSubview:radioView];
        
        //
        NSString *imageName = self.serviceTypesModel.defaultTypeIndex ? @"Type_On" : @"Type_Off";
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, _radioSize, _radioSize);
        
        [radioView addSubview:imageView];
        
        //
        
        CGFloat x = _radioSize + _radioMargin;
        CGFloat strWidth = width - x;
        CGRect strFrame = CGRectMake(x, 0, strWidth, _radioSize);
        NSString *radio = [self.serviceTypesModel.types objectAtIndex:i];
        
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
    
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndex:)]) {
        [self.delegate didSelectedAtIndex:view.tag];
    }
    
}



@end
