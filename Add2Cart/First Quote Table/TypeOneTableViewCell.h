//
//  TypeOneTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 13/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UISwitch *switchOn;

@end
