//
//  ProdAdminTableViewCell.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "ProdAdminTableViewCell.h"

@implementation ProdAdminTableViewCell
@synthesize switchButton;
@synthesize itemPic;
@synthesize modelName;
@synthesize price;
@synthesize optionOne, optionTwo, optionThree;

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchONOFF:(id)sender {
}
@end
