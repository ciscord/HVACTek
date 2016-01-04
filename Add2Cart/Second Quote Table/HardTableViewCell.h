//
//  HardTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 13/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *modelName;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) BOOL tapped;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inCartLabel;


@end
