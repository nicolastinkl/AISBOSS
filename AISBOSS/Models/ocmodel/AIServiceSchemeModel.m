//
//  AIServiceSchemeModel.m
//  AIVeris
//
//  Created by tinkl on 16/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceSchemeModel.h"

@implementation SchemeParamList

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation ServiceList

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end

@implementation CatalogList

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation AIServiceSchemeModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
