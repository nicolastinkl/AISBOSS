//
//  AIWeiboData.m
//  AITrans
//
//  Created by 王坜 on 15/8/3.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIWeiboData.h"

@implementation AIWeiboData

+ (instancetype)instance
{
    static AIWeiboData *gInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        gInstance = [[AIWeiboData alloc] init];
    });
    
    return gInstance;
}


@end
