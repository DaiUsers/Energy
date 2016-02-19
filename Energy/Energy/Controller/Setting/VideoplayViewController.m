//
//  VideoplayViewController.m
//  Energy
//
//  Created by qianfeng on 15/11/7.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "VideoplayViewController.h"
#import <CoreMedia/CoreMedia.h>
#import "VideoView.h"

@interface VideoplayViewController ()

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) VideoView *videoView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation VideoplayViewController

- (id)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BlackColor;
    [self playVideo];
}

- (void)createView {
    _videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 10, ScreenHeight, ScreenWidth - 50)];
    _videoView.backgroundColor = BlackColor;
    [self.view addSubview:_videoView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(LeftDistance, ScreenWidth - 40, ScreenHeight - 20, 20)];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    NSArray *arr = @[@"播放",@"暂停"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(ScreenHeight / 5 *(i + 2) - 20, ScreenWidth - 20, 50, 20);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        button.tag = 101+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

    UIButton *back = [Factory createButtonWithTitle:@"Back" frame:CGRectMake(LeftDistance, LeftDistance, 40, 30) target:self selector:@selector(backAction)];
    back.backgroundColor = [UIColor clearColor];
    [self.view addSubview:back];
    
    
}

#pragma mark - button

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 101:
            [self playVideo];
            break;
        case 102:
            [self pauseVideo];
            break;
        default:
            break;
    }
}


#pragma mark - UISlider
- (void)sliderClick:(UISlider *)slider {
    if (_player) {
        //通过 slider 当前进度 修改 视频的播放进度
        //根据进度 算出当前的时间
        //CMTimeMultiplyByFloat64 根据当前进度值和总时间转换成CMTime 视频时间
        //跳转到指定时间seekToTime
        [_player seekToTime:CMTimeMultiplyByFloat64(_player.currentItem.duration, slider.value)];
    }
}

#pragma mark - 暂停视频
- (void)pauseVideo {
    if (_player) {
        //暂停
        [_player pause];
    }
}

- (void)playVideo {
    if (_player) {
        [_player play];//如果正在播放 又点击播放 是没有影响的
        return;
    }
    
    //本地的
    [self loadVideoFromPath:self.path];
    //网络视频 m3u8格式
    
    //[self loadVideoFromPath:kMediaPath];
    
}
//VLC
- (void)loadVideoFromPath:(NSString *)path {
    if (path.length == 0) {
        NSLog(@"没有视频资源");
        return;
    }
    //区分 网络资源
    NSURL *url = nil;
    if ([path hasPrefix:@"http://"]||[path hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:path];
    }else {
        NSLog(@"file");
        url = [NSURL fileURLWithPath:path];
    }
    
    //1.AVAsset 里面保存了视频的所有信息
    //[AVAsset assetWithURL:url] 获取 url 对应的视频的信息
    //对视频进行预加载  获取 视频的信息 和视频的参数
    AVAsset *set = [AVAsset assetWithURL:url];
    
    //2.预加载 视频 通过  @"tracks"获取预加载信息
    
    [set loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        //1. 通过 @"tracks" 获取当前视频预加载视频的状态
        AVKeyValueStatus status =  [set statusOfValueForKey:@"tracks" error:nil];
        //2.判断是或否预加载完成
        //AVKeyValueStatusLoaded预加载完成
        if (status == AVKeyValueStatusLoaded) {
            //3.AVPlayerItem 视频的一个具体的项目，包括视频的进度 视频的总时间， 视频的类型
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:set];
            //4.通过item 创建一个音乐播放器
            //_player通过item 就可以获取 当前视频的信息
            _player = [[AVPlayer  alloc] initWithPlayerItem:item];
            
            //5.把_player放在videoView的layer层
            //专门播放视频的层
            [_videoView setVideoViewWithPlayer:_player];
            //6.播放
            [_player play];
            
            /*
             下面我们要通过视频的播放时间来控制器slider
             1.可以用定时器 来控制 每个一段时间 去修改
             2.用_player自带的 线程进行获取当前时间 去修改slider
             //下面我们采用第二种
             //CMTime 视频的时间结构体 里面保存时间
             CMTimeMake(1.0, 1.0) 产生一个 CMTime结构体
             表示的每隔1s
             两个 1.0表示 帧率 和 帧数   帧数/帧率-->时间
             */
            
            /*
             起一个线程 每隔1s 获取一下当前视频的状态
             用gcd 的全局队列 增加一个异步的任务
             */
            
            __weak AVPlayer *blockPlayer = _player;
            __weak UISlider *blockSlider = _slider;
            //因为 当前对象 强引用了 _player -》player有对 block进行了强引用
            //block 在使用的时候 内部进行copy ，如果出现对self 或者 self 成员变量进行操作 这时会对这些值进行拷贝
            //这样就造成了两个强引用 导致死锁
            //这时为了解决这个问题 arc下 我们可以自 block 外面用__weak 产生一个新的变量 弱引用 self 或者 成员变量 这样block 内部就不会对 self 和他的成员变量进行拷贝操作 一强一弱 不会导致死锁
            
            [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^(CMTime time) {
                //从视频项目中获取当前时间
                
                CMTime t1 = blockPlayer.currentTime;
                //从视频项目中获取视频总时间
                CMTime t2 = blockPlayer.currentItem.duration;
                //CMTimeGetSeconds 把一个CMTime 转化成秒
                float currentTimer = CMTimeGetSeconds(t1);
                float total = CMTimeGetSeconds(t2);
                //算出 进度
                float progressCur = currentTimer/total;
                //当前这个代码是子线程调用的
                //通知主线程 来刷新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程 刷新UI
                    blockSlider.value = progressCur;
                });
                
            }];
        }
    }];
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
