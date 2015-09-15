//
//  AICardView.m
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AICardView.h"
#import "AICardCell.h"
#import "AITools.h"

#define kMarginOffset 4

@interface AICardView ()
{
    NSMutableArray *_cellHeights;
}

@property (nonatomic, strong) NSArray *cardsDatas;

@end

@implementation AICardView
@synthesize heights = _cellHeights;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame cards:(NSArray *)cards
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cardsDatas = cards;
        _cellHeights = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < cards.count; i++) {
            NSDictionary *cellData = [cards objectAtIndex:i];
            AICardCell *cell = nil;
            AICardPosition position = AICardPositionAtMiddle;
            
            if (i == 0 && cards.count > 1) {
                position = AICardPositionAtFirst;
            }
            else if (i == cards.count - 1 && cards.count > 1)
            {
                position = AICardPositionAtLast;
            }
            else if (i == 0 && cards.count == 1)
            {
                position = AICardPositionNormal;
            }
            
            cell = [[AICardCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0) content:cellData position:position];
            
            [self addSubview:cell];
        }
        
        [self resetFrames];
        
    }
    
    return self;
}

- (void)resetFrames
{
    NSArray *cells = self.subviews;
    
    CGFloat y = kMarginOffset;
    CGFloat height = 0;
    
    for (AICardCell *cell in cells) {
        CGRect frame = cell.frame;
        frame.origin.y = y;
        height = CGRectGetHeight(cell.frame);
        frame.size.height = height;
        
        cell.frame = frame;
        y += height;
        
        NSNumber *num = [NSNumber numberWithFloat:height];
        [_cellHeights addObject:num];
    }
    
    CGRect newFrame = self.frame;
    newFrame.size.height = y + kMarginOffset;
    self.frame = newFrame;
}



@end
