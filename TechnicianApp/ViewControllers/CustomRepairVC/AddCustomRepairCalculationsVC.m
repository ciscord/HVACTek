//
//  AddCustomRepairCalculationsVC.m
//  HvacTek
//
//  Created by Dorin on 5/25/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "AddCustomRepairCalculationsVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddCustomRepairCalculationsVC ()

@property (weak, nonatomic) IBOutlet UITextField *costField;
@property (weak, nonatomic) IBOutlet UITextField *estimateField;
@property (weak, nonatomic) IBOutlet RoundCornerView *roundedView;
@property (weak, nonatomic) IBOutlet CHDropDownTextField *repairDropDown;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyboardAvoiding;

@property (nonatomic, strong) NSArray *timeOptionsArray;
@property (nonatomic, strong) NSString *calculatedString;
@end

@implementation AddCustomRepairCalculationsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    [self configureController];
}


- (void)configureController {
    self.timeOptionsArray = [[NSArray alloc] initWithObjects:@"15 Minutes", @"Half an Hour", @"45 Minutes",
                          @"1 Hour", @"1.25 Hours", @"1.5 Hours", @"1.75 Hours",
                          @"2 Hours", @"2.25 Hours", @"2.5 Hours", @"2.75 Hours",
                          @"3 Hour", @"3.25 Hours", @"3.5 Hours", @"3.75 Hours",
                          @"4 Hour", @"4.25 Hours", @"4.5 Hours", @"4.75 Hours",
                          @"5 Hour", @"5.25 Hours", @"5.5 Hours", @"5.75 Hours",
                          @"6 Hour", @"6.25 Hours", @"6.5 Hours", @"6.75 Hours",
                          @"7 Hour", @"7.25 Hours", @"7.5 Hours", @"7.75 Hours",
                          @"8 Hour", @"8.25 Hours", @"8.5 Hours", @"8.75 Hours",
                          @"9 Hour", @"9.25 Hours", @"9.5 Hours", @"9.75 Hours",
                          @"10 Hour", @"10.25 Hours", @"10.5 Hours", @"10.75 Hours",
                          @"11 Hour", @"11.25 Hours", @"11.5 Hours", @"11.75 Hours",
                          @"12 Hour", @"12.25 Hours", @"12.5 Hours", @"12.75 Hours",
                          @"13 Hour", @"13.25 Hours", @"13.5 Hours", @"13.75 Hours",
                          @"14 Hour", @"14.25 Hours", @"14.5 Hours", @"14.75 Hours",
                          @"15 Hour", @"15.25 Hours", @"15.5 Hours", @"15.75 Hours", @"16 Hours", nil];
    
    self.repairDropDown.dropDownTableVisibleRowCount = 4;
    self.repairDropDown.dropDownTableTitlesArray = self.timeOptionsArray;
    
    self.repairDropDown.cellClass = [CHDropDownTextFieldTableViewCell class];
    self.repairDropDown.dropDownTableView.backgroundColor = [UIColor whiteColor];
    self.repairDropDown.dropDownTableView.layer.masksToBounds = YES;
    self.repairDropDown.dropDownTableView.layer.borderWidth = 1.0;
    self.repairDropDown.dropDownTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repairDropDown.tag = 893457;
    
    self.keyboardAvoiding.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    self.roundedView.layer.borderWidth   = 3.0;
    self.roundedView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
    self.costField.layer.borderWidth   = .5;
    self.costField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.costField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.costField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.estimateField.layer.borderWidth   = .5;
    self.estimateField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.estimateField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.estimateField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



#pragma mark - Buttons Action
- (IBAction)continueClicked:(id)sender {
    if ([self checkForEmptyField:self.costField] && [self checkForEmptyField:self.estimateField] && [self checkForEmptyDropDownField:self.repairDropDown]) {
        [self calculatePriceForNewRepair];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"In order to calculate a new custom repair price, please complete all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (IBAction)backClicked:(id)sender {
    [self dismissController];
}



-(void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Price Calculations
- (void)calculatePriceForNewRepair {
     //(Repair Time + .5)(325) + (((Part Cost + Freight Estimate)(1.06)) /.75)/.85
    float repairTime = [self getRepairTime];
    NSNumber *partCost = [NSNumber numberWithInt:[[self getPriceAmountFromString:self.costField.text] intValue]];
    NSNumber *freightEstimate = [NSNumber numberWithInt:[[self getPriceAmountFromString:self.estimateField.text] intValue]];
    float totalPrice = ((repairTime + 0.5)*325 + ((partCost.intValue + freightEstimate.intValue) * 1.06) / 0.75) / 0.85;
    self.calculatedString = [self getPriceFromFloat:totalPrice];
    
    [self performSegueWithIdentifier:@"unwindToSummaryOfFindingsFromCalculations" sender:self];
}


- (float)getRepairTime {
    NSUInteger selectedIndex = [self.timeOptionsArray indexOfObject:self.repairDropDown.text];
    return selectedIndex * 0.25 + 0.25;
}


-(NSNumber *)getPriceAmountFromString:(NSString *)priceString {
    
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:NO];
    [paymentFormatter setMaximumFractionDigits:0];
    
    NSNumber *number = [paymentFormatter numberFromString:priceString];
    
    return number;
}



- (NSString *)getPriceFromFloat:(float)price {
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:NO];
    [paymentFormatter setMaximumFractionDigits:0];
    
    NSString *priceString = [NSString stringWithFormat:@"$%f", price];
    NSNumber *finalNumber = [paymentFormatter numberFromString:priceString];
    NSString *finalString = [paymentFormatter stringFromNumber:[self roundNumber:finalNumber]];
    
    return finalString;
}


- (NSNumber *)roundNumber:(NSNumber *)number {
    NSNumber *roundedNumber = [NSNumber numberWithFloat:roundf(number.floatValue)];
    return roundedNumber;
}


#pragma mark - TextFields Validators
- (BOOL)checkForEmptyField:(UITextField *)textField {
    if (textField.text.length > 0 && ![textField.text isEqualToString:@"$"]) {
        return YES;
    }else{
        return NO;
    }
}



- (BOOL)checkForEmptyDropDownField:(UITextField *)textField {
    if (textField.text.length > 0 && ![textField.text isEqualToString:@"Select Repair Time"]) {
        return YES;
    }else{
        return NO;
    }
}



#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.costField || textField == self.estimateField)
        if (textField.text.length  == 0)
            textField.text = @"$";
    
    self.keyboardAvoiding.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 150);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.keyboardAvoiding.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.costField || textField == self.estimateField) {
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
    }else{
        return YES;
    }
}



#pragma mark - CHDropDownTextField Delegates
- (void)dropDownTextField:(CHDropDownTextField *)dropDownTextField didChooseDropDownOptionAtIndex:(NSUInteger)index {
    NSLog(@"selected");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"unwindToSummaryOfFindingsFromCalculations"]) {
        SummaryOfFindingsOptionsVC *vc = [segue destinationViewController];
        vc.calculatedCustomRepairPrice = self.calculatedString;
    }
}

@end
