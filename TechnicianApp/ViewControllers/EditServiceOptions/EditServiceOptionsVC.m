//
//  EditServiceOptionsVC.m
//  Signature
//
//  Created by Dorin on 12/3/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "EditServiceOptionsVC.h"
#import "EditServiceOptionsCell.h"

@interface EditServiceOptionsVC ()

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;
@property (weak, nonatomic) IBOutlet UIButton *bacBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;



@end


@implementation EditServiceOptionsVC


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [[DataLoader sharedInstance] pauseTimeWithJobId:[[[DataLoader sharedInstance] currentUser] activeJob].jobID onSuccess:^(NSString *successMessage) {
        
    } onError:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configureVC {
    self.title = @"Customer's Choice";
    [self.serviceTableView registerNib:[UINib nibWithNibName:@"EditServiceOptionsCell" bundle:nil] forCellReuseIdentifier:@"EditServiceOptionsCell"];
    
    [self configureColorScheme];
    
    NSDictionary *option   = self.servicesArray[self.selectedIndex];
    self.changedServicesArray = [option[@"removedItems"] mutableCopy];
    self.serviceNameLabel.text = option[@"title"];
}



#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.bacBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.saveBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.serviceNameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



#pragma mark - Buttons Actions
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveButtonClicked:(UIButton *)sender {
    NSMutableDictionary *option = self.servicesArray[self.selectedIndex];
    //option[@"removedItems"] = self.changedServicesArray;
  ///  [self dismissViewControllerAnimated:YES completion:nil];

    //keep same order as items
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    itemsArray = [option[@"items"] mutableCopy];
    
    for (id object in itemsArray) {
        if ([self.changedServicesArray containsObject:object]) {
            [filteredArray addObject:object];
        }
    }
    
    option[@"removedItems"] = filteredArray;
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDelegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.servicesArray[self.selectedIndex][@"items"] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditServiceOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditServiceOptionsCell"];
    
    NSDictionary *option   = self.servicesArray[self.selectedIndex];
    NSMutableArray *items    = option[@"items"];
    PricebookItem *p = items[indexPath.section];
    
    NSString * serviceString;
    if ([p.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",p.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:p.name];
    
    
    if ([self.changedServicesArray containsObject:p]){
        if (cell.serviceNameLabel.attributedText){
            cell.serviceNameLabel.attributedText = nil;
        }
        cell.serviceNameLabel.text = nameString;
        
        cell.changeStatusButton.backgroundColor = [UIColor colorWithRed:120/255.0f green:191/255.0f blue:68/255.0f alpha:1.0f];
        [cell.changeStatusButton setTitle:@"x" forState:UIControlStateNormal];
        
    }else{
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
        cell.serviceNameLabel.attributedText = attrText;
        
        cell.changeStatusButton.backgroundColor = [UIColor colorWithRed:239/255.0f green:64/255.0f blue:55/255.0f alpha:1.0f];
        [cell.changeStatusButton setTitle:@"+" forState:UIControlStateNormal];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *option   = self.servicesArray[self.selectedIndex];
    NSMutableArray *items    = option[@"items"];
    PricebookItem *p = items[indexPath.section];
    
    if ([self.changedServicesArray containsObject:p]) {
        if (self.changedServicesArray.count == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"At least one service option must be selected." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }else
            [self.changedServicesArray removeObject:p];
    }else{
        [self.changedServicesArray addObject:p];
    }
    [self.serviceTableView reloadData];
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
