//
//  AISellerViewController.m
//  AITrans
//
//  Created by 王坜 on 15/7/21.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellerViewController.h"
#import "AISellerCell.h"
#import "AISellerModel.h"
#import "AISellingProgressBar.h"
#import "AITools.h"
#import "AIViews.h"
#import "AIOpeningView.h"
#import "AIShareViewController.h"

#import "AINetEngine.h"

#define kTablePadding      15

#define kBarHeight         50

@interface AISellerViewController ()
{
    UIColor *_normalBackgroundColor;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sellerInfoList;

@end

@implementation AISellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeDatas];
    [self makeBackGroundView];
    [self makeTableView];
    [self makeBottomBar];
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

- (void)makeDatas
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Seller" withExtension:@"plist"];
    self.sellerInfoList = [NSArray arrayWithContentsOfURL:path];
}

- (void)makeBottomBar
{
    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);
    
    // add shadow
    UIImage *shadowImage = [UIImage imageNamed:@"Seller_BarShadow"];
    UIImageView *shadow = [[UIImageView alloc] initWithImage:shadowImage];
    shadow.frame = CGRectMake(0, maxHeight-kBarHeight-shadowImage.size.height, maxWidth, shadowImage.size.height);
    [self.view addSubview:shadow];
    
    // add bar
    UIImageView *barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serller_bar"]];
    barView.frame = CGRectMake(0, maxHeight-kBarHeight, maxWidth, kBarHeight);
    barView.userInteractionEnabled = YES;
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    barView.layer.shadowOffset = CGSizeMake(0, 0);
    barView.layer.shadowOpacity = 1;
    [self.view addSubview:barView];
    
    // add logo
    UIImage *image = [UIImage imageNamed:@"top_logo_default"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 80);
    button.center = CGPointMake(maxWidth/2, CGRectGetHeight(barView.frame)/2-7);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"top_logo_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(gobackAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:button];
    
    
    
}


- (void)gobackAction
{
    /*
    AIMessage *message = [AIMessage message];
    
    NSDictionary *dic = @{
                      @"data": @{
                          @"page_num": @"1",
                          @"page_size": @"10",
                          @"topic_id": @"1"
                      },
                      @"desc": @{
                          @"data_mode": @"0",
                          @"digest": @""
                      }
                      };
    
    

    message.body = [NSMutableDictionary dictionaryWithDictionary:dic];
    [message.header setObject:@"0&0&0&0" forKey:@"HttpQuery"];
    message.url = @"http://171.221.254.231:8282/sboss/getServiceTopic";
    
    [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
        NSLog(@"success1");
    } fail:^(AINetError error, NSString *errorDes) {
        NSLog(@"errorDes1");
    }];
    
    [message.header setObject:@"22222222" forKey:@"HttpQuery"];
    [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
        NSLog(@"success2");
    } fail:^(AINetError error, NSString *errorDes) {
        NSLog(@"errorDes2");
    }];
    
    [message.header setObject:@"33333333" forKey:@"HttpQuery"];
    [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
        NSLog(@"success3");
    } fail:^(AINetError error, NSString *errorDes) {
        NSLog(@"errorDes3");
    }];
    [[AINetEngine defaultEngine] cancelMessage:message];
    [message.header setObject:@"4444444444444" forKey:@"HttpQuery"];
    [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
        NSLog(@"success4");
    } fail:^(AINetError error, NSString *errorDes) {
        NSLog(@"errorDes4");
    }];
     [[AINetEngine defaultEngine] cancelAllMessages];
    */
//    //
    [[AIOpeningView instance] show];
//    AIShareViewController *shareVC = [AIShareViewController shareWithText:@"分享是一种快乐~"];
//    [self presentViewController:shareVC animated:YES completion:nil];
}

- (void)makeBackGroundView
{    //
    _normalBackgroundColor = [AITools colorWithHexString:@"1e1b38"];
    self.view.backgroundColor = _normalBackgroundColor;
    
}

- (void)addTopAndBottomMaskForTable:(UITableView *)table
{
    
    // header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), kTablePadding)];
    view.backgroundColor = _normalBackgroundColor;
    table.tableHeaderView = view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, -500, CGRectGetWidth(table.frame), 500)];
    view.backgroundColor = _normalBackgroundColor;
    [table.tableHeaderView addSubview:view];
    
    // footer
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), kBarHeight - 1)];
    view.backgroundColor = _normalBackgroundColor;
    table.tableFooterView = view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), 1000)];
    view.backgroundColor = _normalBackgroundColor;
    [table.tableFooterView addSubview:view];
    
}


- (void)addBackgroundViewForTable:(UITableView *)table
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:table.bounds];
    backImageView.image = [UIImage imageNamed:@"wholebackground"];
    backImageView.layer.cornerRadius = 8;
    backImageView.layer.masksToBounds = YES;
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    table.backgroundView = backImageView;
}

- (void)makeTableView
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kTablePadding, 0, CGRectGetWidth(self.view.frame)-kTablePadding*2, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        
        [self addBackgroundViewForTable:tableView];
        [self addTopAndBottomMaskForTable:tableView];
        
        tableView;
    });
    
    [self.view addSubview:self.tableView];
}


#pragma mark - TableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sellerInfoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resueID = @"SellerCell";
    AISellerCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
    if (!cell) {
        cell = [[AISellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueID];
        
        
    }
    
    AISellerModel *model = [[AISellerModel alloc] initWithContent:[self.sellerInfoList objectAtIndex:indexPath.row]];
    cell.sellerIcon.image = model.sellerIcon;
    cell.sellerName.text = model.sellerName;
    cell.price.text = model.goodsPrice;
    cell.timestamp.text = model.timestamp;
    cell.location.text = model.location;
    [cell setBackgroundColorType:model.colorType];
    [cell setButtonType:model.buttonType];
    [cell setProgressBarContent:model.progress];
    [cell setImages:model.sellerIcons];
    [cell setMessageNumber:model.messageNum];
    
    return cell;
}







#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
@end
