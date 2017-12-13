//
//  HeaderTableViewCell.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "HeaderTableViewCell.h"


@implementation HeaderTableViewCell
@synthesize segController;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    __weak UIImageView *weakImageView = self.logoImageView;
    [self.logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                              placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           UIImageView *strongImageView = weakImageView;
                                           if (!strongImageView) return;
                                           
                                           strongImageView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           //
                                       }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    segController.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"seg"];
}


- (IBAction)segController:(id)sender {
    
}


@end
