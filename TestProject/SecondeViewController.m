//
//  SecondeViewController.m
//  TestProject
//
//  Created by douchuanjiang on 16/5/6.
//  Copyright (c) 2016年 douchuanjiang. All rights reserved.
//

#import "SecondeViewController.h"
#import "MMNavigationController.h"
#import "ThirdViewController.h"
#import <StoreKit/StoreKit.h>


#import "HalfPageScrollView.h"

#define ITMS_SANDBOX_VERIFY_RECEIPT_URL @"https://sandbox.itunes.apple.com/verifyReceipt"

@interface SecondeViewController ()<UITextFieldDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,ThirdSelectTimeDelegate>
{
    NSInteger autoCloseAppTimeDurarion;
    dispatch_source_t _timer;
}

@property (strong, nonatomic) IBOutlet UITextField  *productId;
@property (strong, nonatomic) IBOutlet UIButton     *commitBtn;
@property (strong, nonatomic) IBOutlet UIButton     *selectTimeBtn;
@property (nonatomic, strong) HalfPageScrollView    *halfScrollView;

@end

@implementation SecondeViewController

- (void)dealloc {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    _productId = nil;
    _commitBtn = nil;
    _selectTimeBtn = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.allowSwipOut = NO;
    self.title = @"SecondViewController";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.6 blue:0.5 alpha:1.0];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 200/2, CGRectGetHeight(self.view.frame) - 100, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"SecondeViewController";
    [self.view addSubview:label];
    
    // 注册内购事件响应监听
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.productId.text = @"com.lljz.token300";
    
    // 添加半屏滚动scrollView
    [self.view addSubview:self.halfScrollView];
    
    NSArray *imagesArray = @[[UIImage imageNamed:@"3"],
                             [UIImage imageNamed:@"mm10"],
                             [UIImage imageNamed:@"3"],
                             [UIImage imageNamed:@"mm10"],
                             [UIImage imageNamed:@"3"],];
    
    [self.halfScrollView addImages:imagesArray];
}

// 半屏scrollView
- (HalfPageScrollView *)halfScrollView
{
    if (!_halfScrollView) {
        _halfScrollView = [[HalfPageScrollView alloc] initWithFrame:CGRectMake(30, 300, 350, 240)];
        _halfScrollView.backgroundColor = [UIColor redColor];
        _halfScrollView.clipsToBounds = YES;
    }
    return _halfScrollView;
}

//选择自动关闭时间
- (IBAction)selectCloseTimeAction:(id)sender {
    if (autoCloseAppTimeDurarion == 0) {
        ThirdViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdViewController class])];
        vc.t_delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//选择关闭时间后的回调
- (void)didSelectTime:(NSInteger)time
{
    autoCloseAppTimeDurarion = time;
    [self.selectTimeBtn setTitle:[NSString stringWithFormat:@"%ld秒后将自动关闭程序",time] forState:UIControlStateNormal];
    
    if (!_timer) {
        uint64_t interval = 1.0f*NSEC_PER_SEC;
        dispatch_queue_t queue = dispatch_queue_create("Timer Queue", 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        
        __block typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            [weakSelf changeCloseTime];
        });
        dispatch_resume(_timer);
        
    }
}

- (IBAction)presentAViewController:(id)sender {
    ThirdViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdViewController class])];
    vc.t_delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)changeCloseTime {
    
    autoCloseAppTimeDurarion --;
    NSLog(@"还有%ld秒",autoCloseAppTimeDurarion);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.selectTimeBtn setTitle:autoCloseAppTimeDurarion == 0?@"选择自动关闭时间":[NSString stringWithFormat:@"00:%02ld",autoCloseAppTimeDurarion] forState:UIControlStateNormal];
    });
    
    if (autoCloseAppTimeDurarion == 0) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (IBAction)purchaseFunc:(id)sender
{
    NSString *product = self.productId.text;
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"******要开始买东西了******");
        [self requestProductData:product];
    }
    else
    {
        NSLog(@"不能进行程序内支付");
    }
}

- (IBAction) getRecipt:(id)sender {
    //获取票据data数据
    //NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    //NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
}

- (void)requestProductData:(NSString *)data
{
    NSLog(@"-----先请求商品信息-----");
    NSArray *product = [[NSArray alloc] initWithObjects:data, nil];
    
    NSSet *productSet = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    request.delegate = self;
    
    [request start];
}

//验证购买凭据有效性
- (void)vertifyReceiptData {
    
    //获取票据data数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    //生成json串信息
    NSDictionary *requestContents = @{
                                      @"receipt-data":[receiptData base64EncodedDataWithOptions:0]
                                      };
    
    //转换成data供http请求的用
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (!requestData) {
        NSLog(@"失败");
    }
    
    //获取验证地址
    NSURL *vertifyUrl = [NSURL URLWithString:ITMS_SANDBOX_VERIFY_RECEIPT_URL];
    
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:vertifyUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"--验证错误-->%@",connectionError);
        }
        else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                NSLog(@"");
            }
        }
    }];
}

#pragma mark- PayMentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"-----交易完成-----");
                
                //验证购买凭据有效性
                [self vertifyReceiptData];
                
                //成功后执行完成交易
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-----商品添加进列表-----");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"-----已经购买过商品-----");
                //完成交易
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"-----交易失败-----error:%@",transaction.error);
                //失败后执行完成交易
                [queue finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"----- 移除 -----");
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"----- 重复支付失败 -----");
}

- (void)completerTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"-----交易结束-----");
}

#pragma mark- ProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"-----收到商品反馈信息-----");
    NSArray *products = response.products;
    if ([products count] == 0) {
        NSLog(@"-----没有可买的商品-----");
        return;
    }
    
    NSLog(@"productId:%@",response.invalidProductIdentifiers);
    NSLog(@"商品付费数量：%lu",(unsigned long)[products count]);
    
    SKProduct *product = nil;
    
    //找出要买的商品
    for (SKProduct *p in products) {
        
        //查看每件可买商品的信息
        NSLog(@"\n-----description----->%@\n-----localizedTitle----->%@\n-----localizedDescription----->%@\n-----price----->%@\n-----productIdentifier----->%@",[p description],[p localizedTitle],[p localizedDescription],[p price],[p productIdentifier]);
    
        if ([product.productIdentifier isEqualToString:self.productId.text]) {
            product = p;
        }
    }
    
    if (product) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        NSLog(@"-----发送购买请求-----");
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"-----请求发生错误-----");
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"-----反馈信息完成-----");
}

#pragma mark- Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.productId resignFirstResponder];
}


@end
