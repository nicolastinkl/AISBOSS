//
//  AIShareViewController.m
//  WeiboSDKLibDemo
//
//  Created by 王坜 on 15/7/30.
//  Copyright (c) 2015年 SINA iOS Team. All rights reserved.
//

#import "AIShareViewController.h"
#import "AIWeiboData.h"

#define kSeperatorMargin    8
#define kUnitHeight         44

#define kLogoSize           44

// important

#define kWeiboAppKey         @"948837607"
#define kWeiboRedirectURI    @"http://www.sina.com"



typedef NS_ENUM(NSInteger, AIShareType) {
    AIShareTypeWeibo = 1000,
    AIShareTypeQQ,
    AIShareTypeWechat,
    AIShareTypeSMS,
    AIShareTypeEmail,
};


@interface AIShareViewController ()
{
    UIScrollView *_scrollView;
    UIView *_sheetView;
    CGFloat _contentMaxWidth;
}



@end

@implementation AIShareViewController

+ (instancetype)shareWithText:(NSString *)text
{
    AIShareViewController *instance = [AIShareViewController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    instance.shareText = text;
    
    [instance addAction:[UIAlertAction actionWithTitle:@"12"
                                             style:UIAlertActionStyleDefault
                                           handler:nil]];
    
    [instance addAction:[UIAlertAction actionWithTitle:@"取消"
                                             style:UIAlertActionStyleCancel
                                           handler:nil]];
    
    [instance addAction:[UIAlertAction actionWithTitle:@"12"
                                             style:UIAlertActionStyleDefault
                                           handler:nil]];
    
    return instance;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AIWeiboData instance].shareViewController = self;
    
    _sheetView = [self.view.subviews lastObject];
    
    [self addScrollViewOnView:_sheetView];
    [self addShareWays];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - 添加分享方式

- (void)addScrollViewOnView:(UIView *)view
{
    _contentMaxWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - kSeperatorMargin*2);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _contentMaxWidth, kUnitHeight*2)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _scrollView.clipsToBounds = YES;
    _scrollView.layer.cornerRadius = 5;
    
    [view addSubview:_scrollView];
    
}

- (void)addShareWays
{
    CGFloat x = (_contentMaxWidth - kLogoSize) / 2;
    CGFloat y = (CGRectGetHeight(_scrollView.frame) - kLogoSize) / 2;
    CGRect frame = CGRectMake(x, y, kLogoSize, kLogoSize);
    [self addShareWithFrame:frame type:AIShareTypeWeibo logo:@"weibo_logo"];
}


- (void)addShareWithFrame:(CGRect)frame type:(AIShareType)type logo:(NSString *)logoName
{
    UIImage *image = [UIImage imageNamed:logoName];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;///
    [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.tag = type;
    [_scrollView addSubview:button];
}


#pragma mark - 分享方式

- (void)shareAction:(UIButton *)button
{
    
    switch (button.tag) {
        case AIShareTypeWeibo:
        {
            [self shareWithWeibo];
        }
            break;
        case AIShareTypeQQ:
        {
            
        }
            break;
        case AIShareTypeWechat:
        {
            
        }
            break;
        case AIShareTypeSMS:
        {
            
        }
            break;
        case AIShareTypeEmail:
        {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - 微博分享

- (void)shareWithWeibo
{
    self.view.alpha = 0;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kWeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = self.shareText;
    
    NSString *token = [AIWeiboData instance].wbtoken;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:token];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

#pragma mark -
#pragma WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    NSString *title = (response.statusCode == 0) ? @"分享成功！" : @"分享失败";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
