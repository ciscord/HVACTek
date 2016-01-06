//
//  RebateTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 12/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RebateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchOn;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
- (IBAction)rebateSwitch:(id)sender;

@end
