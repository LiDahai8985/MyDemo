//
//  AppDelegate.m
//  TestProject
//
//  Created by douchuanjiang on 16/4/18.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()
{
    NSInteger count;
    UIBackgroundTaskIdentifier bgTaskId;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //打开音频会话
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    //接受远程的控制通知
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    
    return YES;
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        return UIInterfaceOrientationMaskAll;
//    else  /* iphone */
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //开始后台任务
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        
//    }];
    
    NSLog(@"applicationDidEnterBackground");
    
    //启动一个后台任务[默认生命周期600s]
}

//- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
//    if (event.type == UIEventTypeRemoteControl) {
//        switch (event.subtype) {
//            case UIEventSubtypeRemoteControlPlay:
//                NSLog(@"远程控制--播放");
//                break;
//            case UIEventSubtypeRemoteControlPause:
//                NSLog(@"远程控制--暂停");
//                break;
//            case UIEventSubtypeRemoteControlStop:
//                NSLog(@"远程控制--停止");
//                break;
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//            {
//                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
//                MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
//                
//                NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithCapacity:0];
//                playingInfo[MPMediaItemPropertyTitle] = @"测试歌曲111";
//                playingInfo[MPMediaItemPropertyArtist] = @"淋漓尽致";
//                playingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"3"]];
//                playingInfo[MPMediaItemPropertyPlaybackDuration] = @"271";
//                playingInfoCenter.nowPlayingInfo = playingInfo;
//            }
//                break;
//            case UIEventSubtypeRemoteControlNextTrack:
//                NSLog(@"远程控制--下一首");
//                break;
//            case UIEventSubtypeRemoteControlPreviousTrack:
//                NSLog(@"远程控制--上一首");
//                break;
//            case UIEventSubtypeRemoteControlBeginSeekingForward:
//                NSLog(@"远程控制--开始快进");
//                break;
//            case UIEventSubtypeRemoteControlEndSeekingForward:
//                NSLog(@"远程控制--停止快进");
//                break;
//            case UIEventSubtypeRemoteControlBeginSeekingBackward:
//                NSLog(@"远程控制--快退");
//                break;
//            case UIEventSubtypeRemoteControlEndSeekingBackward:
//                NSLog(@"远程控制--停止快退");
//                break;
//            default:
//                break;
//        }
//    }
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
