//
//  AIOrderManagementModels.h
//  AIVeris
//
//  Created by 王坜 on 16/3/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"



@interface AIOrderManagementModels : JSONModel

@end


#pragma mark - customer


@protocol customer @end

@interface customer : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *customer_id;

@property (nonatomic, strong) NSString<Optional> *user_portrait_icon;

@property (nonatomic, strong) NSString<Optional> *user_name;

@property (nonatomic, strong) NSString<Optional> *user_phone;

@property (nonatomic, strong) NSNumber<Optional> *user_id;

@property (nonatomic, strong) NSNumber<Optional> *user_message_count;


@end


/*

#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end

#pragma mark - 
@protocol customer @end

@interface customer : JSONModel


@end

#pragma mark - 
@protocol customer @end

@interface customer : JSONModel


@end


#pragma mark - 
@protocol customer @end

@interface customer : JSONModel


@end


#pragma mark - 
@protocol customer @end

@interface customer : JSONModel


@end
#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end
#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end

#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end

#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end

#pragma mark -
@protocol customer @end

@interface customer : JSONModel


@end

*/