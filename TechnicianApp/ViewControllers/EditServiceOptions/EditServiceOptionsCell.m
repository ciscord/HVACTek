//
//  EditServiceOptionsCell.m
//  Signature
//
//  Created by Dorin on 12/3/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "EditServiceOptionsCell.h"

@implementation EditServiceOptionsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.serviceNameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];

    // Configure the view for the selected state
}

@end
