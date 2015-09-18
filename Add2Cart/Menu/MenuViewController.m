//
//  MenuViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kRebatesURL [NSURL URLWithString:@"http://www.api.signaturehvac.com/api/rebates/?id=&page=0&limit=0&order=title,asc&api_key=12b5401c039fe55e8df6304d8fcc121e"]
#define kProdURL [NSURL URLWithString:@"http://www.api.signaturehvac.com/api/products/?id=0&page=0&limit=0&order=title,asc&api_key=12b5401c039fe55e8df6304d8fcc121e"]
#define kSystemProdURL [NSURL URLWithString:@"http://www.api.signaturehvac.com/api/system_products/?id=0&page=0&limit=0&order=title,asc&api_key=12b5401c039fe55e8df6304d8fcc121e"]
#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize managedObjectContext;
@synthesize prodFRC;
@synthesize syncView;
@synthesize activity;

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
    // Do any additional setup after loading the view.
    
    AppDelegate *apDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = apDel.managedObjectContext;
    
    syncView.hidden = YES;
    [activity stopAnimating];
}

- (void)fetchedProducts:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* products = [json objectForKey:@"results"];
    
    if (products.count > 0) {
   
       [self addProducts:products];
      }
    
    NSLog(@"Products:%@",products);
  
}

-(void) clearEverything {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"modelName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    
    
    self.prodFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.prodFRC.delegate = self;
    
    NSError *fetchingError = nil;
    if ([self.prodFRC performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched ");
        
    } else {
        NSLog(@"Failed to get the result");
    }
    
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


-(void) addProducts:(NSArray *)products {
    
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
            
        } //end of options
         
       
             //JB Do we need this now
             /*
             if (!itm.optionFour) {
             itm.optionFour  = @"No Option $ -";
         }
         
         if (!itm.optionOne) {
             itm.optionOne  = @"No Option $ -";
         }
         
         if (!itm.optionTwo) {
             itm.optionTwo = @"No Option $ -";
         }
         
         if (!itm.optionThree) {
            itm.optionThree  = @"No Option $ -";
         }
         
         */
         
        NSString *urly = [products[x] objectForKey:@"full_url"];
        NSURL *url = [NSURL URLWithString:urly];
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:url];
        itm.photo = imageData;
        NSString *type = [products[x] objectForKey:@"category_name"];
        if ([type isEqualToString:@"AC"]) {
            itm.type = @"Air Conditioners";
        }
         //Add the new item to new products.
        [newProd addObject:itm];
         }// end of if includeded.
         else {
             //Not adding this item.
         }
     
    
     }// end of for loop
    
      NSError *errorz;
    if (![managedObjectContext save:&errorz]) {
        NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
    }
    
    syncView.hidden = YES;
    [activity stopAnimating];
    }

- (void)fetchedRebates:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* rebates = [json objectForKey:@"results"];
    if (rebates.count > 0) {
       // [self clearRebates];
        [self addRebates:rebates];
    }
    //JB Stick in an nslog here if issue with rebates
 //  NSLog(@"Rebates:%@",rebates);
  //  [self checkMem:@"Rebates"];
}

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

-(void) addRebates:(NSArray *)rebates {
    
    NSMutableArray *newRebates = [[NSMutableArray alloc]initWithCapacity:rebates.count];

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
             itm.typeID = [NSNumber numberWithInt:99];
             itm.ord = [NSNumber numberWithInt:[rebates[x][@"ord"] intValue]];
             //add the item
             [newRebates addObject:itm];
    //}
         
     }// end of for loop
    
     NSError *errorz;
    if (![managedObjectContext save:&errorz]) {
        NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)productAdmin:(id)sender {
    [self performSegueWithIdentifier:@"prodAdmin" sender:self];
}

- (IBAction)newQuote:(id)sender {
    [self performSegueWithIdentifier:@"quoteFirst" sender:self];

    
}


-(void)fetchSystemProducts:(NSData *)responseData{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    
    if (json) {
        NSArray * list = json[@"list"];
        
        
        for (NSDictionary *itm in list) {
            Item *item= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
            item.modelName = itm[@"modelName"];
            item.finalPrice = [NSNumber numberWithFloat:[itm[@"finalPrice"] floatValue]];
            item.type = itm[@"type"];
            item.include = [itm[@"include"] isEqualToString:@"1"]? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
            item.ord = [NSNumber numberWithInt:[itm[@"ord"] intValue]];
        }
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
        }
        
        Item *itemA= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
        itemA.modelName = @"No Product Selected";
        itemA.finalOption = @"None";
        itemA.finalPrice = [NSNumber numberWithFloat:0.0f];
        itemA.type = @"Blank";
        
    }
}

- (IBAction)synCButton:(id)sender {
    // if ([[NSUserDefaults standardUserDefaults]boolForKey:@"newSession"]) {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"newSession"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"type3"];


    [self clearEverything];
    syncView.hidden = NO;
    [activity startAnimating];
    
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kRebatesURL];
        [self performSelectorOnMainThread:@selector(fetchedRebates:)
                               withObject:data waitUntilDone:YES];
        
        
    });
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kProdURL];
        [self performSelectorOnMainThread:@selector(fetchedProducts:)
                               withObject:data waitUntilDone:YES];
        
        
    });

    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kSystemProdURL];
        [self performSelectorOnMainThread:@selector(fetchSystemProducts:)
                               withObject:data waitUntilDone:YES];
        
        
    });
//
    [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"newSession"];
    
    // } else {
    // }
    

}
@end
