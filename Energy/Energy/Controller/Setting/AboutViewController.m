//
//  AboutViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/9.
//  Copyright © 2015年 wheng. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.content.text = @"为传递向上正能量而敢想！\n\nOpen your eyes Open your heart !\n\n收藏、下载项左滑删除\n\n浏览内容自动缓存(不包括下载),所以请定期清理缓存";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HD5.5" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    backView.image = image;
    [self.view insertSubview:backView atIndex:0];
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

@end
