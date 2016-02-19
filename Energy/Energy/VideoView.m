//
//  VideoView.m
//  CustomMoviePlayer
//
//  Created by LZXuan on 15-1-13.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//确保返回的layer 符合AVPlayerLayer
//当我们调用 self.layer 会自定 调用下面的方法
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setVideoViewWithPlayer:(AVPlayer *)player {
    AVPlayerLayer *layer =  (AVPlayerLayer *)self.layer;
     //AVPlayerLayer 进行视频播放的层(显示视频的画面)
    //把传入 的player 给 AVPlayerLayer
    [layer setPlayer:player];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
