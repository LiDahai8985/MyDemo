//
//  MMResourceLoaderURLConnection.h
//  MyDemo
//
//  Created by LiDaHai on 16/6/17.
//  Copyright © 2016年 LiDaHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MMMediaRequestTask.h"

@protocol MMResourceLoaderURLConnectionDelegate <NSObject>

- (void)loaderDidFinishLoadingWithTask:(MMMediaRequestTask *)task;

/**
 *  请求发生错误
 *
 *  @param task       当前的请求任务
 *  @param errorCode  网络中断-1005  无网络连接-1009  请求超时-1001 服务器内部错误-1004 找不到服务器-1003
 */
- (void)loaderDidFailLoadingWithTask:(MMMediaRequestTask *)task WithError:(NSInteger )errorCode;

@end


@interface MMResourceLoaderURLConnection : NSURLConnection<AVAssetResourceLoaderDelegate,MMMediaRequestTaskDelegate>

@property (nonatomic, strong) MMMediaRequestTask                        *task;
@property (nonatomic, weak  ) id<MMResourceLoaderURLConnectionDelegate> m_delegate;

- (NSURL *)getSchemeVideoURL:(NSURL *)url;

@end


