//
//  ProductCell.h
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
