//
//  AddProductViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface AddProductViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *manufacturers;
    NSString *name;
    float priced;
    NSString *manufactName;
    NSString *optionOneText;
    NSString *optionTwoText;
    NSString *optionThreeText;
    UIImage *imagePic;
    BOOL edit;
}

@property (weak, nonatomic) IBOutlet UITextField *modelNumber;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *optionOne;
@property (weak, nonatomic) IBOutlet UITextField *optionTwo;
@property (weak, nonatomic) IBOutlet UITextField *optionThree;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseImage;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerController;
@property (weak, nonatomic) NSString *type;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) Item *itemz;

- (IBAction)typeSelect:(id)sender;
- (IBAction)pickerDone:(id)sender;
- (IBAction)imageSelect:(id)sender;
- (IBAction)saveItemAction:(id)sender;








@end
