//
//  AIOpeningView.m
//  DataStructure
//
//  Created by 王坜 on 15/7/15.
//  Copyright (c) 2015年 Wang Li. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "AIOpeningView.h"

typedef NS_ENUM(NSInteger, AIMovementDirection) {
    AIMovementNone = 0,
    AIMovementUp = 1,
    AIMovementDown = 2,
    AIMovementLeft = 3,
    AIMovementRight = 4,
};



#define kAnimationDuration    0.5

#define kMaxMoveSize      80

@interface AIOpeningView ()
{
    MPMoviePlayerController *_moviewPlayer;
    UIImageView *_logoView;
    UIView *_maskView;
    UIView *_tapView;
    UIView *_backgroundView;
    
    NSInteger _flickerRepeatCount;
    
    CGPoint _firstTouchPoint;
    BOOL _didTouchedTapView;
    BOOL _didTapped;
    BOOL _canTap;
    
    CGPoint _originalLogoCenter;
    
    // 判断方向和位移量
    AIMovementDirection _currentDirection;
    CGFloat _currentMovement;
}



@end


@implementation AIOpeningView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

#pragma mark - Instance Function


+ (instancetype)instance
{
    static AIOpeningView *gInstance = NULL;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        gInstance = [[AIOpeningView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        gInstance.backgroundColor = [UIColor clearColor];
    });
    
    return gInstance;
}


#pragma mark - Delegate Event

- (void)doDelegateMethodWithDirection:(NSInteger)direction
{
    if ([self.delegate respondsToSelector:@selector(didOperatedWithDirection:)]) {
        [self.delegate didOperatedWithDirection:direction];
    }
}

#pragma mark - Main Function




- (void)show
{
    [self cleanAllProperties];
    [self.rootView addSubview:self];
    
    [self playMovie:@"start"];
    [self makeMaskView];
}

- (void)showAboveView:(UIView *)view
{
    self.centerTappedView = view;
    self.frame = view.bounds;
    [view addSubview:self];

    [self playMovie:@"start"];
    [self makeMaskView];
}

- (void)hide
{
    [self hideWithDirection:0];
}



#pragma mark - Member Method

- (void)hideWithDirection:(NSInteger)direction
{
    [self doDelegateMethodWithDirection:direction];
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_moviewPlayer stop];
        [self removeFromSuperview];
    }];
}

- (void)cleanAllProperties
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    [self doDelegateMethodWithDirection:0];
    self.alpha = 1;
    self.userInteractionEnabled = YES;
    _logoView = nil;
    _didTouchedTapView = NO;
    _didTapped = NO;
    _canTap = YES;
}

- (void)makeMaskView
{
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:_maskView];
    
    _tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _tapView.backgroundColor = [UIColor clearColor];
    _tapView.center = CGPointMake(CGRectGetWidth(self.frame)/2+4, CGRectGetHeight(self.frame)/2-5);
    [self addSubview:_tapView];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapAction)];
    [_tapView addGestureRecognizer:tapGuesture];
}

- (void)centerTapAction
{
    if (_canTap) {
        self.userInteractionEnabled = NO;
        [_moviewPlayer stop];
        [self removeTouchedBackgroundView];
        [self handleLogoTapEvent];
    }
}


- (void)handleLogoTapEvent
{
    _didTapped = YES;
    [self makeLogoView];
    [self startTapAnimation];
    
}


- (void)startTapAnimation
{
    
    [self startFlickerView:_logoView repeatCount:2];
    
    
}


- (void)startFlickerView:(UIView *)view repeatCount:(NSInteger)repeatCount
{
    if (repeatCount == 0) return;
    
    __block NSInteger count = repeatCount;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        view.alpha = 0.4;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            view.alpha = 1;
        } completion:^(BOOL finished) {
            count--;
            if (count == 0) {
                
                [weakSelf startAboveImageViewAnimation];
                
                CGRect frame = [weakSelf getRectWithView:weakSelf.centerTappedView];
                
                weakSelf.centerTappedView.userInteractionEnabled = NO;
            
                [UIView animateWithDuration:kAnimationDuration*3 animations:^{
                    view.frame = frame;
                    _moviewPlayer.view.alpha = 0;
                } completion:^(BOOL finished) {
                    weakSelf.centerTappedView.userInteractionEnabled = YES;
                }];
            }
            else
            {
                [weakSelf startFlickerView:view repeatCount:count];
            }
            
        }];

    }];
    
}


- (CGPoint)getCenterWithView:(UIView *)view
{
    UIView *v1 = [view viewWithTag:111];
    UIView *v2 = [v1 viewWithTag:112];
    
    CGPoint c1 = v2.center;

    CGPoint c2 = [v1 convertPoint:c1 toView:view];
    return c2;
}

- (CGRect)getRectWithView:(UIView *)view
{
    UIView *v1 = [view viewWithTag:111];
    UIView *v2 = [v1 viewWithTag:112];
    
    CGRect rect = [v1 convertRect:v2.frame toView:view];
    
    return rect;
}


#pragma mark - 背景动画

- (void)startAboveImageViewAnimation
{
    
    self.centerTappedView.transform =CGAffineTransformMakeScale(0.7, 0.7);
    
    [UIView beginAnimations:@"aboveImageView" context:nil];
    [UIView setAnimationDelay:kAnimationDuration];
    [UIView setAnimationDuration:kAnimationDuration*1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    self.centerTappedView.transform =CGAffineTransformMakeScale(1, 1);
    
    [UIView commitAnimations];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self doDelegateMethodWithDirection:0];
    [self removeFromSuperview];
}


#pragma mark - view to image
- (UIImageView *)convertViewToImage:(UIView*)v
{
    
    if (v == nil) return nil;
    UIGraphicsBeginImageContext(v.bounds.size);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = v.bounds;
    imageView.userInteractionEnabled = NO;
    
    return imageView;
}

- (void)doEndAnimation
{
    
}

- (void)animationWithBock:(void (^)(void))animations
{
    
}

- (void)makeLogoView
{

    if (_logoView) {
        return;
    }
    
    UIImage *logo = [UIImage imageNamed:@"AILogo"];
    
    _logoView = [[UIImageView alloc] initWithFrame:_tapView.frame];
    _logoView.image = logo;
    _logoView.userInteractionEnabled = NO;
    _originalLogoCenter = _tapView.center;
    _logoView.center = _originalLogoCenter;
    _logoView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self addSubview:_logoView];
}


/**
 @method 播放电影
 */
-(void)playMovie:(NSString *)fileName{
    //视频文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    //视频URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    _moviewPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    _moviewPlayer.controlStyle = MPMovieControlStyleNone;
    [_moviewPlayer.view setFrame:self.bounds];
    _moviewPlayer.repeatMode = MPMovieRepeatModeOne;
    _moviewPlayer.shouldAutoplay = YES;
    _moviewPlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self addSubview:_moviewPlayer.view];
    [_moviewPlayer play];
}


- (void)addTouchedBackgroundView
{
    _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
   
    [self insertSubview:_backgroundView aboveSubview:_moviewPlayer.view];
}

- (void)removeTouchedBackgroundView
{
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
}

- (void)removeLogoView
{
    if (_logoView) {
        [_logoView removeFromSuperview];
        _logoView = nil;
    }
}


#pragma mark - TouchEvent


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _didTouchedTapView = NO;
    UITouch *touch = [touches anyObject];
    
    if (touch.view == _tapView) {
        _didTouchedTapView = YES;
        _firstTouchPoint = [touch locationInView:self];
        
        [self addTouchedBackgroundView];
        [self makeLogoView];
        
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _canTap = YES;
    _didTouchedTapView = NO;
    [self removeTouchedBackgroundView];
    
    UITouch *touch = [touches anyObject];
    if (touch.view == _tapView) {
        _firstTouchPoint = CGPointZero;
        
        if (_logoView && !_didTapped) {
            [self removeLogoView];
        }
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_currentMovement > kMaxMoveSize) {
        [self hideWithDirection:_currentDirection];
    }
    else
    {
        _canTap = YES;
        _firstTouchPoint = CGPointZero;
        _currentDirection = AIMovementNone;
        [_moviewPlayer play];
        [self removeTouchedBackgroundView];
        
        [self removeLogoView];
    }
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_didTouchedTapView) return;
    
    _canTap = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint cPoint = [touch locationInView:self];
    
    CGPoint pPoint=[[touches anyObject] previousLocationInView:self];
    
    NSLog(@"point ---- %@", [NSValue valueWithCGPoint:cPoint]);
    
    //
    CGFloat xoff = cPoint.x - _firstTouchPoint.x;
    CGFloat yoff = cPoint.y - _firstTouchPoint.y;
    
    //
    
    BOOL didVerticalMove = fabs(cPoint.y - pPoint.y) > fabs(cPoint.x - pPoint.x) && !(_currentDirection == AIMovementLeft || _currentDirection == AIMovementRight);
    BOOL didHorontalMove = fabs(cPoint.x - pPoint.x) > fabs(cPoint.y - pPoint.y) && !(_currentDirection == AIMovementUp || _currentDirection == AIMovementDown);
    
    if (didVerticalMove) {
        
        NSLog(@"didVerticalMove");
        // 判断方向
        
        if (cPoint.y > _originalLogoCenter.y) {
            _currentDirection = AIMovementDown;
        }
        else if (cPoint.y < _originalLogoCenter.y)
        {
            _currentDirection = AIMovementUp;
        }
        
        // 计算位移量
        _currentMovement = fabs(yoff);
        
        
        // 开始位移
        
        _logoView.center = CGPointMake(_originalLogoCenter.x, cPoint.y);
        
    }
    else if (didHorontalMove)
    {
        NSLog(@"didHorontalMove");
        // 判断方向
        
        if (cPoint.x > _originalLogoCenter.x) {
            _currentDirection = AIMovementRight;
        }
        else if (cPoint.x < _originalLogoCenter.x)
        {
            _currentDirection = AIMovementLeft;
        }
        
        // 计算位移量
        _currentMovement = fabs(xoff);
        
        
        // 开始位移
        
        _logoView.center = CGPointMake(cPoint.x, _originalLogoCenter.y);

    }
    
    
    
    
    
    
}

@end
