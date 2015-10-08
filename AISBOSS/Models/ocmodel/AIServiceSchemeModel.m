//
//  AIServiceSchemeModel.m
//  AIVeris
//
//  Created by tinkl on 16/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceSchemeModel.h"

@implementation SchemeParamList

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}
//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation ServiceProvider


//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}


@end

@implementation ServicePrice

//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}

@end

@implementation ServiceList

- (void)setService_rating:(NSNumber<Optional> *)service_rating
{
    _service_rating = [NSNumber numberWithFloat:service_rating.floatValue / 5];
}

//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}

@end

@implementation Catalog
//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}


@end

@implementation AIServiceSchemeModel

//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}


@end


//+(BOOL)propertyIsOptional:(NSString*)propertyName
//{
//    return YES;
//}




