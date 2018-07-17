//
//  VideoForCustomerVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "VideoForCustomerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "IAQDataModel.h"
#import <TWRDownloadManager.h>
#import "DataLoader.h"
#import "IsYourHomeHealthyVC.h"
@interface VideoForCustomerVC ()
@property (nonatomic, retain) AVPlayerViewController *playerViewController;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@end

@implementation VideoForCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataLoader sharedInstance] getMainVideo: ^(NSString *successMessage, NSDictionary *reciveData) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    
        NSString* mainVideoPath = [reciveData objectForKey:@"url"];

        if ([mainVideoPath isEqualToString:@""] || mainVideoPath == nil) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"There is no video"];
            [self presentViewController:alert animated:true completion:nil];
        }else {
            NSURL *urlVideoFile;
            _playerViewController = [[AVPlayerViewController alloc] init];
            
            if ([[TWRDownloadManager sharedManager] fileExistsForUrl:mainVideoPath]) {
                urlVideoFile =  [NSURL fileURLWithPath:[[TWRDownloadManager sharedManager] localPathForFile:mainVideoPath]];
                
            }else {
                if ([[[DataLoader sharedInstance] reachabilityManager] isReachable]) {
                    urlVideoFile = [NSURL URLWithString:mainVideoPath];
                    
                    [[TWRDownloadManager sharedManager] downloadFileForURL:mainVideoPath progressBlock:^(CGFloat progress) {
                        NSLog(@"progress %f video file:%@",progress, mainVideoPath);
                    } completionBlock:^(BOOL completed) {
                        NSLog(@"~~~completed downloading~~~");
                        
                    } enableBackgroundMode:YES];
                    
                }else{
                    UIAlertController *alert= [UIAlertController alertControllerWithTitle: @"Oops! Something went wrong."
                                                                                  message: @"Video wasn't downloaded to the app and there isn't internet connection available right now."
                                                                           preferredStyle: UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                               }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    NSLog(@"is Not Reachable");
                }
            }
            
            _playerViewController.player = [AVPlayer playerWithURL:urlVideoFile];
            _playerViewController.view.frame = self.videoView.bounds;
            _playerViewController.showsPlaybackControls = YES;
            
            [self.videoView addSubview:_playerViewController.view];
            self.view.autoresizesSubviews = YES;
        }
        
    }onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"There is no video"];
        [self presentViewController:alert animated:true completion:nil];
    }];

    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQVideoForCustomer) {
        IsYourHomeHealthyVC* isYourHomeHealthyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IsYourHomeHealthyVC"];
        [self.navigationController pushViewController:isYourHomeHealthyVC animated:false];
    }
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) tapTechButton {
    [super tapTechButton];
    [IAQDataModel sharedIAQDataModel].currentStep = IAQVideoForCustomer;
}

#pragma mark Button event
-(IBAction)nextButtonClick:(id)sender {
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:[NSNumber numberWithInteger:IAQIsYourHomeHealthy]  forKey:@"iaqCurrentStep"];
    
    [userdefault synchronize];
    IsYourHomeHealthyVC* isYourHomeHealthyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IsYourHomeHealthyVC"];
    [self.navigationController pushViewController:isYourHomeHealthyVC animated:true];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
