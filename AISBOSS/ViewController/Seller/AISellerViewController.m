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
#import "Veris-Swift.h"
#import "AIServerConfig.h"
#import "AIOrderTableModel.h"

#define kTablePadding      15

#define kBarHeight         50

#define kCommonCellHeight  95

@interface AISellerViewController ()
{
    UIColor *_normalBackgroundColor;
    
}

@property (nonatomic, strong) NSArray *sellerInfoList;

@property (nonatomic, strong) AIOrderPreListModel *listModel;

@property (nonatomic, strong) NSMutableDictionary *tableDictionary;

@property (nonatomic, strong) NSMutableArray *tableHeaderList;

@end

@implementation AISellerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];;
    
    [self makeBackGroundView];
    [self makeTableView];
    [self makeBottomBar];
    [self addRefreshActions];
    [self preProcess];
    [self setupLanguageNotification];
    
    //Chaged UserID.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAfterUserChanged) name:kShouldUpdataUserDataNotification object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self preProcess];
    [AISellserAnimationView startAnimationOnSellerViewController:self];
}


- (void)handleUserChangeEvent {
    [_tableDictionary removeAllObjects];
    [_tableHeaderList removeAllObjects];
    self.sellerInfoList = nil;
    [self.tableView reloadData];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.sellerData = nil;
    
    [self.tableView headerBeginRefreshing];
}


- (void) reloadDataAfterUserChanged {
    
    __weak typeof (self) ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ws handleUserChangeEvent];
    });
    
    
    
}


- (void)setupLanguageNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupUIWithCurrentLanguage) name:@"LCLLanguageChangeNotification" object:nil];
}

- (void)setupUIWithCurrentLanguage {
    //TODO: reload data with current language
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

- (void)preProcess
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    if (delegate.sellerData ) {
        self.listModel = [[AIOrderPreListModel alloc] initWithDictionary:delegate.sellerData error:nil];
        if (self.listModel != nil && self.listModel.order_list.count > 0) {
            
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [AISellserAnimationView startAnimationOnSellerViewController:self];
        }else{
            [self.tableView headerBeginRefreshing];
        }
       
    }
    else
    {
        [self.tableView headerBeginRefreshing];
    }
    
}

- (AIMessage *)getServiceListWithUserID:(NSInteger)userID role:(NSInteger)role
{
    AIMessage *message = [AIMessage message];
    
    message.url = @"http://ip:portget/sbss/ServiceCalendarMgr";
    //[message.body setObject:[NSNumber numberWithInteger:userID] forKey:@"user_id"];//order_role
    //[message.body setObject:[NSNumber numberWithInteger:role] forKey:@"order_role"];
    
    return message;
}


- (void)makeFakeDatas
{
    NSString *jsonString = [AITools readJsonWithFileName:@"sellerOrderList" fileType:@"json"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    self.listModel = [[AIOrderPreListModel alloc] initWithDictionary:dic error:nil];

    
}

- (void)parseTableDataSource
{
    if (_tableDictionary) {
        [_tableDictionary removeAllObjects];
        [_tableHeaderList removeAllObjects];
    }
    else
    {
        _tableDictionary = [[NSMutableDictionary alloc] init];
        _tableHeaderList = [[NSMutableArray alloc] init];
    }
    
    
    for (AIOrderPreModel *model in self.listModel.order_list)
    {
        NSString *sort = model.order_sort_time;
        AIOrderTableModel *tableModel = [_tableDictionary objectForKey:sort];
       
        if (tableModel == nil) {
            
            tableModel = [[AIOrderTableModel alloc] init];
            tableModel.timeTitle = model.order_create_time;
            tableModel.sortTime = sort;
            tableModel.nameTitle = model.proposal_name;
            [_tableDictionary setObject:tableModel forKey:sort];
            
            [_tableHeaderList addObject:sort];
        }
        
        [tableModel.orderList addObject:model];
        
    }
    
}

- (void)addRefreshActions
{
    __weak typeof(self) weakSelf = self;
    
   
    [self.tableView addHeaderWithCallback:^{
            NSDictionary *dic = @{@"data": @{@"order_state": @"0",@"order_role": @"2"},
                                  @"desc": @{@"data_mode": @"0",@"digest": @""}};
        
            AIMessage  * message = [[AIMessage alloc] init];
            //AIMessage *message = [weakSelf getServiceListWithUserID:123123123 role:2];
            [message.body addEntriesFromDictionary:dic];            
            message.url =  kURL_QuerySellerOrderList;
            [weakSelf.tableView hideErrorView];
            [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
                
                if (response != nil){
                    NSArray * array = response[@"order_list"];
                    if (array != nil)  {
                        if (array.count > 0) {
                            weakSelf.listModel = [[AIOrderPreListModel alloc] initWithDictionary:response error:nil];
                            if (weakSelf.listModel == nil){
                                [weakSelf.tableView showErrorContentView];
                            }
                            else
                            {
                                [weakSelf parseTableDataSource];
                            }
                        }else{
                            [weakSelf.tableView showDiyContentView:@"No Data"];
                        }
                        
                    }else{
                        [weakSelf.tableView showErrorContentView];
                    }
                }
                
                
                dispatch_main_async_safe(^{
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView headerEndRefreshing];
                });
    
            } fail:^(AINetError error, NSString *errorDes) {
                 dispatch_main_async_safe(^{
                     [weakSelf.tableView headerEndRefreshing];
                     [weakSelf.tableView showErrorContentView];
                 });
                
            }];
     
    }];
     
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf.tableView footerEndRefreshing];
        
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



#pragma mark - Go Back


- (void)gobackAction
{
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    
    [[AIOpeningView instance] show];
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
        tableView.backgroundColor = [UIColor clearColor];
        
        [self addBackgroundViewForTable:tableView];
        [self addTopAndBottomMaskForTable:tableView];
        
        tableView;
    });
    
    
    [self.view addSubview:self.tableView];
    //[self makeMaskForTable];
}

// test
- (void)makeMaskForTable
{
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(maskView.frame) / 2, 0) radius:CGRectGetWidth(maskView.frame) / 2 startAngle:0 endAngle:M_PI clockwise:YES];
    
    CAShapeLayer *tracklayer = [CAShapeLayer layer];
    tracklayer.fillColor = [[UIColor clearColor] CGColor];
    tracklayer.frame = maskView.bounds;
    tracklayer.path = [path CGPath];
    maskView.layer.mask = tracklayer;
    maskView.userInteractionEnabled = NO;
    //
    
    
    //边框蒙版
//    
    CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];
    
    maskBorderLayer.path = [path CGPath];
    
    maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    maskBorderLayer.mask = tracklayer;
    //边框宽度
    [maskView.layer addSublayer:tracklayer];
    [self.view addSubview:maskView];
    self.view.clipsToBounds = YES;
    self.view.layer.masksToBounds = YES;
}


#pragma mark - TableViewDataSource


- (SellerCellColorType)orderState:(NSInteger)state
{
    SellerCellColorType type;
    
    if (state == 10 || state == 14 || state == 11)
    {
        type = SellerCellColorTypeNormal;
    }
    else if (state == 100)
    {
        type = SellerCellColorTypeGreen;
    }
    else
    {
        type = SellerCellColorTypeBrown;
    }
    
    
    return type;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    for (NSInteger i = 0; i < _tableDictionary.allKeys.count; i++) {
        AIOrderTableModel *model = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:i]];
        if (i == section) {
            return model.orderList.count;
        }
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableHeaderList.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = CGRectGetWidth(tableView.frame);
    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:section]];
    
    UPLabel *nameLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, width, 20) text:tableModel.nameTitle fontSize:16 color:Color_HighWhite];
    
    UPLabel *timeLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, width, 20) text:tableModel.timeTitle fontSize:16 color:Color_HighWhite];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    view.backgroundColor = _normalBackgroundColor;
    [view addSubview:nameLabel];
    [view addSubview:timeLabel];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resueID = @"SellerCell";
    AISellerCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];
    if (!cell) {
        cell = [[AISellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:indexPath.section]];
    
    
    
    AIOrderPreModel *model = [tableModel.orderList objectAtIndex:indexPath.row];
    [cell.sellerIcon sd_setImageWithURL:[NSURL URLWithString:model.customer.user_portrait_icon] placeholderImage:[UIImage imageNamed:@"Placehold"]];
    cell.sellerName.text = model.customer.user_name;
    cell.price.text = model.service.service_price;
    
    NSString *time = [@"AISellerViewController.2beConfirmed" localized];
    NSString *address = [@"AISellerViewController.2beConfirmed" localized];
    
    NSArray *array = model.service_progress.param_list;
    if (array) {
        for (AIServiceParamModel *model in array) {
            
            if ([model.param_key isEqualToString:@"time"]) {
                time = model.param_value ?: time;
            }
            else if ([model.param_key isEqualToString:@"location"])
            {
                address = model.param_value ?: address;
            }
        }
    }
    
    cell.userPhone = model.customer.user_phone;
    cell.timestamp.text = time;
    cell.location.text = address;
    [cell setBackgroundColorType:[self orderState:model.order_state]];
    [cell setButtonType:model.service_progress.operation];
    [cell setProgressBarModel:model.service_progress];
    [cell setServiceCategory:model];
    
    return cell;
}


#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:indexPath.section]];
    AIOrderPreModel *model = [tableModel.orderList objectAtIndex:indexPath.row];
    
    AIProposalServiceModel *serviceModel = [[AIProposalServiceModel alloc] init];
    serviceModel.service_id = model.service.service_id;
    
    AIServiceContentViewController *contentVC = [[AIServiceContentViewController alloc] init];
    contentVC.serviceContentModel = serviceModel;
    contentVC.propodalId = model.proposal_id;
    contentVC.customID = [NSString stringWithFormat:@"%ld", model.customer.user_id ?: 0];
    
    [self presentViewController:contentVC animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCommonCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
@end
