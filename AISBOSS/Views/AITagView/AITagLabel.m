//
//  AITagLabel.m
//  multiLabelDemo
//
//  Created by admin on 1/21/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

#import "AITagLabel.h"

@interface AITagLabel ()

@end

@implementation AITagLabel

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (CGFloat)spaceBetweenImageAndTitle {
    return 5;
}

- (void)setup {
    [self setImage:[UIImage imageNamed:@"Type_Off"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"Type_On"] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    //http://stackoverflow.com/questions/4564621/aligning-text-and-image-on-uibutton-with-imageedgeinsets-and-titleedgeinsets
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.spaceBetweenImageAndTitle);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, self.spaceBetweenImageAndTitle, 0, 0);
}

@end
