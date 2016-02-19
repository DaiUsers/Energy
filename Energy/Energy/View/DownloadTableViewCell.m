//
//  DownloadTableViewCell.m
//  Energy
//
//  Created by qianfeng on 15/11/7.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "BreakPointDownload.h"

@interface DownloadTableViewCell ()

@property (nonatomic, strong) NSTimer *timer;
//保存上一次的下载大小
@property (nonatomic,assign) unsigned long long preLoadedSize;
//当前已经下载的大小
@property (nonatomic,assign) unsigned long long loadedSize;
@property (nonatomic,assign) double speed;//速度

@property (nonatomic,strong) BreakPointDownload *download;
@property (nonatomic,copy  ) NSString *downUrl;
@property (nonatomic,assign) BOOL isRunging;

@end

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.download = [[BreakPointDownload alloc] init];
    _isRunging = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"];
    [self.play setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
}

- (void)getSliderValue:(NSString *)url {

    if (_downUrl != url) {
        self.downUrl = url;
        
    }
    double scale = [[NSUserDefaults standardUserDefaults] doubleForKey:self.downUrl];

    self.progress.progress = scale;
}

- (IBAction)cancelAction:(id)sender {
    
    if (_isRunging == NO) {
        return;
    }
    
    _isRunging = NO;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.download stopDownload];
}

- (IBAction)startAction:(id)sender {
    
    if (_isRunging) {
        return;
    }
    _isRunging = YES;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getSpeed) userInfo:nil repeats:YES];
    }
    
    __weak typeof(self)weakSelf = self;
    
    [self.download breakPointDownloadDataWithUrl:self.downUrl downloadProcess:^(BreakPointDownload *download) {
        //保存已经下载大小
        weakSelf.loadedSize = download.loadedSize;
        
        //下载过程中 会 回调 这个block
        double fileSize = download.fileSize/1024.0/1024.0;//M
        double scale = ((double)download.loadedSize)/download.fileSize;
        weakSelf.progress.progress = scale;
        
        //把这个进度 保存的本地
        [[NSUserDefaults standardUserDefaults] setDouble:scale forKey:self.downUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (scale >= 1.0) {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            //销毁定时器
        }
        weakSelf.label.text = [NSString stringWithFormat:@"%.2f%%/%.2fM  %.2fKB/S",scale*100,fileSize,weakSelf.speed];
    }];

}

- (void)getSpeed {
    //当前的已经下载大小 - 前1s 已经下载大小
    self.speed = (self.loadedSize-self.preLoadedSize)/1024.0;
    //保存
    self.preLoadedSize = self.loadedSize;

}
- (IBAction)play:(id)sender {
    NSLog(@"??");
    if (_delegate && [_delegate respondsToSelector:@selector(cellClicked:)]) {
        [_delegate cellClicked:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
