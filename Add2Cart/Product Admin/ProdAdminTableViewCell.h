//
//  ProdAdminTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdAdminTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemPic;
@property (weak, nonatomic) IBOutlet UILabel *modelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *optionOne;
@property (weak, nonatomic) IBOutlet UILabel *optionTwo;
@property (weak, nonatomic) IBOutlet UILabel *optionThree;

- (IBAction)switchONOFF:(id)sender;

@end
