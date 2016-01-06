//
//  RebateAddViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 12/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface RebateAddViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSString *type;
@property (weak, nonatomic) Item *itemz;
- (IBAction)saveButton:(id)sender;

@end
