//
//  CustomerChoiceCell.m
//  Signature
//
//  Created by Dorin on 8/10/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "CustomerChoiceCell.h"

@implementation CustomerChoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
