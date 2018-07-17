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
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    NSDictionary* customerChoiceData = [DataLoader loadLocalAdditionalInfo];
    
    self.isDiscounted = [[customerChoiceData objectForKey:@"isDiscounted"] boolValue];
    self.isOnlyDiagnostic = [[customerChoiceData objectForKey:@"isOnlyDiagnostic"] boolValue];
    self.unselectedOptionsArray = [customerChoiceData objectForKey:@"unselectedOptionsArray"];
    self.selectedServiceOptionsDict = [customerChoiceData objectForKey:@"selectedServiceOptionsDict"];
    self.initialTotal = [customerChoiceData objectForKey:@"initialTotal"];
    self.paymentValue = [customerChoiceData objectForKey:@"paymentValue"];
    
    
    [self configureColorScheme];
    [self configureVC];
    [self loadAdditionalInfo];
    
    if ([TechDataModel sharedTechDataModel].currentStep > AdditionalInfoPage) {
        NewCustomerChoiceVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewCustomerChoiceVC"];
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        
        [[TechDataModel sharedTechDataModel] saveCurrentStep:AdditionalInfoPage];
    }
    
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = AdditionalInfoPage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadAdditionalInfo {
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        if (!companyObject.isVideo && !companyObject.isPicture) {
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
        
        NSDictionary* customerChoiceData = @{@"isDiscounted": [NSNumber numberWithBool:self.isDiscounted],
                                             @"isOnlyDiagnostic": [NSNumber numberWithBool:self.isOnlyDiagnostic],
                                             @"unselectedOptionsArray" : self.unselectedOptionsArray.mutableCopy,
                                             @"selectedServiceOptionsDict" : self.selectedServiceOptionsDict.mutableCopy,
                                             @"initialTotal" : self.initialTotal,
                                             @"paymentValue" : self.paymentValue
                                             }.mutableCopy;
        
        [DataLoader saveNewCustomerChoice:customerChoiceData];
        
    }
}

@end
