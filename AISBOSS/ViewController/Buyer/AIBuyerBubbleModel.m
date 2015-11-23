//
//  AIBuyerBubbleModel.m
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIBuyerBubbleModel.h"

@implementation AIBuyerBubbleProportModel
-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}
//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation AIBuyerBubbleModel

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}
//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation AIProposalPopListModel


-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}
//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation AIProposalListChildModel

@end

@implementation AIProposalListContentModel

@end


@implementation AIProposalListContentChildModel
@end

@implementation AIProposalListChildServiceProviderModel
@end

@implementation AIProposalHopeModel

@end

@implementation AIProposalHopeAudioTextModel
@end

@implementation AIProposalNotesModel

@end