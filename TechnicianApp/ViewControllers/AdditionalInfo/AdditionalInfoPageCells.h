//
//  AdditionalInfoPageCells.h
//  HvacTek
//
//  Created by Dorin on 5/20/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HvakTekColorScheme.h"

typedef void (^OnToggleCheckbox)(BOOL selected);

@interface AdditionalInfoPageCells : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic, copy) OnToggleCheckbox onCheckboxToggle;

@end
