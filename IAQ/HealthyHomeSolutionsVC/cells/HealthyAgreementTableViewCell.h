//
//  HealthyAgreementTableViewCell.h
//  HvacTek
//
//  Created by Max on 11/12/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthyAgreementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pdfImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;

@end
