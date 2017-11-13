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
    [self.upButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    [self.downButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    
    [self.upButton setImage:[[UIImage imageNamed:@"karmaSortFilterUp"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]] forState:UIControlStateNormal];
    [self.downButton setImage:[[UIImage imageNamed:@"karmaSortFilterDown"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]] forState:UIControlStateNormal];
    
    
    
}


@end
