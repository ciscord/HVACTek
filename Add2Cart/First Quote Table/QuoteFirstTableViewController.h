//
//  QuoteFirstTableViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 13/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderTableViewCell.h"
#import "FirstOption.h"
#import "testerViewController.h"
#import "MiscAddViewController.h"
#import "TypeTwoTableViewCell.h"
#import "TypeThreeTableViewCell.h"
#import "AppDelegate.h"
#import "Item.h"


@interface QuoteFirstTableViewController : UITableViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *secondOptions;
    NSArray *allData;
    NSMutableArray *addedItems;
    BOOL first;
}

@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FirstOption *firstOption;

- (IBAction)nextPage:(id)sender;


@end
