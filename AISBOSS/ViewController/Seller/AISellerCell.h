//
//  AISellerCell.h
//  AITrans
//
//  Created by 王坜 on 15/7/22.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SellerCellColorType) {
    
    SellerCellColorTypeNormal = 1,
    SellerCellColorTypeGreen,
    SellerCellColorTypeBrown,
    
};

typedef NS_ENUM(NSInteger, SellerButtonType) {
    SellerButtonTypeNone = 0,
    SellerButtonTypePhone,
    SellerButtonTypeOpposite,
    SellerButtonTypeLocate,
    SellerButtonTypeCapture,
};

@class AIOrderPreModel;
@class AIProgressModel;
@class AISellingProgressBar;

@interface AISellerCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *sellerIcon;

@property (nonatomic, readonly) UILabel *sellerName;

@property (nonatomic, readonly) UILabel *messageNum;

@property (nonatomic, readonly) UILabel *price;


@property (nonatomic, readonly) UILabel *timestamp;


@property (nonatomic, readonly) UILabel *location;

@property (nonatomic, readonly) UIButton *actionButton;

@property (nonatomic, readonly) AISellingProgressBar *progressBar;



+ (CGFloat)expandHeight;

+ (CGFloat)unexpandHeight;

// 1
- (void)setProgressBarModel:(AIProgressModel *)model;


// 2
- (void)setButtonType:(SellerButtonType)buttonType;

// 3
- (void)setBackgroundColorType:(SellerCellColorType)colorType;

// 4
- (void)setImages:(NSArray *)images;

// 5
- (void)setMessageNumber:(NSString *)number;

// 6

- (void)setServiceCategory:(AIOrderPreModel *)model;

@end
