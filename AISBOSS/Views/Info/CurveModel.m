//
//  CurveModel.m
//  DataStructure
//
//  Created by 王坜 on 15/7/14.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import "CurveModel.h"

@implementation CurveModel

- (id)init
{
    self = [super init];
    if (self) {
        self.strokeWidth = 1.0f;
        self.animationDuration = 1.0f;
    }
    
    return self;
}


@end