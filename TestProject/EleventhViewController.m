//
//  EleventhViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/3/13.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "EleventhViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#define MMCacheFilePath(fileName) \
[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject],fileName]

@interface EleventhViewController ()<UIImagePickerControllerDelegate,PHLivePhotoViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView     *leftImgView;
@property (nonatomic, weak) IBOutlet UIImageView     *rightImgView;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, strong) NSString *leftImgFileName;
@property (nonatomic, strong) NSString *rightVideoFileName;
@property (nonatomic, assign) BOOL left;
@end

@implementation EleventhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.livePhotoView = [[PHLivePhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.livePhotoView.delegate = self;
    [self.view addSubview:self.livePhotoView];
    [self.view sendSubviewToBack:self.livePhotoView];
}

- (IBAction)selectImgOrVideoFromLibrary:(id)sender
{
    NSString *buttonTitle = ((UIButton *)sender).titleLabel.text;
    self.left = [buttonTitle rangeOfString:@"图片"].length > 0;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 需导入<MobileCoreServices/MobileCoreServices.h> 才能用
    pickerController.mediaTypes = self.left?@[(NSString*)kUTTypeImage]:@[(NSString *)kUTTypeMovie];
    pickerController.delegate = self;
    
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

// 合成图片
- (IBAction)makeLivePhoto:(id)sender
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadingView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    loadingView.hidesWhenStopped = YES;
    [loadingView startAnimating];
    [self.view addSubview:loadingView];
    NSURL *imgUrl = [NSURL fileURLWithPath:MMCacheFilePath(self.leftImgFileName)];
    NSURL *videoUrl = [NSURL fileURLWithPath:MMCacheFilePath(self.rightVideoFileName)];
    [PHLivePhoto requestLivePhotoWithResourceFileURLs:@[imgUrl, videoUrl]
                                     placeholderImage:nil
                                           targetSize:[UIScreen mainScreen].bounds.size
                                          contentMode:PHImageContentModeAspectFill
                                        resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
                                            if (livePhoto) {
                                                [self.livePhotoView setLivePhoto:livePhoto];
//                                                [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
                                                [loadingView stopAnimating];
                                                [loadingView removeFromSuperview];
                                            }
                                        }];
}

// 保存图片
- (IBAction)saveLivePhoto:(id)sender
{
    //PHLivePhotoView
    NSURL *photoURL = [NSURL fileURLWithPath:MMCacheFilePath(self.leftImgFileName)];
    NSURL *videoURL = [NSURL fileURLWithPath:MMCacheFilePath(self.rightVideoFileName)];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
        [request addResourceWithType:PHAssetResourceTypePhoto fileURL:photoURL options:nil];
        [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:videoURL options:nil];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"livePhotoSave:success? %d, error: %@",success,error);
    }];
}

#pragma mark- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    PHAsset *photoAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[info[UIImagePickerControllerReferenceURL]] options:nil] firstObject];
    NSString *photoAssetIdentifier = [photoAsset.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:@""];
    // 选中图片处理
    if (self.left) {
        UIImage  *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.leftImgView.image = image;
        self.leftImgFileName = [NSString stringWithFormat:@"%@.png",photoAssetIdentifier];
        
        // 图片放到本地沙盒
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:MMCacheFilePath(self.leftImgFileName) atomically:YES];
        
    } else {
        // 选中视频处理
        [[PHImageManager defaultManager] requestImageForAsset:photoAsset
                                                   targetSize:self.rightImgView.frame.size
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    self.rightImgView.image = result;
                                                }];
        self.rightVideoFileName = [NSString stringWithFormat:@"%@.mov",photoAssetIdentifier];;
        
        //转换视频
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:info[UIImagePickerControllerMediaURL] options:nil];
        AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName: AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:MMCacheFilePath(self.rightVideoFileName)];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            if (exportSession.status == AVAssetExportSessionStatusCompleted)
            {
                //转换完成
            }
            else if (exportSession.status == AVAssetExportSessionStatusWaiting)
            {
                //正在等待
            }
            else if (exportSession.status == AVAssetExportSessionStatusExporting)
            {
                //正在等待
            }
            else
            {
                //失败
            }
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- PHLivePhotoViewDelegate

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    
}
@end
