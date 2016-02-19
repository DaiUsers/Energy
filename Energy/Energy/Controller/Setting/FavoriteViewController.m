//
//  FavoriteViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/7.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "FavoriteViewController.h"

#import "WHData.h"
#import "DBManager.h"
#import "RecommendTableViewCell.h"
#import "DetailViewController.h"

@interface FavoriteViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation FavoriteViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    
    _dataArray = (NSMutableArray *)[[DBManager sharedManager] readModelsWithRecordType:@"favorite"];
    [self.tableView reloadData];
    _label.text = [NSString stringWithFormat:@"    有%ld条收藏记录",self.dataArray.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataArray = (NSMutableArray *)[[DBManager sharedManager] readModelsWithRecordType:@"favorite"];
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 200;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"Identifier"];
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

#pragma mark - TableView 协议

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    WHData *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"png"];
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model.feed] placeholderImage:[UIImage imageWithContentsOfFile:path]];
    
    cell.title.text = model.title;
    cell.duration.text = [self getDuration:model.duration];
    cell.category.text = model.category;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth, 30)];
        _label.text = [NSString stringWithFormat:@"    有%ld条收藏记录",self.dataArray.count];
        _label.textColor = RGB(120, 120, 120);
        _label.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"没有更多数据";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WHData *model = [self.dataArray objectAtIndex:indexPath.row];
    DetailViewController *dvc = [[DetailViewController alloc] initWithDataModel:model];
    [self.navigationController pushViewController:dvc animated:YES];
}

//删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        WHData *model = [self.dataArray objectAtIndex:indexPath.row];
        
        [[DBManager sharedManager] deleteModelForDataId:[model.dataId stringValue] recordType:@"favorite"];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
        _label.text = [NSString stringWithFormat:@"    有%ld条收藏记录",self.dataArray.count];
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
