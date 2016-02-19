//
//  BreakPointDownload.m
//  BreadPointDownload
//
//  Created by lzxuan on 15/10/16.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "BreakPointDownload.h"
#import "NSString+Hashing.h"

@interface BreakPointDownload ()

@property (nonatomic, strong)NSFileHandle *fileHandle;

@end

@implementation BreakPointDownload

- (void)breakPointDownloadDataWithUrl:(NSString *)url downloadProcess:(DownloadBlock)myBlock {
    self.myBlock = myBlock;
    NSString *filePath = [self getFullFilePathWithUrl:url];

    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist) {
        self.loadedSize = 0;
        //没有就创建新的空文件
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        //有 要获取已经下载的文件大小
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        self.loadedSize = fileDict.fileSize;
    }
    //打开文件
    _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    //发送下载请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //断点下载 应该 告知 服务器 从哪一字节开始下载
    //通过请求头 发给 服务器 (前提 服务器 必须要支持断点续传)
    //增加请求头 Range头
    [request addValue:[NSString stringWithFormat:@"bytes=%llu-",self.loadedSize] forHTTPHeaderField:@"Range"];
    //启动一个线程 进行请求下载
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
#pragma mark - NSURLConnectionDataDelegate
//服务器给客户端响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //服务器告知 客户端 要发数据了 还会告诉发送的大小(文件 剩余的大小)
    NSLog(@"len:%llu",response.expectedContentLength);
    //计算文件 总大小
    self.fileSize = self.loadedSize+response.expectedContentLength;
}
//服务发送数据的时候 回调
//一段一段发送
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //下载过程 要把data 写到本地沙盒
    [_fileHandle seekToEndOfFile];//定位到文件尾
    [_fileHandle writeData:data];
    [_fileHandle synchronizeFile];//同步到磁盘
    //文件 已经下载大小
    self.loadedSize += data.length;
    
    //回调block 把 大小传给对方
    if (self.myBlock) {
        self.myBlock(self);
    }
}
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self stopDownload];
}
//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self stopDownload];
}
- (void)stopDownload {
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    [_fileHandle closeFile];//关闭文件
}




//获取在沙盒中的全路径
- (NSString *)getFullFilePathWithUrl:(NSString *)urlname {
    NSString * name = [urlname MD5Hash];
    //获取在沙盒中的路径
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp4",name];
    return path;
}

@end









