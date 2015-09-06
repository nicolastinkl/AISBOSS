//
//  AIRootViewController.m
//  AITrans
//
//  Created by 王坜 on 15/7/17.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIRootViewController.h"


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
    
    [self makeChildViewControllers];
    [self startOpenningAnimation];
    
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

- (void)startOpenningAnimation
{
    [AIOpeningView instance].delegate = self;
    [AIOpeningView instance].rootView = self.view;
    [AIOpeningView instance].centerTappedView = self.centerTapViewController.view;
    [AIOpeningView instance].upDirectionView = self.upDirectionViewController.view;
    [[AIOpeningView instance] show];
}

- (void)makeChildViewControllers
{
    // center
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"UIMainStoryboard" bundle:nil];
    self.centerTapViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UITransViewController"];
    [self addChildViewController:self.centerTapViewController];
    [self.centerTapViewController didMoveToParentViewController:self];
    
    // up
    storyBoard=[UIStoryboard storyboardWithName:@"UICustomerStoryboard" bundle:nil];
    self.upDirectionViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CustomHomeViewController"];
    [self addChildViewController:self.upDirectionViewController];
    [self.upDirectionViewController didMoveToParentViewController:self];
    
    
    [self.view addSubview:self.centerTapViewController.view];
    _currentViewController = self.centerTapViewController;
}

- (void)didOperatedWithDirection:(NSInteger)direction// 0:center 1:up 2:down 3:lef 4:right
{

    switch (direction) {
        case 0:
        {
            if (_currentViewController == self.centerTapViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.centerTapViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.centerTapViewController;
            }];
        }
            break;
        case 1:
        {
            if (_currentViewController == self.upDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.upDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.upDirectionViewController;
            }];
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
}

@end
