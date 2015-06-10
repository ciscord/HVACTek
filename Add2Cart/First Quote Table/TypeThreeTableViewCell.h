//
//  TypeThreeTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 13/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchON;
@property (weak, nonatomic) IBOutlet UITextField *quantity;

@end
