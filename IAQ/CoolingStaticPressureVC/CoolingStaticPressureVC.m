//
//  CoolingStaticPressureVC.m
//  HvacTek
//
//  Created by Admin on 11/11/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "CoolingStaticPressureVC.h"
#import "CHDropDownTextField.h"
#import "CHDropDownTextFieldTableViewCell.h"
@interface CoolingStaticPressureVC () <CHDropDownTextFieldDelegate, UITextFieldDelegate>
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

@implementation CoolingStaticPressureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}

- (void)dropDownTextField:(CHDropDownTextField *)dropDownTextField didChooseDropDownOptionAtIndex:(NSUInteger)index {
    self.systemTypeField.text = self.systemTypeField.dropDownTableTitlesArray[index];
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
