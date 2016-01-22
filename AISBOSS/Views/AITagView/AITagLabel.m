//
//  AITagLabel.m
//  multiLabelDemo
//
//  Created by admin on 1/21/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

#import "AITagLabel.h"

@implementation AITagLabel

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateColor];
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    _normalBackgroundColor = normalBackgroundColor;
    [self updateColor];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self updateColor];
}

- (void)updateColor {
    self.backgroundColor = self.highlighted ? self.highlightedBackgroundColor : self.normalBackgroundColor;
}

@end
