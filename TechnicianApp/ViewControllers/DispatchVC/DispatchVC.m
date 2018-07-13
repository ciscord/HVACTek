//
//  DispatchVC.m
//  Signature
//
//  Created by Iurie Manea on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "DispatchVC.h"
#import <SFRoundProgressCounterView/SFRoundProgressCounterView.h>
#import "SFCounterLabel+SignatureFormat.h"
#import "UIImageView+AFNetworking.h"
#import "CustomerOverviewVC.h"
@interface DispatchVC () <SFRoundProgressCounterViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *beginBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbCustomerInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtClientProblems;
@property (strong, nonatomic) CustomerOverviewVC *customerOverviewVC;

@end

@implementation DispatchVC

- (void)viewDidLoad {
	[super viewDidLoad];
	
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self configureColorScheme];
    
	self.isTitleViewHidden = YES;

    [self setCustomerInfo];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > Dispatch) {
        CustomerOverviewVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerOverviewVC"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:Dispatch];
    }
    
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.beginBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbCustomerInfo.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


- (void)setCustomerInfo {
  Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
  
  NSDictionary *jobInfo = job.swapiJobInfo;
  NSDictionary *customerInfo = job.swapiCustomerInfo;
  
  self.lbCustomerInfo.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@ %@", [customerInfo objectForKeyNotNull:@"FirstName"], [customerInfo objectForKeyNotNull:@"LastName"], [customerInfo objectForKeyNotNull:@"Address1"],
                              [customerInfo objectForKeyNotNull:@"City"], [customerInfo objectForKeyNotNull:@"State"], [customerInfo objectForKeyNotNull:@"Zip"]];
  self.txtClientProblems.text = [[jobInfo objectForKeyNotNull:@"Instructions"] stringByReplacingOccurrencesOfString:@">" withString:@""];
}



- (void)setInspirationText:(NSString *)text {

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.alignment = NSTextAlignmentCenter;

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];

    NSDictionary *jobInfo = job.swapiJobInfo;
    NSDictionary *customerInfo = job.swapiCustomerInfo;
    
    self.lbCustomerInfo.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@ %@", [customerInfo objectForKeyNotNull:@"FirstName"], [customerInfo objectForKeyNotNull:@"LastName"], [customerInfo objectForKeyNotNull:@"Address1"],
                                [customerInfo objectForKeyNotNull:@"City"], [customerInfo objectForKeyNotNull:@"State"], [customerInfo objectForKeyNotNull:@"Zip"]];
    self.txtClientProblems.text = [[jobInfo objectForKeyNotNull:@"Instructions"] stringByReplacingOccurrencesOfString:@">" withString:@""];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)btnBeginTouch:(id)sender {

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (!job.dispatchTime) {
        job.dispatchTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    self.customerOverviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerOverviewVC"];
    [self.navigationController pushViewController:self.customerOverviewVC animated:YES];
}

@end
