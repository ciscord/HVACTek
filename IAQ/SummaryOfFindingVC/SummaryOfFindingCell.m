//
//  PlatinumOptionCell.m
//  Signature
//
//  Created by Iurie Manea on 17.03.2015.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "SummaryOfFindingCell.h"

@implementation SummaryOfFindingCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.lbTitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

@end
