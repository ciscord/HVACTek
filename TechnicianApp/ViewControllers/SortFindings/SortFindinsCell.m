//
//  SortFindinsCell.m
//  HvacTek
//
//  Created by Dorin on 2/10/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "SortFindinsCell.h"

@implementation SortFindinsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  self.lbTitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
  self.separatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


@end
