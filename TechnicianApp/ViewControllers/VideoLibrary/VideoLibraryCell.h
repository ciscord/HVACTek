//
//  VideoLibraryCell.h
//  HvacTek
//
//  Created by Dorin on 6/1/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoLibraryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
