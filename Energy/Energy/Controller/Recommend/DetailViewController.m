//
//  DetailViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/6.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreMedia/CoreMedia.h>
#import "WHMPMoviePlayerView.h"
#import "FavoriteViewController.h"
#import "DBManager.h"
#import "DownloadViewController.h"

#import "UMSocial.h"

@interface DetailViewController () <UMSocialUIDelegate>

@property (strong, nonatomic) WHData *model;
@property (assign, nonatomic) BOOL isPlay;

@property (strong, nonatomic) WHMPMoviePlayerView *mp;
@property (strong, nonatomic) UIButton *fullButton;

@end

@implementation DetailViewController

- (id)initWithDataModel:(WHData *)model {
    self = [super init];
    if (self) {
        _model = model;
        _isPlay = NO;
    }
    return self;
}


//时间计算
- (NSString *)getDuration:(NSNumber *)duration {
    NSInteger num = [duration integerValue];
    NSInteger minute = num / 60;
    NSInteger second = num % 60;
    NSString *str = [NSString stringWithFormat:@"%ld'%ld\"",minute,second];
    return str;
}

- (void)createView {
    //按钮的title
    NSString *dataId = [self.model.dataId stringValue];
    BOOL isExist = [[DBManager sharedManager] isExistDataForDataId:dataId recordType:@"favorite"];
    if (isExist) {
        [self.love setTitle:@"取消收藏" forState:UIControlStateNormal];
    } else {
        [self.love setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
    [self.share setTitle:@"分享" forState:UIControlStateNormal];
    [self.down setTitle:@"下载" forState:UIControlStateNormal];
    
    NSString *place = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"png"];
    //背景图
    if (self.model.cover == nil) {//收藏
        [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.detail] placeholderImage:[UIImage imageWithContentsOfFile:place]];
        [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:self.model.blurred] placeholderImage:nil];
    } else {
        [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.cover.detail] placeholderImage:[UIImage imageWithContentsOfFile:place]];
        [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:self.model.cover.blurred] placeholderImage:nil];

    }
    
    self.backImage.userInteractionEnabled = YES;
    self.bottomImage.userInteractionEnabled = YES;
    
    [_headTitle setText:_model.title];
    self.desc.text = _model.desc;
    self.time.text = [self getDuration:_model.duration];
    self.category.text = self.model.category;
    
//手势    [self createTap];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    [play setFrame:CGRectMake(ScreenWidth / 2 - 40, ScreenHeight / 2 - 140, 80, 80)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
    [play setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [play addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backImage addSubview:play];
}

//手势
- (void)createTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.backImage addGestureRecognizer:tap];
}

//
- (void)tapAction {
    if (_mp) {
        [_mp.moviePlayer stop];
        _mp = nil;
    }
    //注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    NSURL *url = [NSURL URLWithString:self.model.playUrl];
    _mp = [[WHMPMoviePlayerView alloc] initWithContentURL:url];
    //根据屏幕大小填充
    _mp.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    //模态跳转
    [self presentViewController:_mp animated:YES completion:nil];
    
    //准备播放
    [_mp.moviePlayer prepareToPlay];
    [_mp.moviePlayer play];
}

#pragma mark - 视频

- (BOOL)shouldAutorotate {
    return YES;
}
//只支持竖屏 当前界面
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//点击 done 或者 播放完通知
- (void)playBack:(NSNotification *)nf {
    NSLog(@"播放完毕");
    if (_mp) {
        [_mp.moviePlayer stop];
        _mp = nil;
    }
    //删除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 下载
- (IBAction)downAction:(id)sender {
    NSString *dataId = [self.model.dataId stringValue];
    BOOL isExist = [[DBManager sharedManager] isExistDataForDataId:dataId recordType:@"download"];
    if (isExist) {
        NSLog(@"已经下载过了");
    } else {
        [[DBManager sharedManager] insertModel:self.model recordType:@"download"];
    }
    DownloadViewController *dvc = [[DownloadViewController alloc] init];
    [self.navigationController pushViewController:dvc animated:YES];
}
//分享
- (IBAction)shareAction:(id)sender {
    
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]]; //这个接口只对默认分享面板平台有隐藏功能，自定义分享面板或登录按钮需要自己处理
    
    
    
    NSString *picUrl   = self.model.feed;
    NSString *videoUrl = self.model.playUrl;

    //点击分享内容跳转连接
    //微信
    [UMSocialData defaultData].extConfig.wechatSessionData.url = videoUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = videoUrl;
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = videoUrl;
    //qqZone
    [UMSocialData defaultData].extConfig.qzoneData.url = videoUrl;

    //分享url 图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:picUrl];
    //分享URL 视频
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:videoUrl];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"563f3532e0f55a0a7e009928"
                                      shareText:self.model.title
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
}
//收藏
- (IBAction)loveAction:(UIButton *)sender {
    
    
    
    NSString *dataId = [self.model.dataId stringValue];
    BOOL isExist = [[DBManager sharedManager] isExistDataForDataId:dataId recordType:@"favorite"];
    if (isExist) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消成功" message:@"Success" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [[DBManager sharedManager] deleteModelForDataId:dataId recordType:@"favorite"];
        [sender setTitle:@"收藏" forState:UIControlStateNormal];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:@"Success" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [[DBManager sharedManager] insertModel:self.model recordType:@"favorite"];
        [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
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
