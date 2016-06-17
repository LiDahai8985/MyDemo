//
//  MMMediaRequestTask.h
//  MyDemo
//
//  Created by LiDaHai on 16/6/17.
//  Copyright © 2016年 LiDaHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMMediaRequestTask;
@protocol MMMediaRequestTaskDelegate <NSObject>

- (void)task:(MMMediaRequestTask *)task didReceiveMediaLength:(NSUInteger)mediaLength mimeType:(NSString *)mimeType;
- (void)taskDidReceiveMediaData:(MMMediaRequestTask *)task;
- (void)taskDidFinishLoading:(MMMediaRequestTask *)task;
- (void)taskDidFailLoading:(MMMediaRequestTask *)task WithError:(NSInteger )errorCode;

@end



@interface MMMediaRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL                           *url;

/**
 *  当前正在请求的request起始位置
 */
@property (nonatomic, assign, readonly) NSUInteger                      offset;


@property (nonatomic, strong, readonly) NSString                        *mimeType;

/**
 *  当前请求文件的总长度
 */
@property (nonatomic, assign, readonly) NSUInteger                      mediaLength;

/**
 *  当前正在请求的request已经缓存到的数据
 */
@property (nonatomic, assign, readonly) NSUInteger                      downLoadingOffset;

/**
 *  是否已经缓存完成
 */
@property (nonatomic, assign          ) BOOL                            isFinishLoad;
@property (nonatomic, weak            ) id <MMMediaRequestTaskDelegate> m_delegate;


- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@end
