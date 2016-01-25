//
//  ServiceOptionViewCell.m
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "ServiceOptionViewCell.h"

@implementation ServiceOptionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.qtyTextField.layer.borderWidth   = 1.0;
    self.qtyTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.qtyTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbValue.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnCheckbox.layer.borderWidth   = 1.0;
    self.btnCheckbox.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
}

- (IBAction)checkboxTouchUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.onCheckboxToggle) {
        self.onCheckboxToggle(sender.selected);
    }
}


@end
