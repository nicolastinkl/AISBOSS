//
//  AIServiceCoverage.m
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceCoverage.h"

@implementation AIServiceCoverage

- (instancetype)initWithFrame:(CGRect)frame labels:(NSArray *)labels
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeTitle];
        [self makeTags];
    }
    
    return self;
}


#pragma mark - 构造title

- (void)makeTitle
{
    
}

#pragma mark - 构造标签

- (void)makeTags
{
    
}


@end
