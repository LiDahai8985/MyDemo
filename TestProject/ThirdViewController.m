//
//  ThirdViewController.m
//  TestProject
//
//  Created by LiDaHai on 16/5/16.
//  Copyright © 2016年 douchuanjiang. All rights reserved.
//

#import "ThirdViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MMPlayerView.h"

@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger count;
}

@property (strong, nonatomic) MMPlayerView *mmPlayer;
@property (strong, nonatomic) NSMutableArray *musicListArray;

@end

@implementation ThirdViewController

- (void)dealloc
{
    [_mmPlayer clear];
    self.mmPlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allowSwipOut = YES;
    self.title = @"ThirdViewController";
    
    self.musicListArray = [[NSMutableArray alloc] initWithObjects:
                           @"http://yinyueshiting.baidu.com/data2/music/124645382/440262194400128.mp3?xcode=6107a9895b5b03693d7cab37c0a62272",
                            @"http://yinyueshiting.baidu.com/data2/music/0a0e25790c3a5773257927b5a2e11426/260489222/260489119111600128.mp3?xcode=3791a86f4bebb014c7d4e558c0a93524",
                           @"http://yinyueshiting.baidu.com/data2/music/86bc4ece9550d99b19c947dbf231aecc/267447553/26744746739600128.mp3?xcode=ac00937ba9f9e74d86c86b4d2d72cc37",
                          nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(msg_routeChangeNotification:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    
    
}

- (MMPlayerView *)mmPlayer {
    if (!_mmPlayer) {
        _mmPlayer = [MMPlayerView sharePlayer];
        _mmPlayer.frame = CGRectMake(0, 450, 414, 414*9/16);
    }
    return _mmPlayer;
}


- (IBAction)playMusic:(id)sender {
    
    if (!self.mmPlayer.superview) {
        count = 0;
        NSURL *musicUrl = [NSURL URLWithString:[self.musicListArray objectAtIndex:0]];
        
        NSString *string = [NSString stringWithFormat:@"%@",[self.musicListArray objectAtIndex:0]];
        NSArray *array = [string componentsSeparatedByString:@"/"];
        NSString *identifierStr = [[NSString stringWithFormat:@"%@",[array lastObject]] substringToIndex:10];
        
        [self.mmPlayer setMediaURL:musicUrl identifier:[NSString stringWithFormat:@"%@.mp3",identifierStr]];
        [self.view addSubview:self.mmPlayer];
    }
    NSLog(@"开始播放");
}

- (IBAction)nextMusic:(id)sender {
    count ++;
    
    NSURL *musicUrl = [NSURL URLWithString:[self.musicListArray objectAtIndex:count%3]];
    
    NSString *string = [NSString stringWithFormat:@"%@",[self.musicListArray objectAtIndex:count%3]];
    NSArray *array = [string componentsSeparatedByString:@"/"];
    NSString *identifierStr = [[NSString stringWithFormat:@"%@",[array lastObject]] substringToIndex:10];
    
    [self.mmPlayer setMediaURL:musicUrl identifier:[NSString stringWithFormat:@"%@.mp3",identifierStr]];
    
}


- (IBAction)previousMusic:(id)sender {
    if (count == 0) {
        count = self.musicListArray.count - 1;
    }
    else {
        count --;
    }
    
    NSURL *musicUrl = [NSURL URLWithString:[self.musicListArray objectAtIndex:count%3]];
    
    NSString *string = [NSString stringWithFormat:@"%@",[self.musicListArray objectAtIndex:count%3]];
    NSArray *array = [string componentsSeparatedByString:@"/"];
    NSString *identifierStr = [[NSString stringWithFormat:@"%@",[array lastObject]] substringToIndex:10];
    
    [self.mmPlayer setMediaURL:musicUrl identifier:[NSString stringWithFormat:@"%@.mp3",identifierStr]];
}

- (IBAction)presentAViewController:(id)sender {
    ThirdViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdViewController class])];
    [self.navigationController presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction) dismiss:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"12345" object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark-

//远程控制通知方法
- (void)msg_routeChangeNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    AVAudioSessionRouteChangeReason changeReason = [dic[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription  *portDescription = [routeDescription.outputs firstObject];
        
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self.mmPlayer mmPlayerPause];
        }
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"远程控制--播放");
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"远程控制--暂停");
                break;
            case UIEventSubtypeRemoteControlStop:
                NSLog(@"远程控制--停止");
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"远程控制--下一首");
                [self nextMusic:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"远程控制--上一首");
                [self previousMusic:nil];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"远程控制--开始快进");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"远程控制--停止快进");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"远程控制--快退");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"远程控制--停止快退");
                break;
            default:
                break;
        }
    }
}
#pragma mark- UITabelViewDalegate  && UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ThirdViewControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld秒",(indexPath.row+1)*6];
    cell.textLabel.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"选择了%@",cell.textLabel.text);
    
    if (self.t_delegate && [self.t_delegate respondsToSelector:@selector(didSelectTime:)]) {
        [self.t_delegate didSelectTime:(indexPath.row+1)*6];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark-

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
