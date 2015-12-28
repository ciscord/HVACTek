//
//  testerViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 17/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "testerViewController.h"
//#undef NSLog

@interface testerViewController (){
    
    IBOutlet UILabel *lblSystemRebates;
    IBOutlet UILabel *lblInvestemts;
    IBOutlet UILabel *lblFinancing;
    
    IBOutlet UIButton *btnFinancing;
    IBOutlet UILabel *lblFinancingValue;
    IBOutlet UIButton *btnCart1;
    IBOutlet UIButton *btnCart2;
    IBOutlet UIButton *btnCart3;
    __weak IBOutlet UIButton *cartButton;
}

@end

@implementation testerViewController
@synthesize managedObjectContext;
@synthesize prodFRC;
@synthesize monthlyPayment, totalAmountLabel, totalSavingsLabel,afterSavingsLabel,financeMonthLabel;
@synthesize additemsB;
@synthesize secView;
@synthesize tableViewX;
@synthesize firstOption;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editingCartIndex = 0;
    
    //Init the ints ??????
    choosedAirCon = 0;
    choosedHeatPump = 0;
    choosedFurn = 0;
    choosedAirH = 0;
    choosedGeo = 0;
    choosedIAQ = 0;
    choosedAcces = 0;
    choosedBoilers = 0;
    choosedHotWater = 0;
    
    //Tapped is for collapsable cell
    tapped= FALSE;
    sections = [[NSMutableSet alloc]initWithCapacity:9];
    
    //reset all labels.
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    afterSavings =0.0f ;
    finacePay = 0.0f;
    monthlyPay = 0.0f;
    //Months set to default at 60
    months = 24;
    
    //Move to a mutable array for later.
    _cartItems = [[NSMutableArray alloc]init];
    self.carts = [[NSMutableArray alloc]init];
     self.savedCarts = [[NSMutableArray alloc]init];
    
    NSLog(@" The Cart has %d in it just now",_cartItems.count);
    
    //Setup the navbar.
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    
    //Set delegate & views
    tableViewX.delegate = self;
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(celltapped:)];
    [tableViewX addGestureRecognizer:tap];
    [tableViewX addGestureRecognizer:swipeGestureRight];
    [tableViewX addGestureRecognizer:swipeGestureLeft];
    [self.view sendSubviewToBack:secView];
    

   }


-(void) home {
       [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) viewDidAppear:(BOOL)animated   {
    NSLog(@"called agin");
 
    //Fetch the data.
    [self fetchData];
    
    
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    afterSavings =0.0f ;
    finacePay = 0.0f;
    monthlyPay = 0.0f;
    [self buildQuote];
    
    btnCart1.hidden = !(self.savedCarts.count > 0);
    btnCart2.hidden = !(self.savedCarts.count > 1);
    btnCart3.hidden = !(self.savedCarts.count > 2);
    
    cartButton.enabled = self.savedCarts.count < 3;
}



-(void) setupArrays {
    headers = [[NSArray alloc]initWithObjects:@"Air Conditioners",@"Furnaces", @"Heat Pumps",@"Air Handlers"
               ,@"Geothermal" ,@"Controls",@"Indoor Air Quality",@"Hot Water Heaters",@"Boilers",nil]; //@"Rebates"
    airCon = [[NSMutableArray alloc]init];
    furn = [[NSMutableArray alloc]init];
    heatPump = [[NSMutableArray alloc]init];
    airH = [[NSMutableArray alloc]init];
    geo = [[NSMutableArray alloc]init];
    acces = [[NSMutableArray alloc]init];
    iaq = [[NSMutableArray alloc]init];
    typeFours = [[NSMutableArray alloc]init];
    typeThrees = [[NSMutableArray alloc]init];
    
    boilers=[[NSMutableArray alloc]init];
    hotwater=[[NSMutableArray alloc]init];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Fetch and Sort
-(void) fetchData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"type" ascending:YES];
        NSSortDescriptor *manSort = [[NSSortDescriptor alloc]initWithKey:@"manu" ascending:YES];
  //    NSSortDescriptor *ordSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, manSort,  nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    self.prodFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.prodFRC.delegate = self;
    
    NSError *fetchingError = nil;
    if ([self.prodFRC performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched in second quote ");
        
    } else {
        NSLog(@"Failed to get the result");
    }
    
    allData = [[NSArray alloc]init];
    allData = [self.managedObjectContext
               executeFetchRequest:fetchRequest error:&fetchingError];
    
 /* Test how much in memory
  for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        NSLog(@"%@",itm.type);
    }*/

    
    
    [self setupArrays];

    //Need to call sort here
    [self sortData];
}



-(void) sortData {

    int cool = 0;
    int heat = 0;
    if (firstOption.heating)
        heat = 2;
    if (firstOption.cooling)
        cool = 1;
    NSMutableArray *coolProds = [[NSMutableArray alloc]init];
    NSMutableArray *heatProds = [[NSMutableArray alloc]init];
  

    NSLog(@"Heating is %d and cooling is %d",heat ,cool);
   
    
    //Need to itterate through all of the items for included items.  Once we have an included item check if it matches type 1 or 2. Then check its price and add to final
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
    //    NSLog(@"%@",itm.TitleText);
        
        int tID = [itm.typeID intValue];
        if (tID == cool && (![coolProds containsObject:itm])) {
            [coolProds addObject:itm];
        }
        if (tID == heat && (![heatProds containsObject:itm])) {
            [heatProds addObject:itm];
        }
        if ((tID == 3)&& (![typeThrees containsObject:itm])) {
          //  itm.finalOption = itm.optionOne;
          //  itm.finalPrice = itm.optOnePrice;
            NSLog(@"type is %@",itm.type);
           /* if ([itm.type isEqualToString:@"IAQ"]) {
                [iaq addObject:itm];
                NSLog(@"type is %@",itm.type);
            } else {
                [acces addObject:itm];
            }*/
            [typeThrees addObject:itm];
        }// end of 3's
        
        if ((tID == 4)&& (![typeFours containsObject:itm])) {
            // This item is added no matter what.
            
            [typeFours addObject:itm];
            
            }

        
        
    } //end of iteration
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"type3"]) {
        for (int ab = 0; ab <typeThrees.count; ab++) {
            Item *itm = typeThrees[ab];
            [self fillArrays:itm];
        }
        
        for (int ab = 0; ab <typeFours.count; ab++) {
            Item *itm = typeFours[ab];
            [self fillArrays:itm];
        }
        
    }
    else
    {
        //if false run the db
        [self sortTypeThrees];
        [self sortTypeFours];
    
    }
    
    
    rebates = [[NSMutableArray alloc]init];
    
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        bool t = [itm.include boolValue];
        if (t && [itm.type isEqualToString:@"Rebates"]) {
            [rebates addObject:itm];
        }
    }
    
    NSLog(@"rebates has %d",rebates.count);

    
    
    
    NSLog(@"all data has %d and there are %d cool %d heat products and %d accesories",allData.count,coolProds.count, heatProds.count, acces.count);
    
    //So have the products now... Check the values of the heat and cool now.
    
    for (int x = 0; x < coolProds.count; x++) {
        Item *itm = coolProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsCoolPrice:itm]];
        itm.finalOption = [self checkOptionsCoolOpt:itm];
        if ([itm.finalOption isEqualToString:@"None"]) {
            //do nothing
        } else {
            [self fillArrays:itm];
        }
        
    }
    
    for (int x = 0; x < heatProds.count; x++) {
        Item *itm = heatProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsHeatPrice:itm]];
        itm.finalOption = [self checkOptionsHeatOpt:itm];
        if ([itm.finalOption isEqualToString:@"None"]) {
            //don nothing
        } else {
            [self fillArrays:itm];
        }
    }
    
    
    [self arraySort];
            
    //call the blanks here
  
 //   Item *itm;
    if (airCon.count>0) {
      [airCon insertObject:[self loadTheBlank] atIndex:0];
       // itm = airCon[0];
      //  [self purchase:itm];
    }
    if (heatPump.count>0) {
       [heatPump insertObject:[self loadTheBlank] atIndex:0];
      //  itm = heatPump[0];
       // [self purchase:itm];
    }
    if (furn.count>0) {
        [furn insertObject:[self loadTheBlank] atIndex:0];
     //   itm = furn[0];
        //[self purchase:itm];
    }
    if (airH.count>0) {
        [airH insertObject:[self loadTheBlank] atIndex:0];
      //  itm = airH[0];
       // [self purchase:itm];
    }
    if (geo.count>0) {
        [geo insertObject:[self loadTheBlank] atIndex:0];
     //   itm = geo[0];
      //  [self purchase:itm];
    }
    if (boilers.count>0) {
        [boilers insertObject:[self loadTheBlank] atIndex:0];
     //   itm = boilers[0];
      //  [self purchase:itm];
    }
    if (hotwater.count>0) {
        [hotwater insertObject:[self loadTheBlank] atIndex:0];
        //itm = hotwater[0];
       // [self purchase:itm];
    }
    
}


-(void) arraySort {
    
   // NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ord" ascending:YES];
   NSSortDescriptor *manSort = [NSSortDescriptor sortDescriptorWithKey :@"manu" ascending:YES];
    NSSortDescriptor *sortA = [NSSortDescriptor sortDescriptorWithKey:@"finalPrice" ascending:NO];
    
    NSArray *sortDec = @[manSort,sortA];
    
    if (airCon.count>0) {
        airCon = [[airCon sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (heatPump.count>0) {
        heatPump = [[heatPump sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (furn.count>0) {
        furn = [[furn sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (airH.count>0) {
        airH = [[airH sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (geo.count>0) {
        geo = [[geo sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (boilers.count>0) {
        boilers = [[boilers sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (hotwater.count>0) {
        hotwater = [[hotwater sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if(acces.count > 0) {
        acces = [[acces sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (iaq.count > 0) {
        iaq = [[iaq sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
}



-(void) sortTypeThrees {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"type3"];
    Item *itm;
    NSLog(@"type 3 has %d",typeThrees.count);
    for (int xj = 0; xj < typeThrees.count; xj++) {
        itm = typeThrees[xj];
        NSString *name = itm.modelName;
        NSData *pdata = itm.photo;
        NSString *type = itm.type;
        NSString *opt = itm.optionOne;
        NSString *man = itm.manu;
        float opty = [itm.optOnePrice floatValue] ;
        itm.finalOption = opt;
        itm.finalPrice = [NSNumber numberWithFloat:opty];
       [self fillArrays:itm];
        
        if ([itm.type isEqualToString:@"Hot Water Heaters"]) {
            NSLog(@"aaaa");
        }

//        
//        if ([itm.optionOne floatValue] != 0) {
//            NSString *option = itm.optionOne;
//            float optionPrice = [itm.optOnePrice floatValue] ;
//            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//            item.modelName = name;
//            item.finalOption = option;
//            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
//            item.type = type;
//            item.typeID = [NSNumber numberWithInt:3];
//            item.photo = pdata;
//            item.manu = man;
//            [self fillArrays:item];
//        }

        
        
        if ([itm.optTwoPrice floatValue] != 0) {
            NSString *option = itm.optionTwo;
            float optionPrice = [itm.optTwoPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.typeID = [NSNumber numberWithInt:3];
            item.photo = pdata;
            item.manu = man;
            [self fillArrays:item];
        }
        
        if ([itm.optThreePrice floatValue] != 0) {
            NSString *option = itm.optionThree;
            float optionPrice = [itm.optThreePrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
        
        if ([itm.optFourPrice floatValue] != 0) {
            NSString *option = itm.optionFour;
            float optionPrice = [itm.optFourPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
        
        if ([itm.optFivePrice floatValue] != 0) {
            NSString *option = itm.optionFive;
            float optionPrice = [itm.optFivePrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
        
        if ([itm.optSixPrice floatValue] != 0) {
            NSString *option = itm.optionSix;
            float optionPrice = [itm.optSixPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
        
        
        if ([itm.optSevenPrice floatValue] != 0) {
            NSString *option = itm.optionSeven;
            float optionPrice = [itm.optSevenPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
        
        if ([itm.optEightPrice floatValue] != 0) {
            NSString *option = itm.optionEight;
            float optionPrice = [itm.optEightPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:3];
            [self fillArrays:item];
        }
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
    
}


-(void) sortTypeFours {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"type3"];
    Item *itm;
    NSLog(@"type 4 has %d",typeFours.count);
    for (int xj = 0; xj < typeFours.count; xj++) {
        itm = typeFours[xj];
        NSString *name = itm.modelName;
        NSData *pdata = itm.photo;
        NSString *type = itm.type;
        NSString *opt = itm.optionOne;
        NSString *man = itm.manu;
        float opty = [itm.optOnePrice floatValue] ;
        itm.finalOption = opt;
        itm.finalPrice = [NSNumber numberWithFloat:opty];
        [self fillArrays:itm];
        
        if ([itm.type isEqualToString:@"Hot Water Heaters"]) {
            NSLog(@"aaaa");
        }
        
        if ([itm.optionOne floatValue] != 0) {
            NSString *option = itm.optionOne;
            float optionPrice = [itm.optOnePrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:4];
            item.photo = pdata;
            [self fillArrays:item];
        }

        
        if ([itm.optTwoPrice floatValue] != 0) {
            NSString *option = itm.optionTwo;
            float optionPrice = [itm.optTwoPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:4];
            item.photo = pdata;
            [self fillArrays:item];
        }
        
        if ([itm.optThreePrice floatValue] != 0) {
            NSString *option = itm.optionThree;
            float optionPrice = [itm.optThreePrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
        
        if ([itm.optFourPrice floatValue] != 0) {
            NSString *option = itm.optionFour;
            float optionPrice = [itm.optFourPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.manu = man;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
        
        if ([itm.optFivePrice floatValue] != 0) {
            NSString *option = itm.optionFive;
            float optionPrice = [itm.optFivePrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.photo = pdata;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
        
        if ([itm.optSixPrice floatValue] != 0) {
            NSString *option = itm.optionSix;
            float optionPrice = [itm.optSixPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.manu = man;
            item.photo = pdata;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
        
        
        if ([itm.optSevenPrice floatValue] != 0) {
            NSString *option = itm.optionSeven;
            float optionPrice = [itm.optSevenPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.manu = man;
            item.photo = pdata;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
        
        if ([itm.optEightPrice floatValue] != 0) {
            NSString *option = itm.optionEight;
            float optionPrice = [itm.optEightPrice floatValue] ;
            Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = name;
            item.finalOption = option;
            item.finalPrice = [NSNumber numberWithFloat:optionPrice];
            item.type = type;
            item.manu = man;
            item.photo = pdata;
            item.typeID = [NSNumber numberWithInt:4];
            [self fillArrays:item];
        }
    }
    
    
    
}


-(void) fillArrays:(Item *)itm {
    
    if ([itm.type isEqualToString:@"Air Conditioners"]) {
        [airCon addObject:itm];
    } else if ([itm.type isEqualToString:@"Heat Pumps"]) {
        [heatPump addObject:itm];
    } else if ([itm.type isEqualToString:@"Furnaces"]) {
        [furn addObject:itm];
    }else if ([itm.type isEqualToString:@"Air Handlers"]) {
        [airH addObject:itm];
    } else if ([itm.type isEqualToString:@"Geothermal"]) {
        [geo addObject:itm];
    }
    else
        if ([itm.type isEqualToString:@"IAQ"]) {
            int c =0;
            for (Item * ii in iaq) {
                if ([ii.modelName isEqualToString:itm.modelName]) {
                    c++;
                }
            }
            if (![iaq containsObject:itm]&& c==0) {
            [iaq addObject:itm];
        }
    }
        else if ([itm.type isEqualToString:@"Boilers"]) {
        [boilers addObject:itm];
    } else if ([itm.type isEqualToString:@"Hot Water Heaters"]) {
        int c =0;
        for (Item * ii in hotwater) {
            if ([ii.modelName isEqualToString:itm.modelName]) {
                c++;
            }
        }
        if (c==0) {
        [hotwater addObject:itm];
        }
        
    } else if ([itm.type isEqualToString:@"Accessories"]) {
        [acces addObject:itm];
    }
    
    
}


-(Item *)loadTheBlank {
    
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        if ([itm.type isEqualToString:@"Blank"]) {
            blank = itm;
        }
                            
    }

    
    return blank;
}


#pragma mark - Check Actions
-(float) checkOptionsCoolPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.coolingValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.coolingValue]) {
       return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.coolingValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.coolingValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.coolingValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.coolingValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.coolingValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.coolingValue]) {
        return [itm.optEightPrice floatValue];
    }
    return 0.0f;
}



-(NSString *) checkOptionsCoolOpt:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.coolingValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.coolingValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.coolingValue]) {
       return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.coolingValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.coolingValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.coolingValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.coolingValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.coolingValue]) {
        return itm.optionEight;
    }
    return@"None";
}



-(float) checkOptionsHeatPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.heatingValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.heatingValue]) {
        return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.heatingValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.heatingValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.heatingValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.heatingValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.heatingValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.heatingValue]) {
        return [itm.optEightPrice floatValue];
    }

    return 0.0f;
}


-(NSString *) checkOptionsHeatOpt:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.heatingValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.heatingValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.heatingValue]) {
        return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.heatingValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.heatingValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.heatingValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.heatingValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.heatingValue]) {
        return itm.optionEight;
    }
    return@"None";
}


#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tapped) {
        tapped = FALSE;
        [sections addObject:[NSNumber numberWithInt:tappedSection]];
    }
  
    if ([sections containsObject:[NSNumber numberWithInt:indexPath.section]]) {
        return 30.0f;
    } else {
    switch (indexPath.section) {
        case 0:
            if (airCon.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 2:
            if (heatPump.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 1:
            if (furn.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 3:
            if (airH.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 4:
            if (geo.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 6:
            if (iaq.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 5:
            if (acces.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 8:
            if (boilers.count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        case 7:
            if (hotwater .count == 0) {
                return 30.0f;
            } else {
                return 158.0f;
            }
            break;
        default:
            return 158.0f;
        break;
    
    }
    }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return headers.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return headers[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Item *itm = nil;
    
    switch (indexPath.section) {
        case 0:{
            //Air Conditioners
            if (choosedAirCon < airCon.count){
                itm = airCon[choosedAirCon];
                //   [self purchase:itm];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            } else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                cell.clipsToBounds = YES;
            }
            break;
        }
        case 2:{
            //heat Pumps
            if (choosedHeatPump < heatPump.count ){
                itm = heatPump[choosedHeatPump];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 1:{
            //furnaces
            if (choosedFurn < furn.count){
                itm = furn[choosedFurn];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            
            break;
        }
        case 3:{
            //Air Handlers
            if (choosedAirH < airH.count){
                itm = airH[choosedAirH];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 4:{
            //Geothermal
            if (choosedGeo < geo.count){
                itm = geo[choosedGeo];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 6:{
            //IAQ
            if (choosedIAQ < iaq.count){
                itm = iaq[choosedIAQ];
                cell.buyButton.enabled = YES;
                cell.buyButton.hidden = NO;
                cell.removeButton.hidden = NO;
                cell.removeButton.enabled = YES;
            }else {
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                cell.clipsToBounds = YES;
                
            }
            break;
        }
        case 5:{
            //Accessories
            if (choosedAcces < acces.count){
                
                itm = acces[choosedAcces];
                cell.buyButton.enabled = YES;
                cell.buyButton.hidden = NO;
                cell.removeButton.hidden = NO;
                cell.removeButton.enabled = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
            }
            break;
        }
        case 8:{
            //Boilers
            if (choosedBoilers < boilers.count){
                
                itm = boilers[choosedBoilers];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden =YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
                cell.clipsToBounds = YES;
            }
            break;
        }
        case 7:{
            //Hot Water
           // Item *itm;
            if (choosedHotWater < hotwater.count){
                itm = hotwater[choosedHotWater];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
                cell.clipsToBounds = YES;
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        default:
            break;
    }
    
    cell.photo.image = nil;
    cell.manufacturerLabel.text = @"";
    cell.priceLabel.text = @"";
    cell.modelName.text = itm.modelName;
    cell.optionLabel.text =  [NSString stringWithFormat:@"Select Option : %@",itm.finalOption];
    [cell.buyButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchDown];
    [cell.removeButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchDown];
    cell.clipsToBounds = YES;
    
  
    if (![itm.finalOption isEqualToString:@"None"]) {

        cell.photo.image = [UIImage imageWithData:itm.photo];
        cell.manufacturerLabel.text = itm.manu;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", itm.finalPrice];
        cell.buyButton.tag = indexPath.section;
        cell.removeButton.tag = indexPath.section;

        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchDown];
        [cell.removeButton addTarget:self action:@selector(remButton:) forControlEvents:UIControlEventTouchDown];
    }

    return cell;
}

-(void) celltapped:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
    HardTableViewCell *swipedCell = [tableViewX cellForRowAtIndexPath:swipedIndexPath];
    
   // NSLog(@"section %d",swipedIndexPath.section);
    if (!swipedCell.tapped) {
        swipedCell.tapped = TRUE;
       // swipedCell.photo.hidden = YES;
       // swipedCell.buyButton.hidden = YES;
     
        //  swipedCell.removeButton.hidden = YES;
      
        //swipedCell.pickerView.hidden = YES;
       // swipedCell.modelName.hidden = YES;
       // swipedCell.hidden = YES;
        tapped = TRUE;
        tappedSection = swipedIndexPath.section;
        [tableViewX reloadData];

          } else {
         [sections removeObject:[NSNumber numberWithInt:tappedSection]];
        swipedCell.tapped = FALSE;
              
               [tableViewX reloadData];
        if (swipedIndexPath.section != 6 || swipedIndexPath.section != 5) {
            swipedCell.photo.hidden = NO;
          
            swipedCell.modelName.hidden = NO;
        } else {
            swipedCell.photo.hidden = NO;
           
            swipedCell.modelName.hidden = NO;

            swipedCell.buyButton.hidden = NO;
            swipedCell.removeButton.hidden = NO;
            [swipedCell bringSubviewToFront:swipedCell.buyButton];
        }
     
       NSLog(@"sections has ** %d",sections.count);
              

    }
    
    
}


#pragma mark - TableView Helpers


-(void)rl {
    [tableViewX reloadData];
}


-(void) cellSwiped:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
 //   HardTableViewCell *swipedCell = (HardTableViewCell*)[tableViewX cellForRowAtIndexPath:swipedIndexPath];
    BOOL change = FALSE;
    Item *itm;
    if (swipedIndexPath.section == 0) {
        
        if (airCon.count > 0 && choosedAirCon < airCon.count-1) {
            itm = airCon[choosedAirCon];
            [self removeTheProd:itm];
            itm=airCon[(choosedAirCon+1)];
            [self purchase:itm];
            choosedAirCon++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 2) {
        if (heatPump.count > 0 && choosedHeatPump < heatPump.count-1) {
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];
            itm=heatPump[(choosedHeatPump+1)];
            [self purchase:itm];

            choosedHeatPump++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 1) {
        if (furn.count > 0 && choosedFurn < furn.count-1) {
            itm = furn[choosedFurn];
            [self removeTheProd:itm];
            itm=furn[(choosedFurn+1)];
            [self purchase:itm];

            choosedFurn++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 3) {
        if (airH.count >0  && choosedAirH < airH.count -1) {
            itm = airH[choosedAirH];
            [self removeTheProd:itm];
            itm=airH[(choosedAirH+1)];
            [self purchase:itm];

            choosedAirH++;
            change = YES;
        } else {
            
        }
        
        
    }
    if (swipedIndexPath.section == 4) {
        if (geo.count > 0 && choosedGeo < geo.count-1 ) {
            itm = geo[choosedGeo];
            [self removeTheProd:itm];
            itm=geo[(choosedGeo+1)];
            [self purchase:itm];

            choosedGeo++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 6) {
        
        
        if (iaq.count > 0 && choosedIAQ < iaq.count-1 ) {
            itm = iaq[choosedIAQ];
           // [self removeTheProd:itm];
            itm=iaq[(choosedIAQ+1)];
          //  [self purchase:itm];
            choosedIAQ++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 5) {
        if ( acces.count > 0  && choosedAcces < acces.count-1) {
            choosedAcces++;
            change = YES;
        } else {
            
        }
        
    }

    if (swipedIndexPath.section == 8) {
        if ( boilers.count > 0  && choosedBoilers < boilers.count-1) {
            itm = boilers[choosedBoilers];
            [self removeTheProd:itm];
            itm=boilers[(choosedBoilers+1)];
            [self purchase:itm];

            choosedBoilers++;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 7) {
        if ( hotwater.count > 0  && choosedHotWater < hotwater.count-1) {
            itm = hotwater[choosedHotWater];
            [self removeTheProd:itm];
            itm= hotwater[(choosedHotWater+1)];
            [self purchase:itm];

            choosedHotWater++;
            change = YES;
            
        } else {
            
        }
        
    }
    if (change) {
        
        change = NO;
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:swipedIndexPath.row inSection:swipedIndexPath.section];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [tableViewX reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        [self warn];
    }
    
}

-(void) cellSwipedLeft:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
    
    Item *itm;
    BOOL change = FALSE;
    if (swipedIndexPath.section == 0) {
        
        if (choosedAirCon > 0) {
             itm = airCon[choosedAirCon];
             [self removeTheProd:itm];
            itm=airCon[(choosedAirCon-1)];
            [self purchase:itm];
             choosedAirCon--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 2) {
        if (choosedHeatPump > 0) {
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];
            itm=heatPump[(choosedHeatPump-1)];
            [self purchase:itm];
            choosedHeatPump--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 1) {
        if (choosedFurn > 0) {
            itm = furn[choosedFurn];
            [self removeTheProd:itm];
            itm=furn[(choosedFurn-1)];
            [self purchase:itm];
            choosedFurn--;
            change = YES;
        } else {
            [self warn];
        };
    }
    if (swipedIndexPath.section == 3) {
        if (choosedAirH > 0) {
            itm = airH[choosedAirH];
            [self removeTheProd:itm];
            itm=airH[(choosedAirH-1)];
            [self purchase:itm];
            choosedAirH--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 4) {
        if (choosedGeo > 0) {
            itm = geo[choosedGeo];
            [self removeTheProd:itm];
            itm=geo[(choosedGeo-1)];
            [self purchase:itm];
            choosedGeo--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 6) {
        if (choosedIAQ > 0) {
            choosedIAQ--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 5) {
        if (choosedAcces > 0) {
            choosedAcces--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 8) {
        if ( choosedBoilers > 0) {
            itm = boilers[choosedBoilers];
            [self removeTheProd:itm];
            itm=boilers[(choosedBoilers-1)];
            [self purchase:itm];
            
            choosedBoilers--;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 7) {
        if ( choosedHotWater >0) {
            itm = hotwater[choosedHotWater];
            [self removeTheProd:itm];
            itm= hotwater[(choosedHotWater-1)];
            [self purchase:itm];
            choosedHotWater--;
            change = YES;
        } else {
            
        }
    }    if (change) {
        
        change = NO;
        
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:swipedIndexPath.row inSection:swipedIndexPath.section];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [tableViewX reloadRowsAtIndexPaths:rowsToReload withRowAnimation:YES];
      //  [self buildQuote];
    } else {
        // [self warn];
    }
    
}


#pragma mark -

-(void) warn {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"No more products to swipe" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [al show];
}

-(void) buyButton:(id)sender {
    int j = [sender tag];
    
    Item *itm;
    switch (j) {
        case 0:{
            //Air Conditioners
            itm = airCon[choosedAirCon];
            [self purchase:itm];
            break;
        }
        case 2:{
            itm = heatPump[choosedHeatPump];
            [self purchase:itm];
            break;
        }
        case 1:{
            itm = furn[choosedFurn];
            [self purchase:itm];
            break;
        }
        case 3:{
            itm = airH[choosedAirH];
            [self purchase:itm];
            break;
        }
        case 4:{
            //Geothermal
            itm = geo[choosedGeo];
            [self purchase:itm];
            break;
        }
        case 6:{
            //IAQ
            itm = iaq[choosedIAQ];
            [self purchase:itm];
            break;
        }
        case 5:{
            //Accessories
            itm = acces [choosedAcces];
            [self purchase:itm];
            break;
        }
            
        default:
            break;
    }
    
}

-(void) remButton:(id)sender {
    int j = [sender tag];
    Item *itm;
    switch (j) {
        case 0:{
            //Air Conditioners
            itm = airCon[choosedAirCon];
            [self removeTheProd:itm];
            break;
        }
        case 2:{
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];

            break;
        }
        case 1:{
            itm = furn[choosedFurn];
            [self removeTheProd:itm];

            break;
        }
        case 3:{
            itm = airH[choosedAirH];
            [self removeTheProd:itm];

            break;
        }
        case 4:{
            //Geothermal
            itm = geo[choosedGeo];
            [self removeTheProd:itm];

            break;
        }
        case 6:{
            //IAQ
            itm = iaq[choosedIAQ];
            [self removeTheProd:itm];

            break;
        }
        case 5:{
            //Accessories
            itm = acces [choosedAcces];
            [self removeTheProd:itm];

            break;
        }
            
        default:
            break;
    }
}


-(void) purchase:(Item *)itm {
    if ([itm.finalOption isEqualToString:@"None"]) {
      /*  UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat: @"You have chosen an invalid option.\nPlease choose a valid option"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [al show];*/

    } else {
         [_cartItems addObject:itm];
        
    }
        
        
          NSLog(@"Purchased cart has %d items",_cartItems.count);
        
        
        if ([itm.type isEqualToString:@"IAQ"]||[itm.type isEqualToString:@"Accessories"]) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Item Added" message:[NSString stringWithFormat: @"You have just added %@ to your cart",itm.modelName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [al show];
        }
    
    
   
    isLast     = TRUE;
   [self buildQuote];
   
}



-(void) removeTheProd:(Item *)itm {
    
    Item *del;
    BOOL done = FALSE;
    for (int x = 0; x < _cartItems.count; x ++) {
        Item *itemz = _cartItems[x];
        if ([itemz.modelName isEqualToString:itm.modelName] && !done) {
            del = itemz;
            done = TRUE;
        }
    }
    
    [_cartItems removeObject:del];

    
    if (!done && [itm.typeID intValue] == 3) {
            UIAlertView *alx = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat: @"You need to add %@ before you can remove it!",itm.modelName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alx show];
    }
    
    [self buildQuote];
    NSLog(@"** removed ** cart has %d items",_cartItems.count);
}


-(void)receiveData:(NSArray *)theRebateData :(NSArray *)purchData {

  //  rebates = [[NSArray alloc]initWithArray:theRebateData];
    if (_cartItems.count == 0) {
        [_cartItems addObjectsFromArray:purchData];
    }
    NSLog(@"Cart has %lu items",(unsigned long)_cartItems.count);
    
}


-(float) parseTheString:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 1) {

    NSString *stringy = strip[1];
//    NSLog(@"Strip holds %d the first is %@ and second %@",strip.count, strip[0], strip[1]);
    
    
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:stringy.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:stringy];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
   // NSLog(@"%@", strippedString); // "123123123"

    return [strippedString floatValue];
    } else {
        return [string floatValue];;
    }
}



-(NSString *) parseTheOptionName:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 0) {
        
              return strip[0];
    } else {
        return @"";
    }
}



#pragma mark - Update Labels
-(void) buildQuote {
    
      // new formula;
    
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    
    for (int jj = 0; jj <_cartItems.count; jj++) {
        Item *itm = _cartItems[jj];
       // NSLog(@"%@",itm.finalOption);
        if ([itm.type isEqualToString:@"TypeThree"]&&[itm.optionOne floatValue]!=0)
        {
          totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
        }
        else
        {
        totalAmount += [itm.finalPrice floatValue];
        }
    }
    
    for (int jj = 0; jj <additemsB.count; jj++) {
        Item *itm = additemsB[jj];
        // NSLog(@"%@",itm.finalOption);
        if ([itm.type isEqualToString:@"TypeThree"]&&[itm.optionOne floatValue]!=0)
        {
            totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
        }
        else
        {
            totalAmount += [itm.finalPrice floatValue];
        }
    }

    
    
    
    for (int jj = 0; jj <rebates.count; jj++) {
        Item *itm = rebates[jj];
        totalSavings += [itm.finalPrice floatValue];
    }

    float invest;
    switch (months) {
        case 24:
        {
 
            finacePay =  (totalAmount - totalSavings)/24;//.915
            invest = (finacePay*24);
            NSLog(@"sdsd = %f, asdasd= %f",totalAmount, totalSavings);
            break;
        }
            
        case 36:
        {
            finacePay = (totalAmount - totalSavings)/.88/36;
              invest = (finacePay*36);
            break;
        }
        case 48:{
            finacePay = (totalAmount - totalSavings)/.865/48;
              invest = (finacePay*48);
            break;
        }
        case 60:{
            finacePay = (totalAmount - totalSavings)/.85/60;
              invest = (finacePay*60);
            break;
        }
            //(((C4 / .8975) * 0.0144)*84)
        case 84:{
            finacePay = ((totalAmount - totalSavings)/.8975) * 0.0144;
            invest = (totalAmount - totalSavings)/.8975;
            break;
        }
        case 144:{
            finacePay = ((totalAmount - totalSavings)/.909) * 0.0111;
            invest = (totalAmount - totalSavings)/.909;
            break;
        }
        default:
        {
            finacePay = totalAmount - totalSavings;
            invest=  (totalAmount - totalSavings);
            break;
        }
    }
    
    [self updateLabels:invest :totalSavings :afterSavings :finacePay :monthlyPay ];
}


-(void) updateLabels:(float)total :(float)totalSave :(float)afterSaving :(float)financeP :(float)month {
    
    totalAmountLabel.text = [NSString stringWithFormat:@"Total Amount\n$%.0f",total];
    totalSavingsLabel.text = [NSString stringWithFormat:@"Total Savings\n$%.0f",totalSave];
    afterSavingsLabel.text = [NSString stringWithFormat:@"After Savings\n$%.0f",afterSaving];
    financeMonthLabel.text = [NSString stringWithFormat:@"0%% Financing\nMonthlyPayment\n$%.0f",financeP];
    monthlyPayment.text = [NSString stringWithFormat:@"Monthly Payment\n$%.0f",month];
    
    //new
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    
    
    
    
    lblSystemRebates.text=[NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalSave]]];
     lblInvestemts.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]]];
    lblFinancingValue.text = [NSString stringWithFormat:@"$%@",[nf stringFromNumber:[NSNumber numberWithFloat:finacePay]]];
    switch (months) {
        case 84:
            //3.99% Best Rate 84 Months
             lblFinancing.text =[NSString stringWithFormat:@"3.99%% Best Rate \n%i Months\n",months];
            break;
        case 144:
             lblFinancing.text =[NSString stringWithFormat:@"7.99%% Lowest Payment \n%i Months\n",months];
            break;
        
        case 0:
            lblFinancing.text =[NSString stringWithFormat:@""];
            break;

        default:
             lblFinancing.text =[NSString stringWithFormat:@"0%% Financing\n%i Equal Payments\n",months];
            break;
    }
    
   
    NSMutableAttributedString *TitleText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",lblFinancing.text,lblFinancingValue.text]];
   // NSArray *aStrings=[btnTitleText.string componentsSeparatedByString:separator];
    
    NSMutableAttributedString *chargeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",lblFinancing.text]];
    NSDictionary *chargeAttr=@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]};
    NSDictionary *moneyAttr=@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]};
    
    [TitleText setAttributes:chargeAttr range:NSMakeRange(0,[chargeStr length])];
    [TitleText setAttributes:moneyAttr range:NSMakeRange([chargeStr length],[TitleText length]-[chargeStr length])];
    [lblFinancing setAttributedText:TitleText];
    
   
      [tableViewX reloadData];
}


#pragma mark - CartBtn Action
- (IBAction)cartButon:(id)sender {
    [self performSegueWithIdentifier:@"cart" sender:nil];
}


- (IBAction)rebateButton:(id)sender {
    [self performSegueWithIdentifier:@"rebate" sender:self];
}


#pragma mark - Buttons Actions
- (IBAction)monthBut:(id)sender {
    int mon = [sender tag];
    months = mon;
   
    secView.hidden = YES;
    [self buildQuote];
}

- (IBAction)doneBut:(id)sender {
    secView.hidden = YES;
}



- (IBAction)finBut:(id)sender {
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
}


- (IBAction)btnFinancing:(id)sender {
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
}



#pragma mark - CartBtns Actions
- (IBAction)btncart1:(id)sender {
    [self performSegueWithIdentifier:@"savedCart" sender:self];
}


- (IBAction)btnCart2:(id)sender {
      [self performSegueWithIdentifier:@"savedCart" sender:self];
}



- (IBAction)btnCart3:(id)sender {
      [self performSegueWithIdentifier:@"savedCart" sender:self];
}




#pragma mark - Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"rebate"]) {
        RebateQuoteTableViewController *rq = segue.destinationViewController;
        rq.managedObjectContext = managedObjectContext;
        rq.purch = _cartItems ;
        rq.delegate = self;
    }
    
    
    if ([segue.identifier isEqualToString:@"cart"]) {
        
        CartViewController *cartView = segue.destinationViewController;
        NSMutableArray *tt = [[NSMutableArray alloc]initWithArray:_cartItems];
        
        for (int jj = 0; jj <additemsB.count; jj++) {
            Item *itm = additemsB[jj];
            NSLog(@"item name : %@",itm.modelName);
            [tt addObject:itm];
        }
        
        NSMutableDictionary * cart = [[NSMutableDictionary alloc]init];
        [cart setObject:tt forKey:@"cartItems"];
        [cart setObject:[NSNumber numberWithInt:months] forKey:@"cartMonths"];
        [cart setObject:rebates forKey:@"cartRebates"];
        cartView.testerVC = self;
        
        self.carts = [[NSMutableArray alloc]initWithArray:@[cart]];
        cartView.carts = self.carts;
        [cartView.cartstableView reloadData];
    }
    
    
    
    if ([segue.identifier isEqualToString:@"savedCart"]) {
        CartViewController *cartView = segue.destinationViewController;
        cartView.testerVC = self;
        
        self.carts = [[NSMutableArray alloc] initWithArray:self.savedCarts];
        cartView.carts = self.carts;
        [cartView.cartstableView reloadData];
    }
}


@end
