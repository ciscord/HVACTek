//
//  BreatheEasyHealthyHomeVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "BreatheEasyHealthyHomeVC.h"
#import "VideoForCustomerVC.h"
#import "IAQDataModel.h"
@interface BreatheEasyHealthyHomeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *dividerImageView;
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@end

@implementation BreatheEasyHealthyHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Breathe Easy Healthy Home";
    [self.layer1View bringSubviewToFront:self.dividerImageView];
     [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQBreatheEasyHealtyHome) {
        VideoForCustomerVC* videoForCustomerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoForCustomerVC"];
        [self.navigationController pushViewController:videoForCustomerVC animated:true];
    }
}
#pragma mark Button event
-(IBAction)nextButtonClick:(id)sender {
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:[NSNumber numberWithInteger:IAQVideoForCustomer]  forKey:@"iaqCurrentStep"];
    
    [userdefault synchronize];
    
    VideoForCustomerVC* videoForCustomerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoForCustomerVC"];
    [self.navigationController pushViewController:videoForCustomerVC animated:true];
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
