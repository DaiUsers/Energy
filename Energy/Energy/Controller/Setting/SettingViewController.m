//
//  SettingViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/6.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "SettingViewController.h"
#import "FavoriteViewController.h"
#import "DownloadViewController.h"
#import "AboutViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController

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

- (void)initData {
    _dataArray = @[@"收藏",@"下载",@"清除缓存",@"关于"];
}

- (void)createView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setback" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    
    [self.view addSubview:imageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView 协议

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.section];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FavoriteViewController *fvc = [[FavoriteViewController alloc] init];
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (indexPath.section == 1) {
        DownloadViewController *dvc = [[DownloadViewController alloc] init];
        [self.navigationController pushViewController:dvc animated:YES];
    } else if (indexPath.section == 2) {
        NSString *sizeStr = [NSString stringWithFormat:@"%.2fM",[self getCacheSize]];
        UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:sizeStr preferredStyle:UIAlertControllerStyleActionSheet];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //删除按钮
            //1.删除sd
            [[SDImageCache sharedImageCache] clearMemory];//清除内存缓存
            [[SDImageCache sharedImageCache] clearDisk];//磁盘
            //2.界面下载的缓存
            NSString *myPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyCaches"];
            //删除
            [[NSFileManager defaultManager] removeItemAtPath:myPath error:nil];
            
        }]];
        [actionsheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }]];
        [self presentViewController:actionsheet animated:YES completion:nil];
    } else {
        AboutViewController *avc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:avc animated:YES];
    }
}

//获取所有缓存大小
- (CGFloat)getCacheSize {
    //缓存 有两类 sdwebimage 还有 每个界面保存的缓存
    CGFloat sdSize = [[SDImageCache sharedImageCache] getSize];
    NSString *myPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyCaches"];
    //获取文件夹中的所有的文件
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myPath error:nil];
    unsigned long long size = 0;
    for (NSString *fileName in arr) {
        NSString *filePath = [myPath stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += dict.fileSize;
    }
    //1M = 1024 K = 1024*1024字节
    CGFloat totalSize = (sdSize+size)/1024.0/1024.0;
    return totalSize;
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
