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
    self.qtyTextField.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
}

- (IBAction)checkboxTouchUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.onCheckboxToggle) {
        self.onCheckboxToggle(sender.selected);
    }
}


@end
