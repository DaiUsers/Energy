//
//  VideoView.h
//  CustomMoviePlayer
//
//  Created by LZXuan on 15-1-13.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>//AVPlayer在里面

/*
 AVPlayer 进行播放要依赖于一个视图，一般在视图的layer层进行播放
 AVPlayer -》进行播放一些视频格式 包括 mp4 wov avi 还有网络的视频 流媒体 m3u8 视频流
 */
@interface VideoView : UIView
//把 player  传给 view 的layer层
- (void)setVideoViewWithPlayer:(AVPlayer *)player;
@end





