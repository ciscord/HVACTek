//
//  RebateQuoteTableViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RebateQuoteTableViewCell.h"

@protocol MyDataDelegate

-(void) receiveData:(NSArray *)theRebateData :(NSArray*)purchData;

@end

@interface RebateQuoteTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

    NSArray *allData;
    NSMutableArray *selected;
    NSMutableArray *rebatesToSend;
   
}




@property (nonatomic) id<MyDataDelegate> delegate;

@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) NSArray  *purch;


@end
