//
//  ProductCell.m
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ProductCell.h"
#import "HvakTekColorScheme.h"

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _separatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.contentView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    // Configure the view for the selected state
}

@end
