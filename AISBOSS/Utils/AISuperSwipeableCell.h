//
//  SwipeableCell.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AISuperSwipeableCellDelegate <NSObject>
- (void)buttonOneAction;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface AISuperSwipeableCell : UITableViewCell

@property (nonatomic, weak) id <AISuperSwipeableCellDelegate> delegate;

- (void)openCell;

@end
