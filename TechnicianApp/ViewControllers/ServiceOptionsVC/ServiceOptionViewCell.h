//
//  ServiceOptionViewCell.h
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnToggleCheckbox)(BOOL selected);

@interface ServiceOptionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;

@property (nonatomic, copy) OnToggleCheckbox onCheckboxToggle;

@end
