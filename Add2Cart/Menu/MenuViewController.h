//
//  MenuViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Item.h"

@interface MenuViewController : UIViewController
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
- (IBAction)productAdmin:(id)sender;

- (IBAction)newQuote:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *syncView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
- (IBAction)synCButton:(id)sender;

@end
