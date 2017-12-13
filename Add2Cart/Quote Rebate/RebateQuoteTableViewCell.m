//
//  RebateQuoteTableViewCell.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "RebateQuoteTableViewCell.h"

@implementation RebateQuoteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
