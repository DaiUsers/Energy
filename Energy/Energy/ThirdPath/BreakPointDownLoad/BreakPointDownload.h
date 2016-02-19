//
//  BreakPointDownload.h
//  BreadPointDownload
//
//  Created by lzxuan on 15/10/16.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//前向引用声明
@class BreakPointDownload;

typedef void(^DownloadBlock)(BreakPointDownload * download);
//专门 封装一个类 用于 断点 下载

@interface BreakPointDownload : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

//已经下载的大小
@property (nonatomic,assign) unsigned long long loadedSize;
//文件总大小
@property (nonatomic,assign) unsigned long long fileSize;

@property (nonatomic,copy) DownloadBlock myBlock;

//进行 断点 下载 请求
//下载过程中 进行回调block
- (void)breakPointDownloadDataWithUrl:(NSString *)url downloadProcess:(DownloadBlock)myBlock;

//停止下载
- (void)stopDownload;

@end













