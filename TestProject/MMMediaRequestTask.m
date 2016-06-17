//
//  MMMediaRequestTask.m
//  MyDemo
//
//  Created by LiDaHai on 16/6/17.
//  Copyright © 2016年 LiDaHai. All rights reserved.
//

#import "MMMediaRequestTask.h"
#import <AVFoundation/AVFoundation.h>

@interface  MMMediaRequestTask () <NSURLConnectionDelegate,AVAssetResourceLoaderDelegate>


@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray  *taskArr;

@property (nonatomic, assign) BOOL            once;

//文件管理
@property (nonatomic, strong) NSFileHandle    *fileHandle;

//缓存暂时保存路径
@property (nonatomic, strong) NSString        *tempPath;

@end

@implementation MMMediaRequestTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskArr = [NSMutableArray array];
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _tempPath =  [document stringByAppendingPathComponent:@"temp.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_tempPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
            [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
            
        } else {
            [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
        }
        
    }
    return self;
}

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset
{
    _url = url;
    _offset = offset;
    
    //如果建立第二次请求，先移除原来文件，再创建新的
    if (self.taskArr.count > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    
    _downLoadingOffset = 0;
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    //offset不为0，则从指定位置开始缓存
    if (offset > 0 && self.mediaLength > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)self.mediaLength - 1] forHTTPHeaderField:@"Range"];
    }
    
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
    
}



- (void)cancel
{
    [self.connection cancel];
}

- (void)continueLoading
{
    _once = YES;
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_downLoadingOffset, (unsigned long)self.mediaLength - 1] forHTTPHeaderField:@"Range"];
    
    
    [self.connection cancel];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
}

- (void)clearData
{
    [self.connection cancel];
    //移除文件
    [[NSFileManager defaultManager] removeItemAtPath:_tempPath error:nil];
}



#pragma mark -  NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _isFinishLoad = NO;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger tmpMediaLength;
    
    if ([length integerValue] == 0) {
        tmpMediaLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        tmpMediaLength = [length integerValue];
    }
    
    _mediaLength = tmpMediaLength;
    _mimeType = @"video/mp4";
    
    
    if ([self.m_delegate respondsToSelector:@selector(task:didReceiveMediaLength:mimeType:)]) {
        [self.m_delegate task:self didReceiveMediaLength:self.mediaLength mimeType:self.mimeType];
    }
    
    [self.taskArr addObject:connection];
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.fileHandle seekToEndOfFile];
    
    [self.fileHandle writeData:data];
    
    _downLoadingOffset += data.length;
    
    
    if ([self.m_delegate respondsToSelector:@selector(taskDidReceiveMediaData:)]) {
        [self.m_delegate taskDidReceiveMediaData:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.taskArr.count < 2) {
        _isFinishLoad = YES;
        
        //这里自己写缓存好之后的完整文件需要保存的路径
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *movePath =  [document stringByAppendingPathComponent:@"/保存数据.mp4"];
        
        BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:_tempPath toPath:movePath error:nil];
        if (isSuccess) {
            //NSLog(@"rename success");
        }else{
            //NSLog(@"rename fail");
        }
        //NSLog(@"----%@", movePath);
    }
    
    if ([self.m_delegate respondsToSelector:@selector(taskDidFinishLoading:)]) {
        [self.m_delegate taskDidFinishLoading:self];
    }
}

/**
 *  请求发生错误
 *
 *  @param connection      当前的请求
 *  @param error  网络中断-1005  无网络连接-1009  请求超时-1001 服务器内部错误-1004 找不到服务器-1003
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error.code == -1001 && !_once) {      //网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self continueLoading];
        });
    }
    if ([self.m_delegate respondsToSelector:@selector(taskDidFailLoading:WithError:)]) {
        [self.m_delegate taskDidFailLoading:self WithError:error.code];
    }
    if (error.code == -1009) {
        NSLog(@"无网络连接");
    }
}


@end
