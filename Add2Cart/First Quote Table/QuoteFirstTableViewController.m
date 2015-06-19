//
//  QuoteFirstTableViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 13/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "QuoteFirstTableViewController.h"
#import "testerViewController.h"

@interface QuoteFirstTableViewController ()
@property (retain, nonatomic) testerViewController *testerVC;
@end

@implementation QuoteFirstTableViewController
@synthesize managedObjectContext, prodFRC;
@synthesize firstOption;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    
    addedItems = [[NSMutableArray alloc]init];
 //   NSLog(@"added items has %d and passed were %d",addedItems.count,passed.count);
    
    NSLog(@"First option is heat value is %@ cool value is %@ ",firstOption.heatingValue,firstOption.coolingValue);

    
    first = [[NSUserDefaults standardUserDefaults]boolForKey:@"newSession"];
    
    if (first) {
        [self addDataOneOff];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"newSession"];
    }
    [self fetchData];
    [self sortData];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void) home {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//-(void) viewDidDisappear:(BOOL)animated
//{
//    [addedItems removeAllObjects];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addDataOneOff {
  
//    Item *itemD= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemD.modelName = @"A. Enlarge Existing 2 PVC To 3 PVC ";
//    itemD.finalPrice = [NSNumber numberWithFloat:995.0f];
//    itemD.include = [NSNumber numberWithBool:YES];
//    itemD.type = @"TypeTwo";
//    Item *itemE= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemE.modelName = @"B. 80% To 90% Furnace w/ 3rd Man ";
//    itemE.finalPrice = [NSNumber numberWithFloat:1295.00f];
//    itemE.type = @"TypeTwo";
//    itemE.include = [NSNumber numberWithBool:YES];
//    Item *itemF= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemF.modelName = @"C. Attic Replacement w/ 3rd Man";
//    itemF.finalPrice = [NSNumber numberWithFloat:1495.00f];
//    itemF.type = @"TypeTwo";
//    itemF.include = [NSNumber numberWithBool:YES];
//    Item *itemG= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemG.modelName = @"D. Core Drilling Through A Stone Wall";
//    itemG.finalPrice = [NSNumber numberWithFloat:695.00f];
//    itemG.type = @"TypeTwo";
//    itemG.include = [NSNumber numberWithBool:YES];
//    Item *itemH= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemH.modelName = @"E. Hot Water Heater Aluminum Chimney Liner";
//    itemH.finalPrice = [NSNumber numberWithFloat:895.00f];
//    itemH.type = @"TypeTwo";
//    itemH.include = [NSNumber numberWithBool:YES];
//    Item *itemI= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemI.modelName = @"F. Oil Tank Removal";
//    itemI.finalPrice = [NSNumber numberWithFloat:795.00f];
//    itemI.type = @"TypeTwo";
//    itemI.include = [NSNumber numberWithBool:YES];
//    Item *itemJ= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemJ.modelName = @"G. Outdoor Air Brace";
//    itemJ.finalPrice = [NSNumber numberWithFloat:395.00f];
//    itemJ.type = @"TypeTwo";
//    itemJ.include = [NSNumber numberWithBool:YES];
//    Item *itemK= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemK.modelName = @"H. Geothermal Hybrid System";
//    itemK.finalPrice = [NSNumber numberWithFloat:1595.00f];
//    itemK.type = @"TypeTwo";
//    itemK.include = [NSNumber numberWithBool:YES];
//    Item *itemL= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemL.modelName = @"I. Basement Lineset 50 - 80 Feet";
//    itemL.finalPrice = [NSNumber numberWithFloat:495.00f];
//    itemL.type = @"TypeTwo";
//    itemL.include = [NSNumber numberWithBool:YES];
//    Item *itemM= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemM.modelName = @"J. Basement Lineset 80 - 100 Feet";
//    itemM.finalPrice = [NSNumber numberWithFloat:795.00f];
//    itemM.type = @"TypeTwo";
//    itemM.include = [NSNumber numberWithBool:YES];
//    Item *itemN= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemN.modelName = @"K. Electric For Air Handler - AC To HP";
//    itemN.finalPrice = [NSNumber numberWithFloat:995.00f];
//    itemN.type = @"TypeTwo";
//    itemN.include = [NSNumber numberWithBool:YES];
//    Item *itemO= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemO.modelName = @"L. Add For Plaster Cut Job";
//    itemO.finalPrice = [NSNumber numberWithFloat:995.00f];
//    itemO.type = @"TypeTwo";
//    itemO.include = [NSNumber numberWithBool:YES];
//    
//    Item *itemP= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemP.modelName = @"M. Attic Lineset / Slim Duct - Per Foot";
//    itemP.finalPrice = [NSNumber numberWithFloat:50.00f];
//    itemP.type = @"TypeThree";
//    itemP.include = [NSNumber numberWithBool:YES];
//  
//    Item *itemQ= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemQ.modelName = @"N. Attic - 2nd Floor Supply Outlet";
//    itemQ.finalPrice = [NSNumber numberWithFloat:425.00f];
//    itemQ.type = @"TypeThree";
//    itemQ.include = [NSNumber numberWithBool:YES];
//    Item *itemU= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemU.modelName = @"O. Attic - 2nd Floor Return Inlet";
//    itemU.finalPrice = [NSNumber numberWithFloat:425.00f];
//    itemU.type = @"TypeThree";
//    itemU.include = [NSNumber numberWithBool:YES];
//    Item *itemV= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemV.modelName = @"P. Attic - 2nd Floor Central Return";
//    itemV.finalPrice = [NSNumber numberWithFloat:695.00f];
//    itemV.type = @"TypeThree";
//    itemV.include = [NSNumber numberWithBool:YES];
//    Item *itemW= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemW.modelName = @"Q. Attic - 1st Floor Supply Oulet";
//    itemW.finalPrice = [NSNumber numberWithFloat:875.00f];
//    itemW.type = @"TypeThree";
//    itemW.include = [NSNumber numberWithBool:YES];
//    Item *itemX= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemX.modelName = @"R. Attic - 1st Floor Return Inlet";
//    itemX.finalPrice = [NSNumber numberWithFloat:875.00f];
//    itemX.type = @"TypeThree";
//    itemX.include = [NSNumber numberWithBool:YES];
//    Item *itemY= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemY.modelName = @"S. Attic - Supply Trunkwork";
//    itemY.finalPrice = [NSNumber numberWithFloat:55.00f];
//    itemY.type = @"TypeThree";
//    itemY.include = [NSNumber numberWithBool:YES];
//    Item *itemZ= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemZ.modelName = @"T. Attic - Return Trunkwork";
//    itemZ.finalPrice = [NSNumber numberWithFloat:55.00f];
//    itemZ.type = @"TypeThree";
//    itemZ.include = [NSNumber numberWithBool:YES];
//    Item *itemAA= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAA.modelName = @"U. Attic - Remove Existing Trunkwork";
//    itemAA.finalPrice = [NSNumber numberWithFloat:195.00f];
//    itemAA.type = @"TypeThree";
//    itemAA.include = [NSNumber numberWithBool:YES];
//    Item *itemAB= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAB.modelName = @"V. Basement - 1st Floor Supply Outlet";
//    itemAB.finalPrice = [NSNumber numberWithFloat:325.00f];
//    itemAB.type = @"TypeThree";
//    itemAB.include = [NSNumber numberWithBool:YES];
//    Item *itemAC= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAC.modelName = @"W. Basement - 1st Floor Return Inlet";
//    itemAC.finalPrice = [NSNumber numberWithFloat:395.00f];
//    itemAC.type = @"TypeThree";
//    itemAC.include = [NSNumber numberWithBool:YES];
//    Item *itemAD= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAD.modelName = @"X. Basement - 1st Floor Central Return";
//    itemAD.finalPrice = [NSNumber numberWithFloat:495.00f];
//    itemAD.type = @"TypeThree";
//    itemAD.include = [NSNumber numberWithBool:YES];
//    Item *itemAE= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAE.modelName = @"Y. Basement - 2nd Floor Supply Outlet";
//    itemAE.finalPrice = [NSNumber numberWithFloat:795.00f];
//    itemAE.type = @"TypeThree";
//    itemAE.include = [NSNumber numberWithBool:YES];
//    Item *itemAF= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAF.modelName = @"Z. Basement - 2nd Floor Return Inlet";
//    itemAF.finalPrice = [NSNumber numberWithFloat:795.00f];
//    itemAF.type = @"TypeThree";
//    itemAF.include = [NSNumber numberWithBool:YES];
//    Item *itemAG= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAG.modelName = @"ZA. Basement - Supply Trunkwork";
//    itemAG.finalPrice = [NSNumber numberWithFloat:25.00f];
//    itemAG.type = @"TypeThree";
//    itemAG.include = [NSNumber numberWithBool:YES];
//    Item *itemAH= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAH.modelName = @"ZB. Basement - Return Trunkwork";
//    itemAH.finalPrice = [NSNumber numberWithFloat:25.00f];
//    itemAH.type = @"TypeThree";
//    itemAH.include = [NSNumber numberWithBool:YES];
//    Item *itemAI= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAI.modelName = @"ZC. Basement - Remove Existing Trunkwork";
//    itemAI.finalPrice = [NSNumber numberWithFloat:195.00];
//    itemAI.type = @"TypeThree";
//    itemAI.include = [NSNumber numberWithBool:YES];
//    Item *itemAJ= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAJ.modelName = @"ZE. Manual Balancing Damper";
//    itemAJ.finalPrice = [NSNumber numberWithFloat:95.00f];
//    itemAJ.type = @"TypeThree";
//    itemAJ.include = [NSNumber numberWithBool:YES];
//    Item *itemAK= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAK.modelName = @"ZF. Electronic Trunk Damper";
//    itemAK.finalPrice = [NSNumber numberWithFloat:400.00f];
//    itemAK.type = @"TypeThree";
//    itemAK.include = [NSNumber numberWithBool:YES];
//    Item *itemAL= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAL.modelName = @"ZG. Electronic Branch Damper";
//    itemAL.finalPrice = [NSNumber numberWithFloat:225.00f];
//    itemAL.type = @"TypeThree";
//    itemAL.include = [NSNumber numberWithBool:YES];
//    Item *itemAM= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAM.modelName = @"ZH. Attic Difficulty - (Height, Access, Clutter, Etc)";
//    itemAM.finalPrice = [NSNumber numberWithFloat:995.00f];
//    itemAM.type = @"TypeThree";
//    itemAM.include = [NSNumber numberWithBool:YES];
//    Item *itemAN= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAN.modelName = @"ZI. New Gas Meter Conversion";
//    itemAN.finalPrice = [NSNumber numberWithFloat:395.00f];
//    itemAN.type = @"TypeThree";
//    itemAN.include = [NSNumber numberWithBool:YES];
//    Item *itemAO= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAO.modelName = @"ZJ. Gas Piping Accessible - (Per Foot)";
//    itemAO.finalPrice = [NSNumber numberWithFloat:10.00f];
//    itemAO.type = @"TypeThree";
//    itemAO.include = [NSNumber numberWithBool:YES];
//    Item *itemAP= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemAP.modelName = @"ZK. Misc Add";
//    itemAP.finalPrice = [NSNumber numberWithFloat:100.00f];
//    itemAP.type = @"TypeThree";
//    itemAP.include = [NSNumber numberWithBool:YES];
//    
//    
//    
//    Item *itemA= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//    itemA.modelName = @"No Product Selected";
//    itemA.finalOption = @"None";
//    itemA.finalPrice = [NSNumber numberWithFloat:0.0f];
//    itemA.type = @"Blank";
//
//    
//    
//    /* Item *itemR= (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
//     itemR.modelName = @"Misc Add - (Type In Description & Price)";
//     itemR.price = @"00.00";
//     itemR.type = @"TypeThree";*/
//    
//    
//    NSError *error;
//    if (![managedObjectContext save:&error]) {
//        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
//    }
//    
    [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"SecondOptions"];
    [[NSUserDefaults standardUserDefaults]synchronize];
   }

-(void) fetchData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
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
    
    allData = [[NSArray alloc]init];
    allData = [self.managedObjectContext
                executeFetchRequest:fetchRequest error:&fetchingError];
    
    [self.tableView reloadData];
    

    
}

-(void) sortData {
    
    secondOptions = [[NSMutableArray alloc]init];
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        if ( [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"]) {
            itm.include = @(NO);
            [secondOptions addObject:itm];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
   
    return secondOptions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 195.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderTableViewCell   *header = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    header.segController.hidden = YES;
    header.segController.enabled = NO;
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Item *itm = secondOptions[indexPath.row];
   
    if ([itm.type isEqualToString:@"TypeTwo"]){
        TypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeTwo" forIndexPath:indexPath];
        cell.nameLabel.text = itm.modelName;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@",itm.finalPrice];
        [cell.swtich addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
      
            [cell.swtich setOn:[itm.include boolValue]];
       

        
        cell.swtich.tag = indexPath.row;
//        itm.include = [NSNumber numberWithBool:NO];
        return cell;
    
    } else if ([itm.type isEqualToString:@"TypeThree"]){
        TypeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeThree" forIndexPath:indexPath];
        cell.nameLabel.text = itm.modelName;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@",itm.finalPrice];
        [cell.switchON addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
      
        [cell.switchON setOn:[itm.include boolValue]];
        cell.switchON.tag = indexPath.row;
//        itm.include = [NSNumber numberWithBool:NO];
        
        cell.quantity.text =  itm.optionOne ? itm.optionOne  :@"1";
        cell.quantity.delegate = self;
        cell.quantity.tag = indexPath.row;
        return cell;
    }

    return nil;
}
-(void) customSwitch:(id)sender {
    Item *itm = [secondOptions objectAtIndex:[sender tag]];
    UISwitch* switchControl = sender;
    if (switchControl.isOn) {
        itm.include = [NSNumber numberWithBool:YES];
           } else {
        itm.include = [NSNumber numberWithBool:NO];
       
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // @"Misc Add - (Type In Description & Price)"
    
    TypeThreeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.nameLabel.text isEqualToString:@"Misc Add - (Type In Description & Price)"]){
        [self performSegueWithIdentifier:@"miscAdd" sender:self];
    }
}


#pragma mark - Picker

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
     Item *itm = [secondOptions objectAtIndex:[textField tag]];
    
    
    itm.optionOne = textField.text;
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }

   //[NSNumber numberWithFloat:[textField.text floatValue]];
  
    //  itm.finalPrice =[NSNumber numberWithFloat: [itm.finalPrice floatValue]*[itm.optionOne intValue]];
//    NSError *errorz;
//   if (![managedObjectContext save:&errorz]) {
 //       NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
  //  }

    return YES;
    
}


-(void) buildQuote {
   
    [addedItems removeAllObjects];
    
    for (int j = 0; j < secondOptions.count; j++)
    {
        Item *itm = secondOptions[j];
        BOOL m = [itm.include boolValue];
        if (m)
        {
//            if ([itm.optionOne intValue]!=0) {
//                itm.finalPrice = [NSNumber numberWithFloat:[itm.optOnePrice floatValue]*[itm.optionOne floatValue]];}
//            else
//            {
//                itm.finalPrice = itm.finalPrice;
//            }
            [addedItems addObject:itm];
        }
    }
}

- (IBAction)nextPage:(id)sender {
    [self buildQuote];
   // [self performSegueWithIdentifier:@"quoteProd" sender:self];
    
    if (self.testerVC) {
        
        self.testerVC.managedObjectContext = managedObjectContext;
        
        self.testerVC.additemsB  = addedItems;
        self.testerVC.firstOption = firstOption;
        [self.navigationController pushViewController:self.testerVC animated:YES];
    }else
    {
        [self performSegueWithIdentifier:@"quoteProd" sender:self];
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"quoteProd"]) {
    
        testerViewController *sq = segue.destinationViewController;
        sq.managedObjectContext = managedObjectContext;
        
        sq.additemsB  = addedItems;
        sq.firstOption = firstOption;
        
        self.testerVC = [[testerViewController alloc]init];
        self.testerVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"miscAdd"]) {
    MiscAddViewController *mc = segue.destinationViewController;
    mc.managedObjectContext = managedObjectContext;
    }

}
@end
