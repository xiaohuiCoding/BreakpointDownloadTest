//
//  ViewController.m
//  BreakpointDownloadTest
//
//  Created by xiaohui on 2018/3/20.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "ViewController.h"
#import "HSDownloadManager.h"

NSString * const downloadUrl1 = @"http://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg";
NSString * const downloadUrl2 = @"http://data.5sing.kgimg.com/G061/M0A/03/13/HZQEAFb493iAOeg5AHMiAfzZU0E739.mp3";
NSString * const downloadUrl3 = @"http://paopao.nosdn.127.net/a9b95b64-dfd1-4d5a-b705-9e301708b6f6.mp4";

@interface ViewController ()

/** 进度UILabel */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel3;

/** 进度UIProgressView */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView3;

/** 下载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *downloadButton1;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton2;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self refreshDataWithState:DownloadStateSuspended];
}

//刷新数据
- (void)refreshDataWithState:(DownloadState)state
{
    self.progressLabel1.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    
    self.progressLabel2.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl2] * 100];
    self.progressView2.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl2];
    [self.downloadButton2 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    
    self.progressLabel3.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl3] * 100];
    self.progressView3.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl3];
    [self.downloadButton3 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    
    NSLog(@"downloadUrl1-----%f", [[HSDownloadManager sharedInstance] progress:downloadUrl1]);
    NSLog(@"downloadUrl2-----%f", [[HSDownloadManager sharedInstance] progress:downloadUrl2]);
    NSLog(@"downloadUrl3-----%f", [[HSDownloadManager sharedInstance] progress:downloadUrl3]);
}

//下载
- (IBAction)download1:(UIButton *)sender
{
    [self download:downloadUrl1 progressLabel:self.progressLabel1 progressView:self.progressView1 button:sender];
}

- (IBAction)download2:(UIButton *)sender
{
    [self download:downloadUrl2 progressLabel:self.progressLabel2 progressView:self.progressView2 button:sender];
}

- (IBAction)download3:(UIButton *)sender
{
    [self download:downloadUrl3 progressLabel:self.progressLabel3 progressView:self.progressView3 button:sender];
}

//删除
- (IBAction)deleteFile1:(UIButton *)sender
{
    [[HSDownloadManager sharedInstance] deleteFile:downloadUrl1];
    self.progressLabel1.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteFile2:(UIButton *)sender
{
    [[HSDownloadManager sharedInstance] deleteFile:downloadUrl2];
    self.progressLabel2.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl2] * 100];
    self.progressView2.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl2];
    [self.downloadButton2 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteFile3:(UIButton *)sender
{
    [[HSDownloadManager sharedInstance] deleteFile:downloadUrl3];
    self.progressLabel3.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:downloadUrl3] * 100];
    self.progressView3.progress = [[HSDownloadManager sharedInstance] progress:downloadUrl3];
    [self.downloadButton3 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteAllFile:(UIButton *)sender
{
    [[HSDownloadManager sharedInstance] deleteAllFile];
    [self refreshDataWithState:DownloadStateSuspended];
}

//开启下载任务
- (void)download:(NSString *)url progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView button:(UIButton *)button
{
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            progressView.progress = progress;
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
        });
    }];
}

//返回按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state) {
        case DownloadStateStart:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"完成";
        default:
            break;
    }
}

@end
