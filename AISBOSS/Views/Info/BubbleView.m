//
//  BubbleView.m
//  DataStructure
//
//  Created by 王坜 on 15/7/9.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//

#import "BubbleView.h"
#import "CurveModel.h"
#import "AIViews.h"


#define kDeleteButtonWidth  40

@interface BubbleView ()
{
    UIButton *_deleteButton;
}

@property (nonatomic, strong) CurveModel *model;

@end

@implementation BubbleView

- (id)initWithFrame:(CGRect)frame model:(CurveModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.model = model;
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(handleNotification:) name:kBubbleShouldShowDeleteButtonNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(handleNotification:) name:kBubbleShouldHideDeleteButtonNotification object:nil];
        
        
        [self makeBubble];
    }
    
    return self;
}

-(void) removeAllObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBubbleShouldShowDeleteButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBubbleShouldHideDeleteButtonNotification object:nil];
    
}


- (void)dealloc
{
    [self removeAllNotifications];
}


- (void)handleNotification:(NSNotification *)notificaiton
{
    if ([notificaiton.name isEqualToString:kBubbleShouldShowDeleteButtonNotification]) { // 展示
        _deleteButton = [self deleteButtonWithSuperWidth:self.model.displayWidth];
        [self addSubview:_deleteButton];
    }
    else if ([notificaiton.name isEqualToString:kBubbleShouldHideDeleteButtonNotification]) // 隐藏
    {
        if (_deleteButton) {
            [_deleteButton removeFromSuperview];
            _deleteButton = nil;
        }
    }
    
}

- (void)shouldDisppear;
{
    [self deleteAction:nil];
}

#pragma mark - Add Bubble

- (void)makeBottomBorder
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = self.bounds;
    bottomBorder.borderColor = self.model.displayColor.CGColor;
    bottomBorder.borderWidth = self.model.strokeWidth;
    bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
    bottomBorder.cornerRadius = self.model.displayWidth/2;
    
    [self.layer addSublayer:bottomBorder];
}

- (void)makeFillView
{
    UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.model.displayWidth-10, self.model.displayWidth-10)];
    fillView.backgroundColor = self.model.displayColor;
    fillView.layer.cornerRadius = (self.model.displayWidth-10)/2;
    fillView.center = CGPointMake(self.model.displayWidth/2, self.model.displayWidth/2);
    
    [self addSubview:fillView];
}

- (void)makeLabel
{
    UILabel *label = [AIViews wrapLabelWithFrame:CGRectMake(10, (self.model.displayWidth-40)/2, self.model.displayWidth-20, 40) text:self.model.displayTitle fontSize:16 color:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.center = CGPointMake(self.model.displayWidth/2, self.model.displayWidth/2);
    [self addSubview:label];
}

- (void)makeBackgroundView
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.layer.cornerRadius = self.model.displayWidth/2;
    view.clipsToBounds = YES;
    [self addSubview:view];
    
    UIImage *bgImage = [UIImage imageNamed:@"search_background"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], self.frame)];
    [view addSubview:bgImageView];
    
}

- (void)makeBubble
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.model.displayWidth/2;
    self.center = CGPointMake(self.model.endX, self.model.endY);
    
    
    // add bg
    [self makeBackgroundView];
    
    // add border
    [self makeBottomBorder];
    
    // add fillview
    [self makeFillView];
    
    // add label
    if (self.model.displayTitle) {
        [self makeLabel];
    }
    
    // 添加动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = self.model.animationDuration;
    //animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    //animationGroup.repeatCount = HUGE_VALF;//HUGE_VALF;

    CABasicAnimation *scaleAnimation = [self scaleAnimationWithModel:self.model reverse:NO];
    CAKeyframeAnimation *pathAnimation = [self pathAnimationWithModel:self.model reverse:NO];
    
    [animationGroup setAnimations:[NSArray arrayWithObjects:pathAnimation, scaleAnimation, nil]];
    [self.layer addAnimation:animationGroup forKey:@"animationGroup"];

}

#pragma mark - Path Animatin

#pragma mark - 圆形视图

- (CAKeyframeAnimation *)pathAnimationWithModel:(CurveModel *)model reverse:(BOOL)reverse
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = model.animationDuration;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    CGPoint startPoint = reverse ? CGPointMake(model.endX, model.endY) : CGPointMake(model.startX, model.startY);
    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
    CGPoint endPoint = reverse ? CGPointMake(model.startX, model.startY) : CGPointMake(model.endX, model.endY);
    CGPoint control1 = reverse ? CGPointMake(model.control2X, model.control2Y) : CGPointMake(model.control1X, model.control1Y);
    CGPoint control2 = reverse ? CGPointMake(model.control1X, model.control1Y) : CGPointMake(model.control2X, model.control2Y);
    
    CGPathAddCurveToPoint(curvedPath, NULL,control1.x,
                          control1.y,
                          control2.x,
                          control2.y,
                          endPoint.x,
                          endPoint.y);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    return pathAnimation;
}


#pragma mark - Scale Animation

- (CABasicAnimation *)scaleAnimationWithModel:(CurveModel *)model reverse:(BOOL)reverse
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:reverse?1.0f:0.3f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:reverse?0.3f:1.0f];
    scaleAnimation.duration = model.animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    return scaleAnimation;
}

#pragma mark - 删除按钮

- (CGPoint)calcuateDeleteButtonCenterWithWidth:(CGFloat)width
{
    CGFloat len1 = sqrt(2)*width;
    CGFloat len2 = len1/2 - width/2;
    
    CGFloat len3 = sqrt(len2*len2/2);
    
    CGFloat centerX = width - len3;
    CGFloat centerY = len3;
    
    return CGPointMake(centerX, centerY);
}


- (void)removeAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBubbleShouldShowDeleteButtonNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBubbleShouldHideDeleteButtonNotification object:nil];
}

- (void)addBubbleDisappearAnimation
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = self.model.animationDuration;
    //animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    //animationGroup.repeatCount = HUGE_VALF;//HUGE_VALF;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    CABasicAnimation *scaleAnimation = [self scaleAnimationWithModel:self.model reverse:YES];
    CAKeyframeAnimation *pathAnimation = [self pathAnimationWithModel:self.model reverse:YES];
    
    [animationGroup setAnimations:[NSArray arrayWithObjects:pathAnimation, scaleAnimation, nil]];
    [self.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void)addLineDisappearAnimation
{
    if (!self.linkedLineLayer) {
        return;
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.model.animationDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [self.linkedLineLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    
}

- (void)deleteAction:(UIButton *)button
{
    // delete notification
    [self removeAllNotifications];
    
    // 添加动画组
    [self addBubbleDisappearAnimation];
    [self addLineDisappearAnimation];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.delegate respondsToSelector:@selector(bubbleViewDidDeleteBubble:)]) {
        [self.delegate bubbleViewDidDeleteBubble:self.model];
    }
    
    if (self.linkedLineLayer) {
        [self.linkedLineLayer removeFromSuperlayer];
    }
    
    if (self.linkedPointView) {
        [self.linkedPointView removeFromSuperview];
    }
    
    [self removeFromSuperview];
}

- (UIButton *)deleteButtonWithSuperWidth:(CGFloat)width
{
    UIButton *deleteButton = [AIViews baseButtonWithFrame:CGRectMake(0, 0, kDeleteButtonWidth, kDeleteButtonWidth) normalTitle:nil];
    deleteButton.center = [self calcuateDeleteButtonCenterWithWidth:width];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.backgroundColor = [UIColor clearColor];
    
    // add delete image
    UIImage *image = [UIImage imageNamed:@"sd_edit_close"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = CGPointMake(kDeleteButtonWidth/2, kDeleteButtonWidth/2);
    imageView.userInteractionEnabled = NO;
    [deleteButton addSubview:imageView];
    
    return deleteButton;
}

@end
