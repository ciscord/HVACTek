//
//  ServiceOptionViewCell.m
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "ServiceOptionViewCell.h"
#import "IAQProductModel+CoreDataProperties.h"
#import "IAQDataModel.h"
@implementation ServiceOptionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.qtyTextField.layer.borderWidth   = 1.0;
    self.qtyTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.qtyTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbValue.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnCheckbox.layer.borderWidth   = 1.0;
    self.btnCheckbox.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.btnCheckbox.backgroundColor     = [UIColor whiteColor];
    self.qtyTextField.delegate = self;
}

- (IBAction)checkboxTouchUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.onCheckboxToggle) {
        self.onCheckboxToggle(sender.selected);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.parentViewController == nil) {
        return true;
    }
    selectedItemIndex = textField.tag;
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
                
                IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[selectedItemIndex];
                
                item.quantity = string;
                
            }
            return false;
        }
        
    }
    NSInteger itemIndex = textField.tag;
    IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
    
    if (textField.text.length == 1 && string.length == 0) {
        
        item.quantity = @"";
        return true;
    }else if (textField.text.length > 1 && string.length == 0) {
        newString = [newString substringWithRange:NSMakeRange(0, newString.length-1)];
    }
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:newString];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (stringIsValid) {
        item.quantity = newString;
        
    }
    
    return stringIsValid;
}

@end
