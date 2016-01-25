//
//  RROverviewCell.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RROverviewCell.h"

@implementation RROverviewCell

- (void)awakeFromNib {
    self.nameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.priceLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separator.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
