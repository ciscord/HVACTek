//
//  aQuoteFirstTableViewController.h
//  Signature
//
//  Created by James Buckley on 31/07/2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderTableViewCell.h"
#import "FirstOption.h"
#import "QuoteFirstTableViewController.h"
#import "TypeOneTableViewCell.h"
#import "AppDelegate.h"
#import "Item.h"

@interface aQuoteFirstTableViewController : UITableViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *typeOnes;
    NSArray *coolingArray;
    NSArray *heatingArray;
    NSMutableArray *rebates;
    NSMutableArray *addedItems;
    FirstOption *firstOption;

}

@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (weak, nonatomic) IBOutlet UISwitch *coolingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *heatingSwitch;

@property (weak, nonatomic) IBOutlet UIPickerView *coolingPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *heatingPicker;


- (IBAction)nextPage:(id)sender;
- (IBAction)coolingSwitchfire:(id)sender;
- (IBAction)heatingSwitchFire:(id)sender;


@end
