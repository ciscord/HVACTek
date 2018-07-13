//
//  MainVC.m
//  Signature
//
//  Created by Iurie Manea on 12/8/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "MainVC.h"
#import "CustomerOverviewVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "SummaryOfFindingsVC.h"
#import "CustomerChoiceVC.h"
#import "AppDelegate.h"
#import "IAQDataModel.h"
#import "HealthyHomeSolutionsVC.h"
@interface MainVC ()
@property (strong, nonatomic) IBOutlet UIButton *btnTechApp;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd2CardApp;
@property (strong, nonatomic) IBOutlet UIButton *btnIAQApp;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.mainVController = self;
    
    self.isTitleViewHidden = YES;
    
    self.btnAdd2CardApp.hidden = !([[DataLoader sharedInstance].currentUser.add2cart boolValue]);
    self.btnTechApp.hidden = !([[DataLoader sharedInstance].currentUser.tech boolValue]);
    self.btnTechApp.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnAdd2CardApp.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnIAQApp.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)btnAdd2CartTouch:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    UIViewController *vc = [storyboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnIAQTouch:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IAQStoryboard" bundle:nil];
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:[NSNumber numberWithInteger:IAQHealthyHomeSolution]  forKey:@"iaqCurrentStep"];
    
    [userdefault synchronize];
    
    HealthyHomeSolutionsVC* healthyHomeSolutionsVC = [storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsVC"];
    [self.navigationController pushViewController:healthyHomeSolutionsVC animated:true];
    
}

- (IBAction)btnTehnicianApp:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    if (weakSelf == weakSelf.navigationController.topViewController) {
        [weakSelf performSegueWithIdentifier:@"tehnicianHome" sender:self];
    }

}
@end
