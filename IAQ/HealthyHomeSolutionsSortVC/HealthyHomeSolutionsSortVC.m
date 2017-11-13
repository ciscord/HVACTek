//
//  HealthyHomeSolutionsSortVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsSortVC.h"

@interface HealthyHomeSolutionsSortVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UITableView *findingsTable;

@end

static NSString *findingsCellID = @"SortFindinsCell";

@implementation HealthyHomeSolutionsSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.findingsTable registerNib:[UINib nibWithNibName:findingsCellID bundle:nil] forCellReuseIdentifier:findingsCellID];
    
    self.findingsArray = [NSMutableArray array];
    [self.findingsArray addObjectsFromArray:@[@"Add PVC Uniton for Pump Access", @"Bypass Humidifier Maintenance", @"Comprehensive Diagnostic", @"Comprehensive Diagnostic", @"Install EZ Trap & Test Drain Line", @"Install Safety Wet Switch & Test System Operation"]];
    [self.findingsTable reloadData];
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
    
    NSString *nameString = self.findingsArray[indexPath.row];
    SortFindinsCell *cell = [tableView dequeueReusableCellWithIdentifier:findingsCellID];
    NSString * serviceString;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
