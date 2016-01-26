//
//  AIProposalServiceParser.h
//  AIVeris
//
//  Created by 王坜 on 16/1/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIProposalServiceParser : NSObject

@property (nonatomic, strong) NSMutableArray *displayModels;

- (id)initWithServiceParams:(NSArray *)params relatedParams:(NSArray *)relatedParams displayParams:(NSArray *)displayParams;

@end
