//
//  AICommentCell.h
//  AIVeris
//
//  Created by 王坜 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalModel.h"

@interface AICommentCell : UIView

@property (nonatomic, strong) UIImageView *defaultIcon;

- (id)initWithFrame:(CGRect)frame model:(AIProposalServiceDetail_Rating_Comment_listModel *)model;


@end
