//
//  CartCell.h
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabLeviewHeihghtContrain;
@property (strong, nonatomic) IBOutlet UITableView *poductTableView;

@end
