//
//  ProductAdminTableViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "ProductAdminTableViewController.h"
#import "AddProductViewController.h"
#import "RebateAddViewController.h"


@interface ProductAdminTableViewController () {
    HeaderTableViewCell *header;
}

@end

@implementation ProductAdminTableViewController
@synthesize prodFRC, managedObjectContext;
/*
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    segmentChose = [[NSUserDefaults standardUserDefaults]integerForKey:@"seg"] ;
    header.segController.selectedSegmentIndex = segmentChose;
    types = [[NSArray alloc]initWithObjects:@"Air Conditioners",@"Heat Pumps", @"Furnaces",@"Air Handlers"
             ,@"Geothermal", @"IAQ",@"Accessories",@"Rebates", @"Boilers",@"Hot Water Heaters", nil];
    selected = [[NSMutableArray alloc]init];
    prodType = types[segmentChose];
  //  [self fetchData];
  //  [self selectProducts:segmentChose];
    
}

-(void) viewDidAppear:(BOOL)animated   {
    [self fetchData];
    [self selectProducts:segmentChose];
    [self.tableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated {
   
NSError *error;
if (![managedObjectContext save:&error]) {
    NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
}

   

}


-(void) selectProducts:(int) selectedProds {
    
    for (int x = 0; x < products.count; x++) {
        Item *item = products[x];
       
        if ([item.type isEqualToString:prodType] ) {
            [selected addObject:item];
        
        }
    }
    
    [self.tableView reloadData];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
  
    return selected.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([prodType isEqualToString:@"Rebates"]
        ) {
        return 88.0f;
    } else {
        return 155.0f;
    }
}

//Header Stuff
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 195.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    header = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    header.segController.selectedSegmentIndex = segmentChose;
   [header.segController addTarget:self action:@selector(customSegController:) forControlEvents:UIControlEventValueChanged];
    return header;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Item *itm = [selected objectAtIndex:indexPath.row];
    
    if ([itm.type isEqualToString:@"Rebates"]) {
        //load rebate cells
        RebateTableViewCell *reb = [tableView dequeueReusableCellWithIdentifier:@"rebateCell" forIndexPath:indexPath];
        reb.nameLabel.text = [NSString stringWithFormat:@"     %@", itm.modelName];
        reb.costLabel.text = [NSString stringWithFormat:@"-$%@",itm.price];
        BOOL j = [itm.include boolValue];
        if (j) {
            [reb.switchOn setOn:YES];
        }
        [reb.switchOn addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
        reb.switchOn.tag = indexPath.row;
        return reb;
    } else {
        
    
    ProdAdminTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    // Configure the cell...
    cell.itemPic.image = [UIImage imageWithData:itm.photo];
    cell.modelName.text = itm.modelName;
    cell.price.text = [NSString stringWithFormat:@"%@",itm.price];
    cell.optionOne.text = [NSString stringWithFormat:@"%@", itm.optionOne];
    cell.optionTwo.text = [NSString stringWithFormat:@"%@", itm.optionTwo];
    cell.optionThree.text = [NSString stringWithFormat:@"%@", itm.optionThree];
        BOOL j = [itm.include boolValue];
        if (j) {
            [cell.switchButton setOn:YES];
        }
    [cell.switchButton addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.switchButton.tag = indexPath.row;
    return cell;
    }
}

-(void) customSwitch:(id)sender {
    Item *itm = [selected objectAtIndex:[sender tag]];
    UISwitch* switchControl = sender;
    if (switchControl.isOn) {
        itm.include = [NSNumber numberWithBool:YES];
          } else {
        itm.include = [NSNumber numberWithBool:NO];
        
    }
    
    
    
}


-(void) fetchData {
              [selected removeAllObjects];
             AppDelegate *apDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
             managedObjectContext = apDel.managedObjectContext;
             
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
                 NSLog(@"Successfully fetched");
                 
             } else {
                 NSLog(@"Failed to get the result");
             }
             
             products = [[NSArray alloc]init];
             products = [self.managedObjectContext
                         executeFetchRequest:fetchRequest error:&fetchingError];
    
    
    for (int xy = 0; xy < products.count; xy++) {
        Item *itm = products[xy];
     //   itm.include = [NSNumber numberWithBool:NO];

    }
    
    [self.tableView reloadData];
}
             

- (IBAction)addProduct:(id)sender {
    if ([prodType isEqualToString:@"Rebates"]) {
        [self performSegueWithIdentifier:@"rebate" sender:self];
    } else {
        [self performSegueWithIdentifier:@"addProd" sender:self];
    }
}

-(void) customSegController:(id)sender {
        [self fetchData];
    UISegmentedControl *sg = sender;
    segmentChose = sg.selectedSegmentIndex;
    [[NSUserDefaults standardUserDefaults]setInteger:segmentChose forKey:@"seg"];
    switch (segmentChose) {
        case 0:{
            prodType = types[0];
            [self selectProducts:0];
            
            break;
        }
        case 1:{
            prodType = types[1];
            [self selectProducts:0];
            
            break;
        }
        case 2:{
            prodType = types[2];
            [self selectProducts:0];
            
            break;
        }
        case 3:{
            prodType = types[3];
            [self selectProducts:0];
            
            break;
        }
        case 4:{
            prodType = types[4];
            [self selectProducts:0];
            
            break;
        }
        case 5:{
            prodType = types[5];
            [self selectProducts:0];
            
            break;
        }
            
        case 6:{
            prodType = types[6];
            [self selectProducts:0];
            
            break;
        }
        case 7:{
            prodType = types[7];
            [self selectProducts:0];
            
            break;
        }
            
            
        default:
            break;
    }
    
    // [self reload or something with the int.];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
    
    if ([segue.identifier isEqualToString:@"addProd"]) {
        AddProductViewController *ap = segue.destinationViewController;
        ap.type = prodType;
        ap.managedObjectContext = managedObjectContext;
        
    }
    
    if ([segue.identifier isEqualToString:@"editProd"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Item *i = selected[path.row];
        AddProductViewController *ap = segue.destinationViewController;
        ap.type = prodType;
        ap.managedObjectContext = managedObjectContext;
        ap.itemz = i;
    }

    
    if ([segue.identifier isEqualToString:@"rebate"]) {
        RebateAddViewController *rb = segue.destinationViewController;
        rb.type = prodType;
        rb.managedObjectContext = managedObjectContext;
        
    }
    
    
    
    if ([segue.identifier isEqualToString:@"rebateEdit"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Item *i = selected[path.row];

        RebateAddViewController *rb = segue.destinationViewController;
        rb.type = prodType;
        rb.managedObjectContext = managedObjectContext;
        rb.itemz = i;
    }

    
}
*/

@end
