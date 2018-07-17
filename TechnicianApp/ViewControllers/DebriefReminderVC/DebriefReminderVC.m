//
//  DebriefReminderVC.m
//  Signature
//
//  Created by Iurie Manea on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "DebriefReminderVC.h"

@interface DebriefReminderVC ()

@property (weak, nonatomic) IBOutlet UILabel *lbLastJopInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *debriefBtn;

@end

@implementation DebriefReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self configureColorScheme];

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    NSDictionary *jobInfo = job.swapiJobInfo;
    NSDictionary *customerInfo = job.swapiCustomerInfo;
    self.lbLastJopInfo.text = [NSString stringWithFormat:@"%@ - %@ %@\n%@\n%@, %@ %@", jobInfo[@"JobNo"], [customerInfo objectForKeyNotNull:@"FirstName"], [customerInfo objectForKeyNotNull:@"LastName"], [customerInfo objectForKeyNotNull:@"Address1"], [customerInfo objectForKeyNotNull:@"City"], [customerInfo objectForKeyNotNull:@"State"], [customerInfo objectForKeyNotNull:@"Zip"]];
    
    [[TechDataModel sharedTechDataModel] saveCurrentStep:DebriefReminder];
}

- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = DebriefReminder;
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.debriefBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbLastJopInfo.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
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
