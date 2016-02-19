//
//  RecommendViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#define RecommendUrl @"http://baobab.wandoujia.com/api/v2/feed?"


#import "RecommendViewController.h"

#import "WHRecommendModel.h"
#import "ReHeadTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "DetailViewController.h"
#import "SettingViewController.h"

@interface RecommendViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSString *NextPageUrl;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadMore;

@end

@implementation RecommendViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Energy";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"btn_menu_normal" ofType:@"png"];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:path] style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    self.navigationItem.rightBarButtonItem = right;
    
//    NSString *back = [[NSBundle mainBundle] pathForResource:@"mainBack" ofType:@"png"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:back]];
    
}

- (void)setAction {
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)initData {
    
    self.NextPageUrl = nil;
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    NSDictionary *dic =@{@"num":@(2),@"udid":@"3b5f39f0d5d34e40bf46fbe70c871841dd009c58",@"deviceModel":@"iPhone OS",@"first_channel":@"eyepetizer_yingyongbao_market",@"last_channel":@"eyepetizer_yingyongbao_market"};
    //第一次加载
    [self getNetDataWithUrl:dic];
}

- (void)createView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 250;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"Identifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"Head"];
    [self createRefreshView];
}

#pragma mark - 刷新

- (void)createRefreshView {
    __weak typeof(self) weakSelf = self;
    //刷新
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        
        weakSelf.isRefreshing = YES;
        NSDictionary *dic = @{@"num":@(2),@"udid":@"3b5f39f0d5d34e40bf46fbe70c871841dd009c58",@"deviceModel":@"iPhone OS",@"first_channel":@"eyepetizer_yingyongbao_market",@"last_channel":@"eyepetizer_yingyongbao_market"};

        //加载数据
        [weakSelf getNetDataWithUrl:dic];
    }];
    
    //加载
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"%d",weakSelf.isLoadMore);
        if (weakSelf.isLoadMore) {
            return ;
        }
        
        weakSelf.isLoadMore = YES;
        
        NSString *time = [weakSelf.NextPageUrl substringWithRange:NSMakeRange(RecommendUrl.length + 5, 13)];
        NSLog(@"%@",time);
        if (time == nil) {
            [weakSelf endRefreshing];
            return;
        }
        [weakSelf getNetDataWithUrl:@{@"date":time,@"num":@(2)}];
    }];
    
}

- (void)endRefreshing {
    if (self.isRefreshing) {
        //刷新结束
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}

#pragma mark - 下载数据
//下载数据
- (void)getNetDataWithUrl:(NSDictionary *)para {
    
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    NSLog(@"状态%ld",status);
    if (status == AFNetworkReachabilityStatusNotReachable) {
         //无网络状态
        
        NSString *path = [[NSString alloc] init];
        BOOL isExit;
        BOOL isTimeOut;
        if ([para objectForKey:@"date"] == nil) {
            path = [WHHelper getFullPathWithFile:@"1000"];
            isExit = [[NSFileManager defaultManager] fileExistsAtPath:path];
            isTimeOut = [WHHelper isTimeOutWithFile:@"1000" timeOut:30*24*60*60];
            [self.dataSource removeAllObjects];
        } else {
            path = [WHHelper getFullPathWithFile:[para objectForKey:@"date"]];
            isExit = [[NSFileManager defaultManager] fileExistsAtPath:path];
            isTimeOut = [WHHelper isTimeOutWithFile:[para objectForKey:@"date"] timeOut:30*24*60*60];
        }
        if (isExit && isTimeOut == NO) {
            //读本地
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            WHRecommendModel *model = [[WHRecommendModel alloc] initWithData:data error:nil];
            
            //获得下一页数据的链接
            self.NextPageUrl = model.nextPageUrl;
            
            //添加到数据源
            [self.dataSource addObjectsFromArray:model.issueList];
            
            [self.tableView reloadData];
        }
        
        [self endRefreshing];
        
        return;
    }
    
    //网络
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:RecommendUrl parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if ([para objectForKey:@"date"] == nil) {
                //加入缓存
                NSString *path = [WHHelper getFullPathWithFile:@"1000"];
                NSData *data = (NSData *)responseObject;
                [data writeToFile:path atomically:YES];
                
                [weakSelf.dataSource removeAllObjects];
            } else {
                //加入缓存
                NSString *path = [WHHelper getFullPathWithFile:[para objectForKey:@"date"]];
                NSData *data = (NSData *)responseObject;
                [data writeToFile:path atomically:YES];
            }
            
            WHRecommendModel *model = [[WHRecommendModel alloc] initWithData:responseObject error:nil];
            
            //获得下一页数据的链接
            weakSelf.NextPageUrl = model.nextPageUrl;
            
            //添加到数据源
            [weakSelf.dataSource addObjectsFromArray:model.issueList];
            
            [weakSelf.tableView reloadData];
        }
        [weakSelf endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//时间计算
- (NSString *)getDuration:(NSNumber *)duration {
    NSInteger num = [duration integerValue];
    NSInteger minute = num / 60;
    NSInteger second = num % 60;
    NSString *str = [NSString stringWithFormat:@"%ld'%ld\"",minute,second];
    return str;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        if (indexPath.row == 0 && indexPath.section != 0) {
            static NSString *identifier = @"Head";
            ReHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            WHIssueList * issueModel = [self.dataSource objectAtIndex:indexPath.section];
            WHItemList *itemModel = [issueModel.itemList objectAtIndex:0];
            cell.head.text = itemModel.data.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            static NSString *identifier = @"Identifier";
            RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            WHIssueList *issueModel = [self.dataSource objectAtIndex:indexPath.section];
            WHItemList *itemModel = [issueModel.itemList objectAtIndex:indexPath.row];
            if ([itemModel.type isEqualToString:@"imageHeader"]) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *path = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"png"];
            
            [cell.backImage sd_setImageWithURL:[NSURL URLWithString:itemModel.data.cover.feed] placeholderImage:[UIImage imageWithContentsOfFile:path]];
            cell.title.text = itemModel.data.title;
            cell.category.text = itemModel.data.category;
            cell.duration.text = [self getDuration:itemModel.data.duration];
            
            [cell.contentView bringSubviewToFront:cell.title];
            [cell.contentView bringSubviewToFront:cell.category];
            [cell.contentView bringSubviewToFront:cell.duration];
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }

    } else {
        return nil;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count > 0) {
        WHIssueList *issueListModel = [self.dataSource objectAtIndex:section];
        return issueListModel.itemList.count;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        if (indexPath.row == 0 && indexPath.section != 0) {
            return Default;
        } else {
            WHIssueList *issueModel = [self.dataSource objectAtIndex:indexPath.section];
            WHItemList *itemModel = [issueModel.itemList objectAtIndex:indexPath.row];
            if ([itemModel.type isEqualToString:@"imageHeader"]) {
                return 10;
            }
            return 250;
        }

    } else {
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        if (indexPath.row == 0 && indexPath.section != 0) {
            
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            WHIssueList *issueModel = [self.dataSource objectAtIndex:indexPath.section];
            WHItemList *itemModel = [issueModel.itemList objectAtIndex:indexPath.row];
            WHData *dataModel = itemModel.data;
            DetailViewController *dvc = [[DetailViewController alloc] initWithDataModel:dataModel];
            [self.navigationController pushViewController:dvc animated:YES];
        }

    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
