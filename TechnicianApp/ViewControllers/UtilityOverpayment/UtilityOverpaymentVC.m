//
//  UtilityOverpaymentVC.m
//  Signature
//
//  Created by Dorin on 12/2/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "UtilityOverpaymentVC.h"
#import "SummaryOfFindingsOptionsVC.h"

@interface UtilityOverpaymentVC ()

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@end

@implementation UtilityOverpaymentVC


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Utility Overpayment", nil);
    [self configureVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureVC {
    self.amountTextField.layer.borderWidth   = 1.0;
    self.amountTextField.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    
    if ([[DataLoader sharedInstance] utilityOverpaymentHVAC]) {
        self.amountTextField.text = [[DataLoader sharedInstance] utilityOverpaymentHVAC];
    }else{
        [DataLoader sharedInstance].utilityOverpaymentHVAC = self.amountTextField.text;
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

//    NSDecimalNumber *paymentPence = [NSDecimalNumber decimalNumberWithString:penceString];
//    [textField setText:[paymentFormatter stringFromNumber:[paymentPence decimalNumberByMultiplyingByPowerOf10:0]]];
    
    NSNumber *someAmount = [NSNumber numberWithDouble:[penceString doubleValue]];
    [textField setText:[paymentFormatter stringFromNumber:someAmount]];
    
    
    return NO;
}


#pragma mark - Button Actions
- (IBAction)visitSiteCLicked:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hvacopcost.com"]];
}


- (IBAction)nextClicked:(UIButton *)sender {
    [DataLoader sharedInstance].utilityOverpaymentHVAC = self.amountTextField.text;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsOptionsVC class]])
    {
        SummaryOfFindingsOptionsVC *vc = (SummaryOfFindingsOptionsVC*)segue.destinationViewController;
        vc.isiPadCommonRepairsOptions = YES;
    }
}

@end
