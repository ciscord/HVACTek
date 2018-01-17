//
//  CartViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Item.h"
#import "testerViewController.h"

@protocol CartViewControllerDelegate
-(void)editCardSelected;
-(void)saveCartSelected;
@end

@interface CartViewController : UIViewController <MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate>
{
    NSArray *headers;
    int months;
    float perc;
    NSMutableString *products;
    NSArray *allData;
    
}
@property (nonatomic, retain) id<CartViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isViewingCart;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITableView *cartstableView;
@property (weak, nonatomic) IBOutlet UILabel *yourOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterSavingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *finance;
@property (weak, nonatomic) IBOutlet UILabel *monthlypayment;

@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UITextView *productsView;
@property (nonatomic, strong) NSArray *cartItems;
@property (nonatomic) int months;
@property (nonatomic, strong) NSArray *rebates;
@property (nonatomic, strong)  NSMutableArray *carts;
@property (nonatomic, strong) id testerVC;

@property (nonatomic, strong) NSFetchedResultsController *prodFRC;

- (IBAction)email:(id)sender;
- (IBAction)mainMenu:(id)sender;

@end
