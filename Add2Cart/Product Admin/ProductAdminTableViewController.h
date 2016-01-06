//
//  ProductAdminTableViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderTableViewCell.h"
#import "ProdAdminTableViewCell.h"
#import "RebateTableViewCell.h"
#import "AppDelegate.h"
#import "Item.h"

@interface ProductAdminTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    int segmentChose;
    NSInteger seg;
    NSArray *products;
    NSString *prodType;
    NSArray *types;
    NSMutableArray *selected;
}


@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addProduct:(id)sender;

@end
