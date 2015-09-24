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
#import "AISellserAnimationView.h"
#import "AINetEngine.h"
#import "MJRefresh.h"
#import "AIOrderPreModel.h"
#import "UIImageView+WebCache.h"

#define kTablePadding      15

#define kBarHeight         50

#define kCommonCellHeight  95

@interface AISellerViewController ()
{
    UIColor *_normalBackgroundColor;
    
}



@property (nonatomic, strong) NSArray *sellerInfoList;

@property (nonatomic, strong) AIOrderPreListModel *listModel;

@end

@implementation AISellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];;
    
    [self makeFakeDatas];
    [self makeDatas];
    [self makeBackGroundView];
    [self makeTableView];
    [self makeBottomBar];
    [self addRefreshActions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AISellserAnimationView startAnimationOnSellerViewController:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (AIMessage *)getServiceListWithUserID:(NSInteger)userID role:(NSInteger)role
{
    AIMessage *message = [AIMessage message];
    
    message.url = @"http://ip:portget/sbss/ServiceCalendarMgr";
    [message.body setObject:[NSNumber numberWithInteger:userID] forKey:@"user_id"];//order_role
    [message.body setObject:[NSNumber numberWithInteger:role] forKey:@"order_role"];
    
    return message;
}


- (void)makeFakeDatas
{
    NSString *jsonString = [AITools readJsonWithFileName:@"sellerOrderList" fileType:@"json"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    self.listModel = [[AIOrderPreListModel alloc] initWithDictionary:dic error:nil];

    
}

- (void)addRefreshActions
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        
        
        /*
        AIMessage *message = [weakSelf getServiceListWithUserID:123123123 role:1];
        
        [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
            [weakSelf.tableView headerEndRefreshing];
        } fail:^(AINetError error, NSString *errorDes) {
            [weakSelf.tableView headerEndRefreshing];
        }];
         */
        
        // Fake Data
        
        dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2);
        
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            
            
            [weakSelf makeFakeDatas];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView headerEndRefreshing];
            
        });
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        
        dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2);
        
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView footerEndRefreshing];
            
        });
        
    }];
}

- (void)makeDatas
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Seller" withExtension:@"plist"];
    self.sellerInfoList = [NSArray arrayWithContentsOfURL:path];
}

- (void)makeBottomBar
{
    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight-kBarHeight, maxWidth, kBarHeight)];
    [self.view addSubview:_bottomView];
    
    
    // add shadow
    UIImage *shadowImage = [UIImage imageNamed:@"Seller_BarShadow"];
    UIImageView *shadow = [[UIImageView alloc] initWithImage:shadowImage];
    shadow.frame = CGRectMake(0, -shadowImage.size.height, maxWidth, shadowImage.size.height);
    [_bottomView addSubview:shadow];
    
    // add bar
    UIImageView *barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serller_bar"]];
    barView.frame = CGRectMake(0, 0, maxWidth, kBarHeight);
    barView.userInteractionEnabled = YES;
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    barView.layer.shadowOffset = CGSizeMake(0, 0);
    barView.layer.shadowOpacity = 1;
    [_bottomView addSubview:barView];
    
    // add logo
    UIImage *image = [UIImage imageNamed:@"top_logo_default"];
    _logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _logoButton.frame = CGRectMake(0, 0, 80, 80);
    _logoButton.center = CGPointMake(maxWidth/2, CGRectGetHeight(barView.frame)/2-7);
    [_logoButton setImage:image forState:UIControlStateNormal];
    [_logoButton setImage:[UIImage imageNamed:@"top_logo_click"] forState:UIControlStateHighlighted];
    [_logoButton addTarget:self action:@selector(gobackAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_logoButton];
    
    
    
}



#pragma mark - 开场动画



- (UIImage*)imageFromView:(UIView*)view
{
    UIGraphicsBeginImageContext([view bounds].size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}





- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)startAnimations
{
    [self.tableView scrollsToTop];
    
    // make Background
    UIView *background = [[UIView alloc] initWithFrame:self.view.bounds];
    background.backgroundColor = [UIColor blackColor];
    [self.view addSubview:background];
    
    
    // make ImageViews
    
    UIImage *image = [self imageFromView:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.tableView.frame;
    [background addSubview:imageView];
    
    
//    for (UITableViewCell *cell in self.tableView.visibleCells) {
//        
//        UIImage *image = [self imageFromView:cell];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = cell.frame;
//        [background addSubview:imageView];
//        
//    }
    
    // make Animations
    
    
    
    
}


/////////////////

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
    return self.listModel.order_list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resueID = @"SellerCell";
    AISellerCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
    if (!cell) {
        cell = [[AISellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueID];
        
        
    }
    
    AIOrderPreModel *model = [self.listModel.order_list objectAtIndex:indexPath.row];
    [cell.sellerIcon sd_setImageWithURL:[NSURL URLWithString:model.customer.user_portrait_icon] placeholderImage:[UIImage imageNamed:@"Placehold"]];
    cell.sellerName.text = model.customer.user_name;
    cell.price.text = model.service.service_price;
    
    NSString *time = @"To Be Confrimed";
    NSString *address = @"To Be Confrimed";
    
    NSArray *array = model.service_progress.param_list;
    if (array) {
        for (AIServiceParamModel *model in array) {
            
            if (model.param_type == 1) {
                time = model.param_value ?: time;
            }
            else if (model.param_type == 2)
            {
                address = model.param_value ?: address;
            }
        }
    }
    
    cell.timestamp.text = time;
    cell.location.text = address;
    [cell setBackgroundColorType:model.order_state];
    [cell setButtonType:model.order_state];
    [cell setProgressBarModel:model.service_progress];
    [cell setServiceCategory:model];
    
    return cell;
}







#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCommonCellHeight;
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
