//
//  AIFakeUser.m
//  AIVeris
//
//  Created by 王坜 on 16/1/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIFakeUser.h"
#import "AITools.h"


@interface AIFakeUser ()

@property (nonatomic, strong) UserSelectedAction selectedAction;

@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation AIFakeUser

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon selectedAction:(UserSelectedAction) action
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.selectedAction = action;
        [self makeGesture];
        [self makeImageViewWithImage:icon];
    }
    
    return self;
}

- (void)makeGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)makeImageViewWithImage:(UIImage *)image
{
    CGSize size = self.bounds.size;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    //
    CGFloat offset = sqrt(size.width * size.width / 8);
    UIImage *selectedIM = [UIImage imageNamed:@"FakeLogin_Checked"];
    _checkImageView = [[UIImageView alloc] initWithImage:selectedIM];
    CGSize sSize = [AITools imageDisplaySizeFrom1080DesignSize:selectedIM.size];
    _checkImageView.frame = CGRectMake(0, 0, sSize.width, sSize.height);
    _checkImageView.center = CGPointMake(size.width / 2 + offset, size.width / 2 - offset);
    _checkImageView.hidden = YES;
    [self addSubview:_checkImageView];
}



- (void)tapAction
{
    if (self.checkImageView.hidden) {
        self.checkImageView.hidden = NO;
    }

    if (self.selectedAction) {
        self.selectedAction(self);
    }
}


- (void)setSelected:(BOOL)selected
{
    self.checkImageView.hidden = !selected;
}

@end
