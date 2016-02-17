//
//  MenuViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// ==================== API URLs =====================
#define kAdd2CartURL [NSURL URLWithString:@"http://www.hvactek.com/api/add2cart/?id=0&page=0&limit=0&order=title,asc&api_key=12b5401c039fe55e8df6304d8fcc121e"]
#define kAdd2CartSyncURL [NSURL URLWithString:@"http://www.hvactek.com/api/add2cart_sync/?id=0&page=0&limit=0&order=title,asc&api_key=12b5401c039fe55e8df6304d8fcc121e"]


//http://www.hvactek.com/
//http://hvactek.devebs.net/

#import "MenuViewController.h"
#import "Photos.h"
#import "THProgressView.h"
#import "DataLoader.h"

static const CGSize progressViewSize = { 300.0f, 20.0f };

typedef void(^myCompletion)(BOOL);

@interface MenuViewController ()

@property (nonatomic, strong) THProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *lastSyncLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *add2cartButton;

@end

@implementation MenuViewController
@synthesize managedObjectContext;
@synthesize prodFRC;

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
  
  AppDelegate *apDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
  managedObjectContext = apDel.managedObjectContext;
  
  [self checkSyncStatus];
  [self initializeProgressBar];
}


-(void)syncLabelStatus:(BOOL)status {
  self.syncStatusLabel.hidden = !status;
}


-(void)syncDateLabel:(NSString *)sync_date {
  
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  NSDate *syncDate = [dateFormatter dateFromString:sync_date];
  [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  NSString *syncString = [dateFormatter stringFromDate:syncDate];
  
  NSString *lastSync = [NSString stringWithFormat:@"Last Sync Date: %@", syncString];
  self.lastSyncLabel.text = lastSync;
}


- (void)startSyncing:(BOOL)starting {
  if (starting == YES) {
    self.add2cartButton.hidden = YES;
    self.syncProgressLabel.hidden = NO;
    self.progressBar.hidden = NO;
    [self.syncButton setHidden:YES];
    [self.syncStatusLabel setHidden:YES];
    [self.lastSyncLabel setHidden:YES];
  }else{
    self.add2cartButton.hidden = NO;
    self.syncProgressLabel.hidden = YES;
    self.progressBar.hidden = YES;
    //[self.syncButton setHidden:NO];
    [self.lastSyncLabel setHidden:NO];
    [self.progressBar setProgress:0.0];
    [self.syncProgressLabel setText:@"Sync In Progress - 0%"];
  }
}


#pragma mark - ProgressBar
- (void)initializeProgressBar {
  self.progressBar = [[THProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - progressViewSize.width / 2.0f,
                                                                                     CGRectGetMidY(self.view.frame) - progressViewSize.height / 2.0f,
                                                                                     progressViewSize.width,
                                                                                     progressViewSize.height)];
  self.progressBar.borderTintColor = [UIColor colorWithRed:118.0/255.0 green:189.0/255.0 blue:29.0/255.0 alpha:1.0];
  self.progressBar.progressTintColor = [UIColor colorWithRed:118.0/255.0 green:189.0/255.0 blue:29.0/255.0 alpha:1.0];
  self.progressBar.progressBackgroundColor = [UIColor whiteColor];
  self.progressBar.hidden = YES;
  [self.view addSubview:self.progressBar];
}


- (void)updateProgressForValue:(NSNumber *)newValue
{
  [self.progressBar setProgress:[newValue floatValue] animated:YES];
}


#pragma mark - Check For Sync
- (void)checkSyncStatus {
  NSString *token =[[DataLoader sharedInstance] token];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kAdd2CartSyncURL];
  [request setTimeoutInterval: 10.0];
  [request setValue:token forHTTPHeaderField:@"TOKEN"];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue currentQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           
                           if (data != nil && error == nil) {
                             [self performSelectorOnMainThread:@selector(fetchAdd2CartSyncStatus:) withObject:data waitUntilDone:NO];
                           }
                           else {
                             NSLog(@"add2CartSyncStatus error: %@",error);
                           }
                         }];
}


- (void)fetchAdd2CartSyncStatus:(NSData *)responseData {
  NSError* error;
  NSDictionary* json = [NSJSONSerialization
                        JSONObjectWithData:responseData
                        options:kNilOptions
                        error:&error];
  
  if ([[json objectForKey:@"message"] isEqualToString:@"Succes"]) {
    NSDictionary* itemsDict = [json objectForKey:@"results"];
    BOOL syncStatus = [[itemsDict objectForKey:@"sync"] boolValue];
    [self syncLabelStatus:syncStatus];
    [self syncDateLabel:[itemsDict objectForKey:@"sync_date"]];
  }
}



#pragma mark - Fetched ADD2CART Items
- (void)fetchedAdd2CartItems:(NSDictionary *)responseData {
  
  NSArray* rebates = [responseData objectForKey:@"rebates"];
  NSArray* products = [responseData objectForKey:@"products"];
  NSArray* systProducts = [responseData objectForKey:@"system_products"];
  
  if (rebates.count > 0) {
    [self addRebates:rebates];
  }
  
  if (systProducts.count > 0) {
    [self addSystemProducts:systProducts];
  }
  
  if (products.count > 0) {
    [self addProducts:products];
  }
}




#pragma mark - Add Products
-(void) addProducts:(NSArray *)products {
  [self addProductsCartOne:products];
  [self addProductsCartTwo:products];
  [self addProductsCartThree:products];
  
  self.lastSyncLabel.text = @"Last Sync Date: Now";
  [self startSyncing:NO];
    
    NSError *errorz;
    if (![managedObjectContext save:&errorz]) {
        NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
    }
}




#pragma mark - Fetch System Products
-(void)addSystemProducts:(NSArray *)systemProd {
  
  for (int i = 0; i < 3; i++) {
    
    for (NSDictionary *itm in systemProd) {
      
      Item *item= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
      item.modelName = itm[@"modelName"];
      item.finalPrice = [NSNumber numberWithFloat:[itm[@"finalPrice"] floatValue]];
      item.type = itm[@"type"];
      item.include = [itm[@"include"] isEqualToString:@"1"]? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
      item.ord = [NSNumber numberWithInt:[itm[@"ord"] intValue]];
      item.currentCart = [NSNumber numberWithInt:i];
    }
    
    
    Item *itemA= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
    itemA.modelName = @"No Product Selected";
    itemA.finalOption = @"None";
    itemA.finalPrice = [NSNumber numberWithFloat:0.0f];
    itemA.type = @"Blank";
    itemA.currentCart = [NSNumber numberWithInt:i];
  }
}




#pragma mark - Add Rebates
-(void) addRebates:(NSArray *)rebates {
    NSMutableArray *newRebates = [[NSMutableArray alloc]initWithCapacity:rebates.count];
  
    for (int i = 0; i < 3; i++) {
      
      
        for (int x = 0; x < rebates.count; x++) {
            Item *itm;
            // NSString *inc = [rebates[x] objectForKey:@"included"];
            //int incl = [inc intValue];
            
            //  if (incl == 1) {
            itm = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            itm.modelName = [rebates[x] objectForKey:@"title"];
            NSString *price = [rebates[x] objectForKey:@"amount"];
            // itm.include = [NSNumber numberWithBool:0];
            itm.finalPrice = [NSNumber numberWithFloat:[price floatValue]];
            itm.type = @"Rebates";
            itm.typeID = [NSNumber numberWithInt:[rebates[x][@"id"] intValue] + 999];//[NSNumber numberWithInt:99];
            itm.ord = [NSNumber numberWithInt:[rebates[x][@"ord"] intValue]];
            itm.currentCart = [NSNumber numberWithInt:i];
          
            //add the item
            [newRebates addObject:itm];
            //}
            
        }// end of for loop
        
    }
}




#pragma mark - Segues
- (IBAction)productAdmin:(id)sender {
    [self performSegueWithIdentifier:@"prodAdmin" sender:self];
}


- (IBAction)newQuote:(id)sender {
//  NSError *errorz;
//  if (![managedObjectContext save:&errorz]) {
//    NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
//  }
  
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"workingCurrentCartIndex"];
    [self performSegueWithIdentifier:@"quoteFirst" sender:self];
}



#pragma mark - Sync Button Clicked
- (IBAction)synCButton:(id)sender {
  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"newSession"];

  [self startSyncing:YES];
  [self clearEverything];

  [[DataLoader sharedInstance] getAdd2CartProducts:kAdd2CartURL
                                         onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                           //[self performSelectorInBackground:@selector(fetchedAdd2CartItems:) withObject:reciveData];
                                           
                                            [self performSelectorOnMainThread:@selector(fetchedAdd2CartItems:) withObject:reciveData waitUntilDone:NO];
                                             //[self fetchedAdd2CartItems:reciveData];
                                         }onError:^(NSError *error) {
                                           ShowOkAlertWithTitle(error.localizedDescription, self);
                                         }];
  
  
  
  
  /*
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kAdd2CartURL];
  [request setTimeoutInterval: 10.0];
  [request setValue:token forHTTPHeaderField:@"TOKEN"];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           
                           if (data != nil && error == nil)
                           {
                             dispatch_async(dispatch_get_main_queue(), ^{
                               self.syncProgressLabel.text = @"asdasdasd";
                               [self fetchedAdd2CartItems:data];
                             });
                             
                             
                            // [self performSelectorOnMainThread:@selector(fetchedAdd2CartItems:) withObject:data waitUntilDone:NO];
                           }
                           else
                           {
                             NSLog(@"add2Cart sync error: %@",error);
                             [self startSyncing:NO];
                           }
                         }];
  */
  
  [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"newSession"];
}




#pragma mark - Clear Everything
-(void) clearEverything {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
  NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"modelName" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
  fetchRequest.sortDescriptors = sortDescriptors;
  [fetchRequest setEntity:entity];
  
  NSError *fetchingError = nil;
  
  NSArray *occP = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchingError];
  
  if (![occP count]) {
    
  } else  {
    for (int i = 0; i<occP.count; i++) {
      Item  *del = occP[i];
      [managedObjectContext deleteObject:del];
    }
  }
}

/*-(void) clearProducts {
 
 NSArray *types = [[NSArray alloc]initWithObjects:@"Air Conditioners",@"Heat Pumps", @"Furnaces",@"Air Handlers"
 ,@"Geothermal", @"IAQ",@"Accessories", nil];
 Item *del;
 
 
 for (int z=0; z<types.count; z++) {
 
 NSString *type = types[z];
 
 NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
 req.predicate = [NSPredicate predicateWithFormat:@"type = %@",type];
 NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
 req.sortDescriptors =[NSArray arrayWithObject:sort];
 
 NSError *error = nil;
 NSArray *occP = [managedObjectContext executeFetchRequest:req error:&error];
 
 if (![occP count]) {
 
 } else  {
 for (int i = 0; i<occP.count; i++) {
 del = occP[i];
 [managedObjectContext deleteObject:del];
 }
 }
 }
 
 }*/


/*-(void) clearRebates {
 Item *del;
 NSString *type = @"Rebates";
 
 NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
 req.predicate = [NSPredicate predicateWithFormat:@"type = %@",type];
 NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
 req.sortDescriptors =[NSArray arrayWithObject:sort];
 
 NSError *error = nil;
 NSArray *occ = [managedObjectContext executeFetchRequest:req error:&error];
 
 if (![occ count]) {
 
 } else  {
 for (int i = 0; i<occ.count; i++) {
 del = occ[i];
 [managedObjectContext deleteObject:del];
 }
 
 }
 }
 
 -(void) checkMem:(NSString *)type {
 NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
 req.predicate = [NSPredicate predicateWithFormat:@"type = %@",type];
 NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
 req.sortDescriptors =[NSArray arrayWithObject:sort];
 
 NSError *error = nil;
 NSArray *occ = [managedObjectContext executeFetchRequest:req error:&error];
 
 if (![occ count]) {
 
 } else  {
 
 }
 
 }*/




#pragma mark - add products for carts
- (void)addProductsCartOne:(NSArray *)products {
    NSMutableArray *newProd = [[NSMutableArray alloc]initWithCapacity:products.count];
  
    for (int x = 0; x < products.count; x++) {
      
        Item *itm;
        NSArray *options;
        //Check to see if we want this profuct.
        NSString *inc = [products[x] objectForKey:@"included"];
        int incl = [inc intValue];
        if (incl == 1) {
            //Include this product.
          itm = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            itm.modelName = [products[x] objectForKey:@"title"];
            itm.manu = [products[x] objectForKey:@"manufacture_name"];
            options = [products[x] objectForKey:@"options"];
            itm.include = [NSNumber numberWithBool:incl];
            itm.type = [products[x] objectForKey:@"category_name"];
            NSString *tID = [products[x] objectForKey:@"types"];
            itm.typeID = [NSNumber numberWithInt:[tID intValue]];
            itm.ord = [NSNumber numberWithInt:[products[x][@"ord"] intValue]];
            itm.currentCart = [NSNumber numberWithInt:0];
          
            //Options
            for (int o=0; o<options.count; o++) {
                NSString *priced = [options[o] objectForKey:@"price"];
                NSString *name = [options[o] objectForKey:@"name"];
                if (o == 0) {
                    
                    itm.optionOne = name;
                    itm.optOnePrice =[NSNumber numberWithFloat: [priced floatValue]];
                    
                } else if (o ==1 ){
                    itm.optionTwo = name;
                    itm.optTwoPrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==2){
                    itm.optionThree = name;
                    itm.optThreePrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==3) {
                    itm.optionFour = name;
                    itm.optFourPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==4) {
                    itm.optionFive = name;
                    itm.optFivePrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==5) {
                    itm.optionSix = name;
                    itm.optSixPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==6) {
                    itm.optionSeven = name;
                    itm.optSevenPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==7) {
                    itm.optionEight = name;
                    itm.optEightPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }
                
            } //end of options
          
          
          NSString *urly = [products[x] objectForKey:@"full_url"];
          itm.image = [self insertPhotosToDataBaseWithPath:urly];

            NSString *type = [products[x] objectForKey:@"category_name"];
            if ([type isEqualToString:@"AC"]) {
                itm.type = @"Air Conditioners";
            }
            //Add the new item to new products.
            [newProd addObject:itm];
        }
      
      float value = (float)x / (float)products.count;
      int percent = value * 100;
      NSString *str = [NSString stringWithFormat:@"Sync In Progress - %d%%", percent];
      [self.syncProgressLabel performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];
      [self performSelectorOnMainThread:@selector(updateProgressForValue:) withObject:[NSNumber numberWithFloat:value] waitUntilDone:YES];
    }
}




- (void)addProductsCartTwo:(NSArray *)products {
    NSMutableArray *newProd = [[NSMutableArray alloc]initWithCapacity:products.count];
    
    for (int x = 0; x < products.count; x++) {
        
        Item *itm;
        NSArray *options;
        //Check to see if we want this profuct.
        NSString *inc = [products[x] objectForKey:@"included"];
        int incl = [inc intValue];
        if (incl == 1) {
            //Include this product.
            itm = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            itm.modelName = [products[x] objectForKey:@"title"];
            itm.manu = [products[x] objectForKey:@"manufacture_name"];
            options = [products[x] objectForKey:@"options"];
            itm.include = [NSNumber numberWithBool:incl];
            itm.type = [products[x] objectForKey:@"category_name"];
            NSString *tID = [products[x] objectForKey:@"types"];
            itm.typeID = [NSNumber numberWithInt:[tID intValue]];
            itm.ord = [NSNumber numberWithInt:[products[x][@"ord"] intValue]];
            itm.currentCart = [NSNumber numberWithInt:1];
          
            //Options
            for (int o=0; o<options.count; o++) {
                NSString *priced = [options[o] objectForKey:@"price"];
                NSString *name = [options[o] objectForKey:@"name"];
                if (o == 0) {
                    
                    itm.optionOne = name;
                    itm.optOnePrice =[NSNumber numberWithFloat: [priced floatValue]];
                    
                } else if (o ==1 ){
                    itm.optionTwo = name;
                    itm.optTwoPrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==2){
                    itm.optionThree = name;
                    itm.optThreePrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==3) {
                    itm.optionFour = name;
                    itm.optFourPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==4) {
                    itm.optionFive = name;
                    itm.optFivePrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==5) {
                    itm.optionSix = name;
                    itm.optSixPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==6) {
                    itm.optionSeven = name;
                    itm.optSevenPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==7) {
                    itm.optionEight = name;
                    itm.optEightPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }
                
            } //end of options
            
            NSString *urly = [products[x] objectForKey:@"full_url"];
          itm.image = [self insertPhotosToDataBaseWithPath:urly];
          
            NSString *type = [products[x] objectForKey:@"category_name"];
            if ([type isEqualToString:@"AC"]) {
                itm.type = @"Air Conditioners";
            }
            //Add the new item to new products.
            [newProd addObject:itm];
        }
    }
}



- (void)addProductsCartThree:(NSArray *)products {
    NSMutableArray *newProd = [[NSMutableArray alloc]initWithCapacity:products.count];
    
    for (int x = 0; x < products.count; x++) {
        
        Item *itm;
        NSArray *options;
        //Check to see if we want this profuct.
        NSString *inc = [products[x] objectForKey:@"included"];
        int incl = [inc intValue];
        if (incl == 1) {
            //Include this product.
            itm = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            itm.modelName = [products[x] objectForKey:@"title"];
            itm.manu = [products[x] objectForKey:@"manufacture_name"];
            options = [products[x] objectForKey:@"options"];
            itm.include = [NSNumber numberWithBool:incl];
            itm.type = [products[x] objectForKey:@"category_name"];
            NSString *tID = [products[x] objectForKey:@"types"];
            itm.typeID = [NSNumber numberWithInt:[tID intValue]];
            itm.ord = [NSNumber numberWithInt:[products[x][@"ord"] intValue]];
            itm.currentCart = [NSNumber numberWithInt:2];
            
            //   NSLog(@"Iten is %@ type and include is %@",itm.type,itm.include);
            
            //Options
            for (int o=0; o<options.count; o++) {
                NSString *priced = [options[o] objectForKey:@"price"];
                NSString *name = [options[o] objectForKey:@"name"];
                
                if (o == 0) {
                    
                    itm.optionOne = name;
                    itm.optOnePrice =[NSNumber numberWithFloat: [priced floatValue]];
                    
                } else if (o ==1 ){
                    itm.optionTwo = name;
                    itm.optTwoPrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==2){
                    itm.optionThree = name;
                    itm.optThreePrice =[NSNumber numberWithFloat: [priced floatValue]];
                } else if (o==3) {
                    itm.optionFour = name;
                    itm.optFourPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==4) {
                    itm.optionFive = name;
                    itm.optFivePrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==5) {
                    itm.optionSix = name;
                    itm.optSixPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==6) {
                    itm.optionSeven = name;
                    itm.optSevenPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }else if (o==7) {
                    itm.optionEight = name;
                    itm.optEightPrice =[NSNumber numberWithFloat: [priced floatValue]];
                }
            }
            
          NSString *urly = [products[x] objectForKey:@"full_url"];
          itm.image = [self insertPhotosToDataBaseWithPath:urly];
          
            NSString *type = [products[x] objectForKey:@"category_name"];
            if ([type isEqualToString:@"AC"]) {
                itm.type = @"Air Conditioners";
            }
            [newProd addObject:itm];
        }
    }
}




#pragma mark - Insert Photo in Core Data
- (Photos *)insertPhotosToDataBaseWithPath:(NSString *)stringPath {
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photos" inManagedObjectContext:managedObjectContext];
  NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"url = %@",stringPath];
  
  [fetchRequest setEntity:entity];
  [fetchRequest setPredicate:cartPredicate];
  
//  NSError *errorz;
//  if (![managedObjectContext save:&errorz]) {
//    NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
//  }
  
  NSError *fetchingError = nil;
  
  NSArray * productImages = [[NSArray alloc]init];
  productImages = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchingError];
    
  
  if ([productImages count] == 0) {
    Photos* pf = (Photos *)[NSEntityDescription insertNewObjectForEntityForName:@"Photos" inManagedObjectContext:self.managedObjectContext];
    
    NSURL *url = [NSURL URLWithString:stringPath];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:url];
    pf.photoData = imageData;
    pf.url = stringPath;
    
    
    return pf;
  }else {
    return productImages.firstObject;
  }
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


@end
