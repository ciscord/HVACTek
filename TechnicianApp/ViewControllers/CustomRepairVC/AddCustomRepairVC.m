//
//  AddCustomRepairVC.m
//  HvacTek
//
//  Created by Dorin on 5/17/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "AddCustomRepairVC.h"

@interface AddCustomRepairVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *roundedView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation AddCustomRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureColorScheme];
}



#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    self.roundedView.layer.borderWidth   = 3.0;
    self.roundedView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
    self.titleTextField.layer.borderWidth   = .5;
    self.titleTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.titleTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.titleTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.priceTextField.layer.borderWidth   = .5;
    self.priceTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.priceTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.priceTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



#pragma mark - Save Button
- (IBAction)saveClicked:(id)sender {
    if (self.titleTextField.text.length > 0 &&  self.priceTextField.text.length > 1) {
        [self addPricebookItem];
        [self dismissController];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"In order to save a new custom repair please enter a title and price." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - Save Pricebook item
-(void)addPricebookItem {
    PricebookItem *priceBook = [PricebookItem pricebookWithID:@""
                                           itemNumber:@"33XX01"
                                            itemGroup:@""
                                                 name:self.titleTextField.text
                                             quantity:@""
                                               amount:@([[self getPriceAmountFromString:self.priceTextField.text] intValue] * 0.85)
                                         andAmountESA:[NSNumber numberWithInt:[[self getPriceAmountFromString:self.priceTextField.text] intValue]]];
    
    //NSArray * questionsTech = [[[[[DataLoader sharedInstance] currentUser] activeJob] techObservations] mutableCopy];
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions] count] > 0) {
        [[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions] addObject:priceBook];
    }else{
        [[[DataLoader sharedInstance] currentUser] activeJob].addedCustomRepairsOptions = [[NSMutableArray alloc] initWithObjects:priceBook, nil];
    }
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    [job.managedObjectContext save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCustomRepairOptionNotification" object:nil];
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


#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceTextField)
        if (textField.text.length  == 0)
            textField.text = @"$";
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if (textField == self.priceTextField) {
//        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        if (![newText hasPrefix:@"$"])
//        {
//            return NO;
//        }
//    }
//    
//    return YES;
    
    
    
    if (textField == self.priceTextField) {
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


#pragma mark - Dismiss Controller
- (IBAction)cancelClicked:(id)sender {
    [self dismissController];
}


-(void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
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
