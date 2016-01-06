//
//  PriceBookTableViewCell.h
//  Signature
//
//  Created by Andrei Zaharia on 12/11/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceBookView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;
@property (nonatomic, copy)  void (^onSelect)(PriceBookView *sender);
@end
