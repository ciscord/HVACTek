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
}

- (IBAction)checkboxTouchUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.onCheckboxToggle) {
        self.onCheckboxToggle(sender.selected);
    }
}

@end
