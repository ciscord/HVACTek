//
//  testerViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 17/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Item.h"
#import "CartViewController.h"
#import "HardTableViewCell.h"
#import "FirstOption.h"

#import "RebateQuoteTableViewController.h"

@interface testerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *allData;
   
    NSMutableArray *types;
   
    NSArray *headers;
   
    NSMutableArray *airCon;
    int aSDF;
    NSMutableArray *heatPump;
    int bSDF;
    NSMutableArray *furn;
    int cSDF;
    NSMutableArray *airH;
    int dSDF;
    NSMutableArray *geo;
    int e;
    NSMutableArray *iaq;
    int f;
    NSMutableArray *acces;
    int g;
    NSMutableArray *boilers;
    int h;
    NSMutableArray *hotwater;
    int ih;
    NSMutableArray *typeFours;
    NSMutableArray *typeThrees;
    //Gestures for swipable cells
    UISwipeGestureRecognizer* sgr;
    UISwipeGestureRecognizer* sgl;
    
    //Variables needed for collapsable cells.
    BOOL tapped;
    int tappedSection;
    NSMutableSet *sections;
    
    NSMutableArray *rebates;
  
 
   
  //  BOOL second;
    
    NSArray *test;
    int months;
    float perc;
    
    float totalAmount;
    float totalSavings;
    float afterSavings;
    float finacePay;
    float monthlyPay;
   
    Item *blank;
    BOOL last;
}


@property (nonatomic, strong) NSFetchedResultsController *prodFRC;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIView *secView; //Hidden view for months

//Finance labels
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSavingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterSavingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *financeMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPayment;

//Table view
@property (weak, nonatomic) IBOutlet UITableView *tableViewX;

//??
@property (strong, nonatomic) NSMutableArray *additemsB;

@property (nonatomic, strong) FirstOption *firstOption;
@property (nonatomic, strong)  NSMutableArray *carts;
@property (nonatomic, strong)  NSMutableArray *savedCarts;
@property (nonatomic, strong)  NSMutableArray *cartItems;
- (IBAction)cartButon:(id)sender;
- (IBAction)rebateButton:(id)sender;
- (IBAction)monthBut:(id)sender;
- (IBAction)doneBut:(id)sender;
- (IBAction)finBut:(id)sender;



@end
