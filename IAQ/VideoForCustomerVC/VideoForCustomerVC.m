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
@interface VideoForCustomerVC ()
@property (nonatomic, retain) AVPlayerViewController *playerViewController;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@end

@implementation VideoForCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    IAQProductModel* mainProductModel = nil;
    NSString* mainVideoPath = nil;
    for (IAQProductModel* productModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
        if ([productModel.productId isEqualToString:@"1"]) {
            mainProductModel = productModel;
            break;
        }
    }
    
    if (mainProductModel != nil) {
        for (FileModel* fileModel in mainProductModel.files) {
            if ([fileModel.type isEqualToString:@"video"]) {
                mainVideoPath = fileModel.fullUrl;
            }
        }
    }
    
    if (mainVideoPath == nil) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"There is no video"];
        [self presentViewController:alert animated:true completion:nil];
    }else {
        NSURL *urlVideoFile = [NSURL URLWithString:mainVideoPath];
        
        _playerViewController = [[AVPlayerViewController alloc] init];
        _playerViewController.player = [AVPlayer playerWithURL:urlVideoFile];
        _playerViewController.view.frame = self.videoView.bounds;
        _playerViewController.showsPlaybackControls = YES;
        
        [self.videoView addSubview:_playerViewController.view];
        self.view.autoresizesSubviews = YES;
    }
    
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark Button event
-(IBAction)nextButtonClick:(id)sender {
    int viewsToPop = 2;
    [self.navigationController popToViewController: self.navigationController.viewControllers[self.navigationController.viewControllers.count-viewsToPop-1] animated:YES];
    [IAQDataModel sharedIAQDataModel].isfinal = 1;
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
