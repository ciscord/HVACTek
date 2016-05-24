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

@interface AdditionalInfoPageVC ()

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation AdditionalInfoPageVC

static NSString *kCELL_IDENTIFIER = @"AdditionalInfoPageCells";


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    [self configureVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Configure VC
- (void)configureColorScheme {
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.continueButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


-(void)configureVC {
    self.title = @"Customer's Choice";
    [self.infoTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
}



#pragma mark - Button Actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)continueClicked:(id)sender {
}


#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AdditionalInfoPageCells *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    [cell setOnCheckboxToggle:^(BOOL selected){
        NSLog(@"selected");
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
