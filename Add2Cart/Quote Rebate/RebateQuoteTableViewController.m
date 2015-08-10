//
//  RebateQuoteTableViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "RebateQuoteTableViewController.h"
#import "Item.h"
#import "RebateAddViewController.h"

@interface RebateQuoteTableViewController ()
    @property (nonatomic, strong) Item *editedItem;


@end

@implementation RebateQuoteTableViewController
@synthesize managedObjectContext;
@synthesize prodFRC;
@synthesize purch;
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
    
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    
    }


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    rebatesToSend = [[NSMutableArray alloc]init];
    [self fetchData];

    
}
-(void) viewDidDisappear:(BOOL)animated {
      //(@"sendin back puch is %d",purch.count);
         NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
        }
    [self.delegate receiveData:rebatesToSend:purch];
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
    
    NSLog(@"In rebates all data holds %d",allData.count);
    [self selectProducts];
}

-(void) home {
  
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) selectProducts {
    selected = [[NSMutableArray alloc]init];
    for (int j = 0; j  < allData.count; j++){
        Item *itm = allData[j];
        if ([itm.type isEqualToString:@"Rebates"]) {
           // itm.include =[NSNumber numberWithBool:0];
            [selected addObject:itm];
                       
        }
    }
    NSLog(@"selected contains %d",selected.count);
    
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RebateQuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Item *itm = selected[indexPath.row];
    cell.nameLabel.text = itm.modelName;
    cell.priceLabel.text = [NSString stringWithFormat:@"-$%.0f",[itm.finalPrice floatValue]];
    BOOL j = [itm.include boolValue];
    if (j) {
        [cell.switchOn setOn:YES];
    } else {
        [cell.switchOn setOn:NO];
    }

        [cell.switchOn addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.switchOn.tag = indexPath.row;
       
    return cell;
}

-(void) customSwitch:(id) sender {
    int x = [sender tag];
    Item *itm = selected[x];
    UISwitch* switchControl = sender;
    if (switchControl.isOn) {
        itm.include = [NSNumber numberWithBool:YES];
    } else {
        itm.include = [NSNumber numberWithBool:NO];
    }

    
}
- (IBAction)btnAddRebate:(id)sender {
    [self performSegueWithIdentifier:@"addEditRebate" sender:self];
    
    
}
//ap.managedObjectContext = managedObjectContext;


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
    if ([segue.identifier isEqualToString: @"addEditRebate"]) {
        RebateAddViewController *rb = segue.destinationViewController;
      //  rb.type = prodType;
        rb.managedObjectContext = managedObjectContext;
    }
  
    if ([segue.identifier isEqualToString: @"EditRebate"]) {
        RebateAddViewController *rb = segue.destinationViewController;
        //  rb.type = prodType;
        rb.editing = YES;
        rb.itemz =self.editedItem;
        rb.managedObjectContext = managedObjectContext;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    Item * aItem = selected[indexPath.row];
    if ([aItem.usserAdet intValue]==1) {
        return YES;
    }
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
         Item * aItem = selected[indexPath.row];
         [managedObjectContext deleteObject:aItem];
        rebatesToSend = [[NSMutableArray alloc]init];
        [self fetchData];
        [tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item * aItem = selected[indexPath.row];
    if ([aItem.usserAdet intValue]==1) {
        self.editedItem = aItem;
        [self performSegueWithIdentifier:@"EditRebate" sender:self];
    }

}
@end
