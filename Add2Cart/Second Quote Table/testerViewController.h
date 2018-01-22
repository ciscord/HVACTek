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
#import "Photos.h"
#import "Financials+CoreDataClass.h"
#import "HardTableViewCell.h"
#import "FirstOption.h"
#import "MonthsCollectionViewCell.h"
#import "KTCenterFlowLayout.h"
#import "RebateQuoteTableViewController.h"
#import "CartViewController.h"

@interface testerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MyDataDelegate, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    //NSArray *allData;
   NSMutableArray *allData;
    
    NSMutableArray *types;
   
    NSArray *headers;
   
    NSMutableArray *airCon;
    int choosedAirCon;
    NSMutableArray *heatPump;
    int choosedHeatPump;
    NSMutableArray *furn;
    int choosedFurn;
    NSMutableArray *airH;
    int choosedAirH;
    NSMutableArray *geo;
    int choosedGeo;
    NSMutableArray *iaq;
    int choosedIAQ;
    NSMutableArray *acces;
    int choosedAcces;
    NSMutableArray *boilers;
    int choosedBoilers;
    NSMutableArray *hotwater;
    int choosedHotWater;
    NSMutableArray *warranties;
    int choosedWarranties;
    NSMutableArray *ductlessMiniSplits;
    int choosedDuctlessMiniSplits;
    
    
    NSMutableArray *typeFours;
    NSMutableArray *typeThrees;
    //Gestures for swipable cells
    
    UISwipeGestureRecognizer* swipeGestureRight;
    UISwipeGestureRecognizer* swipeGestureLeft;
    
    //Variables needed for collapsable cells.
    BOOL tapped;
    int tappedSection;
    NSMutableSet *sections;
    
    NSMutableArray *rebates;
  
    
  //  BOOL second;
    
    NSArray *test;
    
    float perc;
    
    float totalAmount;
    float totalSavings;
    float afterSavings;
    float finacePay;
    float monthlyPay;
   
    Item *blank;
    BOOL isLast;
    
    @public
    //int months;
    
    
///    BOOL isEditing;
}

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) int easyMonth;
@property (nonatomic, assign) int fastMonth;
@property (nonatomic, assign) int easySelectedIndex;
@property (nonatomic, assign) int fastSelectedIndex;

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

// Financials
@property (nonatomic, strong) NSMutableArray *easyFinancialsData;
@property (nonatomic, strong) NSMutableArray *fastFinancialsData;


- (IBAction)cartButon:(id)sender;
- (IBAction)rebateButton:(id)sender;
- (IBAction)monthBut:(id)sender;
- (IBAction)doneBut:(id)sender;
- (IBAction)finBut:(id)sender;



@end
