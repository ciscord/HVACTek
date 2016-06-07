//
//  AdditionalInfoPageVC.m
//  HvacTek
//
//  Created by Dorin on 5/19/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "AdditionalInfoPageVC.h"
#import "NewCustomerChoiceVC.h"
#import "AdditionalInfoPageCells.h"
#import "CompanyAditionalInfo.h"

@interface AdditionalInfoPageVC ()

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) NSArray *additionalInfoArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@end

@implementation AdditionalInfoPageVC

static NSString *kCELL_IDENTIFIER = @"AdditionalInfoPageCells";


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    [self configureVC];
    [self loadAdditionalInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAdditionalInfo {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[DataLoader sharedInstance] getAdditionalInfoOnSuccess:^(NSDictionary *infoDict) {
//        self.additionalInfoArray = infoDict[@"1"][@"rows"];
//        [self.infoTableView reloadData];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }onError:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        ShowOkAlertWithTitle(error.localizedDescription, self);
//    }];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        if (!companyObject.isVideo) {
            [infoArray addObject:companyObject];
        }
    }
    
    self.additionalInfoArray = infoArray.mutableCopy;
}


#pragma mark - Configure VC
- (void)configureColorScheme {
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.continueButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


-(void)configureVC {
    self.title = @"Customer's Choice";
    [self.infoTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] additionalInfoData] count] > 0) {
        self.selectedArray = [[[[DataLoader sharedInstance] currentUser] activeJob] additionalInfoData];
    }else{
        self.selectedArray = [[NSMutableArray alloc] init];
    }
}



#pragma mark - Button Actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)continueClicked:(id)sender {
    [[[DataLoader sharedInstance] currentUser] activeJob].additionalInfoData = self.selectedArray;
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    [job.managedObjectContext save];
}


#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.additionalInfoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyAditionalInfo * selectedItem = self.additionalInfoArray[indexPath.row];
    
    AdditionalInfoPageCells *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.titleLabel.text = selectedItem.info_title;
    cell.descriptionLabel.text = selectedItem.info_description;
    cell.checkButton.selected = [self.selectedArray containsObject:selectedItem];
    [cell setOnCheckboxToggle:^(BOOL selected){
        if ([self.selectedArray containsObject:selectedItem]) {
            [self.selectedArray removeObject:selectedItem];
        } else {
            [self.selectedArray addObject:selectedItem];
        }
    }];
    
    return cell;
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showNewCustomerChoiceVC"]) {
        NewCustomerChoiceVC *vc = [segue destinationViewController];
        vc.isDiscounted = self.isDiscounted;
        vc.isOnlyDiagnostic = self.isOnlyDiagnostic;
        vc.unselectedOptionsArray = self.unselectedOptionsArray;
        vc.selectedServiceOptionsDict = self.selectedServiceOptionsDict;
        vc.initialTotal = self.initialTotal;
        vc.paymentValue = self.paymentValue;
    }
}

@end
