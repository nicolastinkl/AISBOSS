//
//  AIRootViewController.m
//  AITrans
//
//  Created by 王坜 on 15/7/17.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIRootViewController.h"
#import "AISellerViewController.h"
#import "Veris-Swift.h"

@interface AIRootViewController ()
{
    UIViewController *_currentViewController;
}

@property (nonatomic, strong) UIViewController *centerTapViewController;
@property (nonatomic, strong) UIViewController *upDirectionViewController;
@property (nonatomic, strong) UIViewController *downDirectionViewController;
@property (nonatomic, strong) UIViewController *leftDirectionViewController;
@property (nonatomic, strong) UIViewController *rightDirectionViewController;

@end

@implementation AIRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*!
     *  @author tinkl, 15-09-09 17:09:59
     *
     *  初始化处理
     */
    [self makeChildViewControllers];
    [self startOpenningAnimation];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Method

- (void)makeChildViewControllers
{
    // center
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UIMainStoryboard" bundle:nil];
    self.centerTapViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UITransViewController"];
    [self addChildViewController:self.centerTapViewController];
    [self.centerTapViewController didMoveToParentViewController:self];
    
    // up
    AIUINavigationController *upNavi = [[AIUINavigationController alloc] initWithRootViewController:[[AIBuyerViewController alloc] init]];
    self.upDirectionViewController = upNavi;
    [self addChildViewController:self.upDirectionViewController];
    [self.upDirectionViewController didMoveToParentViewController:self];
    
    // down
    AISellerViewController *sellerViewController = [[AISellerViewController alloc] init];
    [self addChildViewController:sellerViewController];
    self.downDirectionViewController = sellerViewController;
    [sellerViewController didMoveToParentViewController:self];
    
    // left
    self.leftDirectionViewController = self.centerTapViewController;
    [self addChildViewController:self.leftDirectionViewController];
    [self.leftDirectionViewController didMoveToParentViewController:self];
    
    // RIGHT
    self.rightDirectionViewController = self.centerTapViewController;
    
    // default
    [self.view addSubview:self.centerTapViewController.view];
    _currentViewController = self.centerTapViewController;
}

- (void)didOperatedWithDirection:(NSInteger)direction// 0:center 1:up 2:down 3:lef 4:right
{
    
    switch (direction) {
        case 0: //0:center
        {
            if (_currentViewController == self.centerTapViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.centerTapViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.centerTapViewController;
            }];
        }
            break;
        case 1: // 1:up
        {
            if (_currentViewController == self.upDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.upDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.upDirectionViewController;
            }];
        }
            break;
        case 2: // 2:down
        {
            if (_currentViewController == self.downDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.downDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.downDirectionViewController;
            }];
        }
            break;
        case 3: // 3:lef
        {
            if (_currentViewController == self.leftDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.leftDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.leftDirectionViewController;
            }];
        }
            break;
        case 4: // 4:right
            //时间轴
            
            if (_currentViewController == self.rightDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.rightDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.rightDirectionViewController;
            }];
            break;
            
    }
}

/*!
 *  @author tinkl, 15-09-07 17:09:53
 *
 *  设置初始化状态
 */
- (void)startOpenningAnimation
{
    [AIOpeningView instance].delegate = self;
    [AIOpeningView instance].rootView = self.view;
    [AIOpeningView instance].centerTappedView = self.centerTapViewController.view;
    [[AIOpeningView instance] show];
}

@end
