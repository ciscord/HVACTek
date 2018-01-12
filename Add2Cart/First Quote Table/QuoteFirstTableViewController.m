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
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
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
    first = [[NSUserDefaults standardUserDefaults]boolForKey:@"newSession"];
    
    if (first) {
        [self addDataOneOff];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"newSession"];
    }
    [self fetchData];
    [self sortData];
    [self.tableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated {
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
}

-(void) home {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) addDataOneOff {
    [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"SecondOptions"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void) fetchData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
    NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"currentCart = %d",[[NSUserDefaults standardUserDefaults] integerForKey:@"workingCurrentCartIndex"]];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:cartPredicate];
    
    NSError *fetchingError = nil;
    
    allData = [[NSArray alloc]init];
    allData = [self.managedObjectContext
                executeFetchRequest:fetchRequest error:&fetchingError];
    
    [self.tableView reloadData];
}

-(void) sortData {
    
    secondOptions = [[NSMutableArray alloc]init];
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        
        if ( [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeOne"]) {
            itm.include = @(NO);
            [secondOptions addObject:itm];
        }
    }
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];

     secondOptions = [[NSMutableArray alloc]initWithArray:[secondOptions sortedArrayUsingDescriptors:sortDescriptors]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
   
    if ([itm.type isEqualToString:@"TypeOne"]){
        TypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeTwo" forIndexPath:indexPath];
        cell.nameLabel.text = itm.modelName;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@",itm.finalPrice];
        [cell.swtich addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
      
        [cell.swtich setOn:[itm.include boolValue]];
       
        cell.swtich.tag = indexPath.row;
        return cell;
    
    } else if ([itm.type isEqualToString:@"TypeTwo"]){
        TypeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeThree" forIndexPath:indexPath];
        cell.nameLabel.text = itm.modelName;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@",itm.finalPrice];
        [cell.switchON addTarget:self action:@selector(customSwitch:) forControlEvents:UIControlEventValueChanged];
      
        [cell.switchON setOn:[itm.include boolValue]];
        cell.switchON.tag = indexPath.row;
        
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

    return YES;
}

-(void) buildQuote {
   
    [addedItems removeAllObjects];
    
    for (int j = 0; j < secondOptions.count; j++)
    {
        Item *itm = secondOptions[j];
        BOOL m = [itm.include boolValue];
        if (m) {
            [addedItems addObject:itm];
        }
    }
}

- (IBAction)nextPage:(id)sender {
    [self buildQuote];
    
    [self performSegueWithIdentifier:@"quoteProd" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"quoteProd"]) {
    
        testerViewController *sq = segue.destinationViewController;
        sq.managedObjectContext = managedObjectContext;
        
        sq.additemsB  = addedItems;
        sq.firstOption = firstOption;
        
    }
    
    if ([segue.identifier isEqualToString:@"miscAdd"]) {
    MiscAddViewController *mc = segue.destinationViewController;
    mc.managedObjectContext = managedObjectContext;
    }
}

@end
