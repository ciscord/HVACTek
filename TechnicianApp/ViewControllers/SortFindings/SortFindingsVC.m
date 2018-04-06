//
//  SortFindingsVC.m
//  HvacTek
//
//  Created by Dorin on 2/10/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "SortFindingsVC.h"
#import "SortFindinsCell.h"
#import "ServiceOptionVC.h"

@interface SortFindingsVC ()

@property (weak, nonatomic) IBOutlet UITableView *findingsTable;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

static NSString *findingsCellID = @"SortFindinsCell";

@implementation SortFindingsVC


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"Summary of Findings Sort";
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self.findingsTable registerNib:[UINib nibWithNibName:findingsCellID bundle:nil] forCellReuseIdentifier:findingsCellID];
  
    self.findingsArray = [DataLoader loadLocalSavedFindingOptions];
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortArr = [self.findingsArray sortedArrayUsingDescriptors:sortDescriptors];
    self.findingsArray = [sortArr mutableCopy];
  
    self.continueButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [[TechDataModel sharedTechDataModel] saveCurrentStep:SortFindings];
}


#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  [cell setBackgroundColor:[UIColor clearColor]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.findingsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  PricebookItem *option = self.findingsArray[indexPath.row];
  SortFindinsCell *cell = [tableView dequeueReusableCellWithIdentifier:findingsCellID];
  NSString * serviceString;
  if ([option.quantity intValue] > 1) {
    serviceString = [NSString stringWithFormat:@"(%@) ",option.quantity];
  }else{
    serviceString = @"";
  }
  NSString * nameString = [serviceString stringByAppendingString:option.name];
  cell.lbTitle.text = nameString;
  
  if (indexPath.row == 0)
    cell.upButton.hidden = YES;
  else
    cell.upButton.hidden = NO;
  
  if (indexPath.row == [self.findingsArray count] - 1)
    cell.downButton.hidden = YES;
  else
    cell.downButton.hidden = NO;
  
  cell.upButton.tag = indexPath.row;
  cell.downButton.tag = indexPath.row;
  [cell.upButton addTarget:self action:@selector(upButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  [cell.downButton addTarget:self action:@selector(downButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  return cell;
}



#pragma mark - Change Row Position
- (void)upButtonClicked:(id)sender {
  [self.findingsTable setUserInteractionEnabled:NO];
  [self.findingsArray exchangeObjectAtIndex:[sender tag] withObjectAtIndex:[sender tag] - 1];
  [self.findingsTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0] toIndexPath:[NSIndexPath indexPathForRow:[sender tag] - 1 inSection:0]];
  [self performSelector:@selector(reloadFindingTable) withObject:nil afterDelay:.28];
 
}


- (void)downButtonClicked:(id)sender {
  [self.findingsTable setUserInteractionEnabled:NO];
  [self.findingsArray exchangeObjectAtIndex:[sender tag] withObjectAtIndex:[sender tag] + 1];
  [self.findingsTable moveRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0] toIndexPath:[NSIndexPath indexPathForRow:[sender tag] + 1 inSection:0]];
  [self performSelector:@selector(reloadFindingTable) withObject:nil afterDelay:.28];
}


-(void)reloadFindingTable {
  [self.findingsTable reloadData];
  [self.findingsTable setUserInteractionEnabled:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showServiceOptionsFromSort"]) {
        [DataLoader saveOptionsDisplayType:odtEditing];
        [DataLoader saveFindingOptionsLocal:self.findingsArray];
    }
}

@end
