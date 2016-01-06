//
//  HeaderTableViewCell.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell
- (IBAction)segController:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segController;
@end
