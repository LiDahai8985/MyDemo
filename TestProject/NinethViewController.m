//
//  NinethViewController.m
//  MyDemo
//
//  Created by LiDaHai on 17/2/20.
//  Copyright © 2017年 douchuanjiang. All rights reserved.
//

#import "NinethViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeMaskView.h"

@interface NinethViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL isLighting; //是否已经开启日光灯

@end

@implementation NinethViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    
    QRCodeMaskView *maskView = [[QRCodeMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:maskView];
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 50, 65, 35);
    [flashBtn setTitle:@"日光灯" forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(flashSwitchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    UIButton *imageQrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageQrBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 240, 50, 145, 35);
    [imageQrBtn setTitle:@"图片二维码识别" forState:UIControlStateNormal];
    [imageQrBtn addTarget:self action:@selector(findQRCodeFromImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageQrBtn];
    
}


- (AVCaptureSession *)session
{
    if (!_session) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
        if (!input) {
            return nil;
        }
    
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        CGFloat width = 300/CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat height = 300/CGRectGetWidth([UIScreen mainScreen].bounds);
        output.rectOfInterest = CGRectMake((1- width)/2, (1-height)/2, width, height);
        
        _session = [[AVCaptureSession alloc] init];
        [_session addInput:input];
        [_session addOutput:output];
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeEAN13Code];
    }
    return _session;
}

#pragma mark- 直接识别图片中的二维码
- (void)findQRCodeFromImage:(UIImage *)image
{
    image = [UIImage imageNamed:@"IMG_2201"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *featureArray = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (featureArray) {
        for (CIQRCodeFeature *feature in featureArray) {
            if (feature) {
                NSLog(@"------图片识别结果------\n%@",feature.messageString);
            }
        }
    }
}


#pragma mark-  实时扫描结果处理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects) {
        [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataMachineReadableCodeObject *metadataObject, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"---扫描结果---->\n%@",metadataObject.stringValue);
            if (idx == metadataObjects.count - 1) {
                [self.session stopRunning];
            }
        }];
    }
}

#pragma mark- 开启闪光灯
- (void)flashSwitchHandler
{
    self.isLighting = !self.isLighting;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        
        device.torchMode = self.isLighting?AVCaptureTorchModeOn:AVCaptureTorchModeOff;
        device.flashMode = self.isLighting?AVCaptureFlashModeOn:AVCaptureFlashModeOff;
        
        [device unlockForConfiguration];
    }
}
@end
