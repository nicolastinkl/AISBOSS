//
//  SwipeableCell.m
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import "SwipeableCell.h"

@interface SwipeableCell() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *menuView;
@property (nonatomic, weak) IBOutlet UIView *myContentView;


@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@end

static CGFloat const kBounceValue = 20.0f;

@implementation SwipeableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
    
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

- (void)openCell
{
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}
 
- (CGFloat)buttonTotalWidth
{
    return 200.0;//CGRectGetWidth(self.frame) - CGRectGetMinX(self.button2.frame);
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;

        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
//            NSLog(@"deltaX  : %f",deltaX);
            
            if (deltaX > 0) {
                // open
                [self.delegate cellDidAimationFrame:(deltaX + 20) cell:self];
            }else{
                //close
                [self.delegate cellDidAimationFrame:((220.0 + deltaX) + 20) cell:self];
            }
            
            
            //NSLog(@"%f",(fabs(currentPoint.y) / fabs(currentPoint.x)));
            if ((fabs(currentPoint.y) / fabs(currentPoint.x)) < 0.5){
                
                BOOL panningLeft = NO;
                if (currentPoint.x < self.panStartPoint.x) {  //1
                    panningLeft = YES;
                }
                
                if (self.startingRightLayoutConstraintConstant == 0) { //2
                    //The cell was closed and is now opening
                    if (!panningLeft) {
                        CGFloat constant = MAX(-deltaX, 0); //3
                        if (constant == 0) { //4
                            [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //5
                        } else {
                            self.contentViewRightConstraint.constant = constant; //6
                        }
                    } else {
                        CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //7
                        
                        if (constant == [self buttonTotalWidth]) { //8
                            [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //9
                        } else {
                            self.contentViewRightConstraint.constant = constant; //10
                        }
                    }
                }else {
                    //The cell was at least partially open.
                    CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //11
                    if (!panningLeft) {
                        CGFloat constant = MAX(adjustment, 0); //12
                        if (constant == 0) { //13
                            [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //14
                        } else {
                            self.contentViewRightConstraint.constant = constant; //15
                        }
                    } else {
                        CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //16
                        
                        if (constant == [self buttonTotalWidth]) { //17
                            [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //18
                        } else {
                            self.contentViewRightConstraint.constant = constant;//19
                        }
                    }
                }
                
                self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //20
            }
                
           // NSLog(@"deltaX: %f   y:%f",deltaX,(currentPoint.y - self.panStartPoint.y));
            
            
        }
            break;

        case UIGestureRecognizerStateEnded:
            
            [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            /*
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //We were opening
                CGFloat halfOfButtonOne =  CGRectGetWidth(self.menuView.frame) / 2; //2
                
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
                
            } else {
                //We were closing
                CGFloat buttonOnePlusHalfOfButton2 =  CGRectGetWidth(self.menuView.frame) / 2 ; //4
                
                
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }*/
            break;

        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //We were open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion;
{
  
    [self layoutIfNeeded];

/*
 float duration = 0;
 if (animated) {
 duration = 0.1;
 }
 
 [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
 [self layoutIfNeeded];
 } completion:completion];

 */
}


- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate cellDidClose:self];
    }
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    
    self.contentViewRightConstraint.constant = 0;
    self.contentViewLeftConstraint.constant = 0;
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
    } completion:^(BOOL finished) {
        [self.delegate cellDidCloseCell:self];
    }];
    /*
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            
        }];
    }];*/
}


- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate cellDidOpen:self];
    }
    
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{  
    return YES;
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //https://github.com/alikaragoz/MCSwipeTableViewCell/blob/master/MCSwipeTableViewCell/MCSwipeTableViewCell.m#L329
    if (gestureRecognizer == self.panRecognizer) {
        CGPoint point = [self.panRecognizer velocityInView:self];
        if (fabs(point.x) > fabs(point.y) ) {
            return YES;
        }
    }
    return NO;
}


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
//        NSLog(@"横向手势 %f %f",fabs(point.y) , fabs(point.x));
//        if ((fabs(point.y) / fabs(point.x)) < 1) { // 判断角度 tan(45),这里需要通过正负来判断手势方向
//            
//            return YES;
//        }
//    }
//    return [super gestureRecognizerShouldBegin:gestureRecognizer];
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[self.myContentView class] ]) {
//        return NO;
//    }
//    return YES;
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]){
//        return NO;
//    }
//    
//    return YES;
//}



@end
