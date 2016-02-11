//
//  SortFindinsCell.h
//  HvacTek
//
//  Created by Dorin on 2/10/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HvakTekColorScheme.h"

@interface SortFindinsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
