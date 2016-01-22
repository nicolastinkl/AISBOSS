//
//  AITagLabel.h
//  multiLabelDemo
//
//  Created by admin on 1/21/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AITagLabel : UILabel

@property (nonatomic, strong) id tagNode;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end
