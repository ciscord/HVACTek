//
//  UtilityOverpaymentVC.m
//  Signature
//
//  Created by Dorin on 12/2/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "UtilityOverpaymentVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "ExploreSummaryVC.h"

@interface UtilityOverpaymentVC ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet RoundCornerView *overpaimentRoundV;
@property (weak, nonatomic) IBOutlet UIButton *visitBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *hvacLabel;
@property (weak, nonatomic) IBOutlet UILabel *overpaymentLabel;
@end

@implementation UtilityOverpaymentVC


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    
    UIColor* titleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 45,25)];
    [someButton setTitle:@" IAQ " forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(tapIAQButton)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    someButton.layer.borderWidth = 1;
    someButton.layer.borderColor = titleColor.CGColor;
    [someButton setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *iaqButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    self.title = NSLocalizedString(@"Utility Overpayment", nil);
    [self configureVC];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > UtilityOverpayment) {
        ExploreSummaryVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreSummaryVC"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:UtilityOverpayment];
    }
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = UtilityOverpayment;
}
#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.separatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.overpaimentRoundV.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.overpaimentRoundV.layer.borderWidth   = 1.0;
    self.overpaimentRoundV.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.visitBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.nextBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.hvacLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.overpaymentLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.amountTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.amountTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.amountTextField.layer.borderWidth   = 1.0;
    self.amountTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureVC {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (job.utilityOverpaymentHVAC) {
        self.amountTextField.text = job.utilityOverpaymentHVAC;
    }else{
        job.utilityOverpaymentHVAC = self.amountTextField.text;
        [job.managedObjectContext save];
    }
}


#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length  == 0)
    {
        textField.text = @"$0";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSMutableString *mutableString = [[textField text] mutableCopy];
    
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:NO];
    [paymentFormatter setMaximumFractionDigits:0];
    
    if ([mutableString length] == 0) {
        [mutableString setString:[local objectForKey:NSLocaleCurrencySymbol]];
        [mutableString appendString:string];
    } else {
        if ([string length] > 0) {
            [mutableString insertString:string atIndex:range.location];
        } else {
            [mutableString deleteCharactersInRange:range];
        }
    }
    
    NSString *penceString = [[[mutableString stringByReplacingOccurrencesOfString:
                               [local objectForKey:NSLocaleDecimalSeparator] withString:@""]
                              stringByReplacingOccurrencesOfString:
                              [local objectForKey:NSLocaleCurrencySymbol] withString:@""]
                             stringByReplacingOccurrencesOfString:
                             [local objectForKey:NSLocaleGroupingSeparator] withString:@""];

    NSNumber *someAmount = [NSNumber numberWithDouble:[penceString doubleValue]];
    [textField setText:[paymentFormatter stringFromNumber:someAmount]];
    
    
    return NO;
}


#pragma mark - Button Actions
- (IBAction)visitSiteCLicked:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hvacopcost.com"]];
}


- (IBAction)nextClicked:(UIButton *)sender {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    job.utilityOverpaymentHVAC = self.amountTextField.text;
    [job.managedObjectContext save];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[ExploreSummaryVC class]])
//    {
//        ExploreSummaryVC *vc = (ExploreSummaryVC*)segue.destinationViewController;
//        vc.sectionTypeChoosed = self.sectionChoosed;
//    }
}

@end
