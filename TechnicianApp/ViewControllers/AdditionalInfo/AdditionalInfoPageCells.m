//
//  AdditionalInfoPageCells.m
//  HvacTek
//
//  Created by Dorin on 5/20/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "AdditionalInfoPageCells.h"

@implementation AdditionalInfoPageCells

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkButton.layer.borderWidth   = 1.0;
    self.checkButton.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.checkButton.backgroundColor     = [UIColor whiteColor];
}

- (IBAction)checkButtonTouchUp:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.onCheckboxToggle) {
        self.onCheckboxToggle(sender.selected);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
