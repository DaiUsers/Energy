//
//  DownloadViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/7.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadTableViewCell.h"
#import "DBManager.h"
#import "WHData.h"
#import "VideoplayViewController.h"
#import "NSString+Hashing.h"

@interface DownloadViewController () <UITableViewDataSource,UITableViewDelegate,CellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger num;

@end

@implementation DownloadViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//获取在沙盒中的全路径
- (NSString *)getFullFilePathWithUrl:(NSString *)urlname {
    NSString * name = [urlname MD5Hash];
    //获取在沙盒中的路径
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp4",name];
    return path;
}

- (void)initData {
    _dataArray = (NSMutableArray *)[[DBManager sharedManager] readModelsWithRecordType:@"download"];
    self.num = _dataArray.count;
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150;
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"Download"];
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
    static NSString *identifier = @"Download";
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    WHData *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.title.text = model.title;
    cell.time.text = [self getDuration:model.duration];
    cell.category.text = model.category;
    
    NSString *place = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"png"];
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model.feed] placeholderImage:[UIImage imageWithContentsOfFile:place]];
    
    NSString *path = [self getFullFilePathWithUrl:model.playUrl];
    cell.url = path;
    
    [cell getSliderValue:model.playUrl];
//    [cell startAction:nil];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth, 30)];
        _label.text = [NSString stringWithFormat:@"    有%ld条下载记录",self.dataArray.count];
        _label.textColor = RGB(120, 120, 120);
        _label.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}



- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"没有更多数据";
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
        
        [[DBManager sharedManager] deleteModelForDataId:[model.dataId stringValue] recordType:@"download"];
        
        NSString *path = [self getFullFilePathWithUrl:model.playUrl];
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL ret = [fileManager removeItemAtPath:path error:nil];
        if (ret) {
            NSLog(@"删除成功");
        }
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        self.num = self.dataArray.count;
    }
}

//cell响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WHData *model = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *path = [self getFullFilePathWithUrl:model.playUrl];
//    VideoplayViewController *pvc = [[VideoplayViewController alloc] initWithPath:path];
//    [self presentViewController:pvc animated:YES completion:nil];
//    
// 
}

#pragma mark - CEll 协议

- (void)cellClicked:(id)sender {
    DownloadTableViewCell *cell = (DownloadTableViewCell *)sender;
    VideoplayViewController *pvc = [[VideoplayViewController alloc] initWithPath:cell.url];
    [self presentViewController:pvc animated:YES completion:nil];
}


#pragma mark - 观察者

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:@"num"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"num"]) {
        _label.text = [NSString stringWithFormat:@"    有%ld条下载记录",self.dataArray.count];
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    NSArray *visibleCells = [_tableView indexPathsForVisibleRows];
//    for (NSIndexPath *indexPath in visibleCells) {
//        DownloadTableViewCell *cell = (DownloadTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//        WHData *model = [self.dataArray objectAtIndex:indexPath.row];
//        [cell getSliderValue:model.playUrl];
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
