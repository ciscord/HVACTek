//
//  HeatingStaticPressureVC.m
//  HvacTek
//
//  Created by Max on 11/8/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HeatingStaticPressureVC.h"
#import "CHDropDownTextField.h"
#import "CHDropDownTextFieldTableViewCell.h"
#import "CoolingStaticPressureVC.h"

@interface HeatingStaticPressureVC () <CHDropDownTextFieldDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *filterSizeField;
@property (weak, nonatomic) IBOutlet UITextField *mervRatingField;
@property (weak, nonatomic) IBOutlet CHDropDownTextField *systemTypeField;
@property (weak, nonatomic) IBOutlet UITextField *aField;
@property (weak, nonatomic) IBOutlet UITextField *bField;
@property (weak, nonatomic) IBOutlet UITextField *cField;
@property (weak, nonatomic) IBOutlet UITextField *dField;
@property (weak, nonatomic) IBOutlet UITextField *abField;
@property (weak, nonatomic) IBOutlet UITextField *acField;
@property (weak, nonatomic) IBOutlet UITextField *bdField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *backgroundLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *borderField;

@end

@implementation HeatingStaticPressureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Heating Static Pressure";
    for (UILabel* backlabel in self.backgroundLabel) {
        backlabel.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    }
    
    for (UITextField* iborderfield in self.borderField) {
        iborderfield.clipsToBounds = true;
        iborderfield.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        iborderfield.layer.borderWidth = 1;
        
    }
    
    self.systemTypeField.dropDownTableVisibleRowCount = 4;
    self.systemTypeField.dropDownTableTitlesArray = @[ @"Gas Furnace & Condenser" , @"Air Handler & Condenser", @"Packaged System", @"Other"];
    self.systemTypeField.layer.borderWidth            = 1;
    self.systemTypeField.layer.borderColor            = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.systemTypeField.cellClass = [CHDropDownTextFieldTableViewCell class];
    self.systemTypeField.dropDownTableView.backgroundColor = [UIColor whiteColor];
    self.systemTypeField.dropDownTableView.layer.masksToBounds = YES;
    self.systemTypeField.dropDownTableView.layer.borderWidth = 1.0;
    self.systemTypeField.dropDownTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.systemTypeField.tag = 893457;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [df stringFromDate:today];
    
    self.dateField.text = dateString;
    
    [self.aField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.dField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.aField.delegate = self;
    self.bField.delegate = self;
    self.cField.delegate = self;
    self.dField.delegate = self;
    
    self.nameField.delegate = self;
    self.filterSizeField.delegate = self;
    self.mervRatingField.delegate = self;
    
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQHeatingStaticPressure) {
        [[IAQDataModel sharedIAQDataModel] loadHeatingStaticPressure];
        
        self.nameField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.customerName;
        self.dateField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.todayDate;
        self.filterSizeField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.filterSize;
        self.mervRatingField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.filterMervRating;
        self.systemTypeField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.systemType;
        self.aField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingA;
        self.bField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingB;
        self.cField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingC;
        self.dField.text = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingD;
        
        CoolingStaticPressureVC* coolingStaticPressureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CoolingStaticPressureVC"];
        [self.navigationController pushViewController:coolingStaticPressureVC animated:true];
        
    }
}

-(IBAction)nextButtonClick:(id)sender {
    if ([self isEmptyField]) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Customer name is required"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.customerName = self.nameField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.todayDate = self.dateField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.filterSize = self.filterSizeField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.filterMervRating = self.mervRatingField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.systemType = self.systemTypeField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingA = self.aField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingB = self.bField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingC = self.cField.text;
    [IAQDataModel sharedIAQDataModel].heatingStaticPressure.heatingD = self.dField.text;
    
    CoolingStaticPressureVC* coolingStaticPressureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CoolingStaticPressureVC"];
    [self.navigationController pushViewController:coolingStaticPressureVC animated:true];
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    
    [[IAQDataModel sharedIAQDataModel] saveHeatingStaticPressure];
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:[NSNumber numberWithInteger:IAQCoolingStaticPressure]  forKey:@"iaqCurrentStep"];
    [userdefault synchronize];

}

-(BOOL) isEmptyField {
    if (self.nameField.text.length == 0) {
        return true;
    }
    return false;
}
-(void) calculateData {
    
    if (![self.aField.text isNumeric] ||
        ![self.bField.text isNumeric] ||
        ![self.cField.text isNumeric] ||
        ![self.dField.text isNumeric] ) {
        
        return;
    }
    float aValue = [self.aField.text floatValue];
    float bValue = [self.bField.text floatValue];
    float cValue = [self.cField.text floatValue];
    float dValue = [self.dField.text floatValue];
    
    self.abField.text = [NSString stringWithFormat:@"%.2f", aValue + bValue];
    self.acField.text = [NSString stringWithFormat:@"%.2f", aValue - cValue];
    self.bdField.text = [NSString stringWithFormat:@"%.2f", bValue - dValue];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    [self calculateData];
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.aField || textField == self.bField || textField == self.dField || textField == self.cField) {
        unsigned long numberOfDots = [textField.text componentsSeparatedByString:@"."].count - 1;
        if (numberOfDots >0 && [string isEqualToString:@"."]) {
            return false;
        }
        NSString* newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        if (newString.length > 1) {
            unichar firstChar = [[newString uppercaseString] characterAtIndex:0];
            unichar secondChar = [[newString uppercaseString] characterAtIndex:1];
            if (firstChar == '0' && secondChar != '.') {
                NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
                
                BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
                if (stringIsValid) {
                    textField.text = string;
                }
                [self calculateData];
                return false;
            }
            
        }
        if (textField.text.length == 1 && string.length == 0) {
            textField.text = @"0";
            [self calculateData];
            return false;
        }
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:newString];
        
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        
        return stringIsValid;
    }else {
        if (range.location == textField.text.length && [string isEqualToString:@" "]) {
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@"\u00a0"];
            return NO;
        }
        // for all other cases, proceed with replacement
        return YES;
    }
    
}
- (void)dropDownTextField:(CHDropDownTextField *)dropDownTextField didChooseDropDownOptionAtIndex:(NSUInteger)index {
    self.systemTypeField.text = self.systemTypeField.dropDownTableTitlesArray[index];
    [self.systemTypeField hideDropDown];
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    [self.systemTypeField hideDropDown];
    
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
