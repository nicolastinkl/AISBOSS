//
//  AISuperSwipeableCell.h
//  AISuperSwipeableCell
//
//  Created by tinkl on 1/11/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "AISuperSwipeableCell.h"

@interface AISuperSwipeableCell() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *buttonView;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *maskLabel;
@property (nonatomic, weak) IBOutlet UIView *cornerFixView; //圆角修复view

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonViewWidthConstraint;

@end

static CGFloat const kBounceValue = 20.0f;
static CGFloat const kOffsetValue = 21.0f;

static CGFloat const kButtonWidthValue = 52.0f;

@implementation AISuperSwipeableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    self.canDelete = NO;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}

- (void)setCanDelete:(BOOL)canDelete {
    _canDelete = canDelete;
    self.panRecognizer.enabled = canDelete;
}

- (void)openCell
{
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)closeCell
{
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:YES];
}
  
- (CGFloat)buttonTotalWidth
{
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.buttonView.frame) - kOffsetValue + 4;
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
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (deltaX > 0) {
                // open
                [self.delegate cellDidAimationFrame:(deltaX + 20) cell:self];
                 
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
            
            
            CGFloat newWidth = -self.contentViewLeftConstraint.constant;
            
            self.buttonViewWidthConstraint.constant = newWidth;
            
            if (newWidth > 5) {
                self.cornerFixView.hidden = false;
                [self.delegate cellWillOpen:self];
            }else{
                self.cornerFixView.hidden = true;
            }
            
            /**
             //Change.
             self.buttonView.hidden = false;
             [self.delegate cellDidOpen:self];
             */
        }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //We were opening
                CGFloat halfOfButtonOne = CGRectGetWidth(self.buttonView.frame) / 2 - kOffsetValue/2; //2
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
                
            } else {
                //We were closing CGRectGetWidth(self.button1.frame) ;//+
                CGFloat buttonOnePlusHalfOfButton2 =  CGRectGetWidth(self.buttonView.frame)  - kOffsetValue/2;//(CGRectGetWidth(self.button1.frame) / 2); //4
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
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
    float duration = 0;
    if (animated) { 
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
        completion(YES);
    }];
    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self layoutIfNeeded];
//    } completion:completion];
}


- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        //self.buttonView.hidden = true;
        self.buttonViewWidthConstraint.constant = 0;
        self.cornerFixView.hidden = true;
        [self.delegate cellDidClose:self];
    }
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}


- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        //Change.
        //self.buttonView.hidden = false;

        self.buttonViewWidthConstraint.constant = kButtonWidthValue;
        self.cornerFixView.hidden = true;
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


@end
