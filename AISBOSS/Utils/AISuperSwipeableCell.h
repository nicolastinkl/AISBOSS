//
//  AISuperSwipeableCell.h
//  AISuperSwipeableCell.h
//
//  Created by tinkl on 1/11/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AISuperSwipeableCellDelegate <NSObject>

- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
- (void)cellDidAimationFrame:(CGFloat) position cell:(UITableViewCell *)cell;
@end

@interface AISuperSwipeableCell : UITableViewCell

@property (nonatomic, weak) id <AISuperSwipeableCellDelegate> delegate;

- (void)openCell;
- (void)closeCell;

@end
