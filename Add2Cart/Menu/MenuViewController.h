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

- (IBAction)newQuote:(id)sender;
- (IBAction)synCButton:(id)sender;

@end
