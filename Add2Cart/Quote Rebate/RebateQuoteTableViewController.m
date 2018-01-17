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

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

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
    
    [self configureColorScheme];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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

#pragma mark - Color Scheme
- (void)configureColorScheme {
    
    __weak UIImageView *weakImageView = self.logoImageView;
    [self.logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                         placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                      
                                      UIImageView *strongImageView = weakImageView;
                                      if (!strongImageView) return;
                                      
                                      strongImageView.image = image;
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                      //
                                  }];
}

-(void) fetchData {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
    NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"currentCart = %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"workingCurrentCartIndex"]];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:cartPredicate];
    
    NSError *fetchingError = nil;
  
    allData = [[NSArray alloc]init];
    allData = [self.managedObjectContext
               executeFetchRequest:fetchRequest error:&fetchingError];
    
//    NSLog(@"In rebates all data holds %d",allData.count);
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

            [selected addObject:itm];
                       
        }
    }
//    NSLog(@"selected contains %d",selected.count);
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    Item * aItem = selected[indexPath.row];
    if ([aItem.usserAdet intValue]==1) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Item * aItem = selected[indexPath.row];
      
        int id_rebate = [aItem.typeID intValue] - 999;
        NSString *strID = [NSString stringWithFormat:@"%d",id_rebate];
        
        [[DataLoader sharedInstance] deleteRebatesFromPortalWithId:strID
                                                         onSuccess:^(NSString *successMessage) {
                                                             NSLog(@"SUCCES %@",successMessage);
                                                             
                                                             UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Succesfully Deleted" message:[NSString stringWithFormat:@"You have succesfully deleted a rebate"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                             [al show];
                                                             
                                                             [managedObjectContext deleteObject:aItem];
                                                             rebatesToSend = [[NSMutableArray alloc]init];
                                                             [self fetchData];
                                                             [tableView reloadData];
                                                             
                                                         }onError:^(NSError *error) {
                                                             ShowOkAlertWithTitle(error.localizedDescription, self);
                                                             NSLog(@"ERROR");
                                                         }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item * aItem = selected[indexPath.row];
    if ([aItem.usserAdet intValue]==1) {
        self.editedItem = aItem;
        [self performSegueWithIdentifier:@"EditRebate" sender:self];
    }
    
}

#pragma mark - Custom Switch
-(void) customSwitch:(id) sender {
    int x = (int)[sender tag];
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

#pragma mark - Segue
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

@end
