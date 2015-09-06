//
//  SwipeableCell.h
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>
- (void)buttonActionForItemText:(NSString *)itemText; 
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
- (void)cellDidAimationFrame:(CGFloat) position cell:(UITableViewCell *)cell;

- (void)cellDidCloseCell:(UITableViewCell *)cell;

@end


@interface SwipeableCell : UITableViewCell
 @property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
- (void)openCell;

@end
