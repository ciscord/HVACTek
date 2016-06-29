//
//  ServiceOptionVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "ServiceOptionVC.h"
#import "RecommendationTableViewCell.h"
#import "ViewOptionsVC.h"
#import "CustomerChoiceVC.h"
#import "PlatinumOptionsVC.h"
#import "EnlargeOptionsVC.h"
#import "EditServiceOptionsVC.h"
#import "RRFinalChoiceVC.h"



@interface ServiceOptionVC ()

@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UIButton     *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnZeroPercent;
@property (strong, nonatomic) NSMutableArray      *options;
@property (strong, nonatomic) NSMutableArray      *removedOptions;
@property (strong, nonatomic) NSMutableDictionary *customerSelectedOptions;
@property (nonatomic, assign) BOOL                isDiscountedPriceSelected;
@property (nonatomic, assign) BOOL                isDiagnositcOnlyPriceSelected;
@property (nonatomic, assign) BOOL isEmptyOptionSelected;
@property (nonatomic, assign) BOOL isInvoiceRRSelected;

@property (nonatomic, strong) NSString *segueIdentifierToUnwindTo;

@end

@implementation ServiceOptionVC

static NSString *kCELL_IDENTIFIER = @"RecommendationTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Customer's Choice";
    [self.tableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    self.btnContinue.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnZeroPercent.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];

    if (self.optionsDisplayType == odtEditing) {
        self.options = @[@{@"ServiceID": @"0", @"title": @"Immediate Repair", @"isEditable": @(NO), @"optionImage" : [UIImage imageNamed:@"btn_immediateRepair"], @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                         @{@"ServiceID": @"1", @"title": @"System Preservation", @"isEditable": @(NO), @"optionImage" : [UIImage imageNamed:@"btn_systemPrevention"], @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                         @{@"ServiceID": @"2", @"title": @"Clean Air Solution", @"isEditable": @(NO), @"optionImage" : [UIImage imageNamed:@"btn_cleanAirSolution"], @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                         @{@"ServiceID": @"3", @"title": @"Total Comfort Enchacement", @"isEditable": @(NO), @"optionImage" : [UIImage imageNamed:@"btn_totalComfortEnhancement"], @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy].mutableCopy;
    }

    self.tableView.allowsSelection = _optionsDisplayType == odtReadonlyWithPrice;

    if (self.priceBookAndServiceOptions) {
        [self resetOptions];
    } else {
        [self.tableView reloadData];
    }
    
    self.removedOptions = [[NSMutableArray alloc] initWithArray:[self.options[0] objectForKey:@"items"]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_segueIdentifierToUnwindTo) {
        [self performSegueWithIdentifier:_segueIdentifierToUnwindTo sender:self];
        self.segueIdentifierToUnwindTo = nil;
        return;
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - EnlargeOptionsVC
- (void)setPriceBookAndServiceOptions:(NSArray *)priceBookAndServiceOptions {

    _priceBookAndServiceOptions = priceBookAndServiceOptions;
    if (self.optionsDisplayType == odtEditing) {

        if (self.options.count) {

            [self resetOptions];
        }
    } else {
        self.options = _priceBookAndServiceOptions.mutableCopy;
    }
}


- (void)resetOptions {

    if (self.optionsDisplayType == odtEditing) {

        for (NSInteger i = 0; i < self.options.count; i++) {
            NSMutableDictionary *option = self.options[i];
//            if (i == 0 || (i == 1 && [[self.options[i-1][@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMain == NO"]] count])) {
//                option[@"items"]      = self.priceBookAndServiceOptions.mutableCopy;
//                option[@"isEditable"] = @(i == 1);
//            } else {
//                option[@"items"]      = @[].mutableCopy;
//                option[@"isEditable"] = @(NO);
//            }
            
            option[@"items"]        = self.priceBookAndServiceOptions.mutableCopy;
            option[@"removedItems"] = self.priceBookAndServiceOptions.mutableCopy;
            //option[@"isEditable"]   = @(i == 1);
            
            
            
        }
///        self.btnContinue.hidden = [self.options[1][@"items"] count] > 1;
        [self.tableView reloadData];
    }
}


- (void)didSelectOptionsWithRow:(NSInteger)index withOptionIndex:(NSInteger)optionIndex {

    NSMutableDictionary *option = self.options[index];
    NSMutableArray      *items  = option[@"items"];
    
    //////
    
    id object = [items objectAtIndex:[items indexOfObject:self.removedOptions[optionIndex]]];
    [self.removedOptions removeObject:object];
    
//    if ([self.removedOptions count] == 0)
//        [self.removedOptions insertObject:object atIndex:[self.removedOptions count]];
//    else
        [self.removedOptions insertObject:object atIndex:items.count - 1];


    
    [items removeObject:object];
    
    /////
    
   // [items removeObjectAtIndex:optionIndex];
    option[@"items"]      = items;
    option[@"isEditable"] = @(NO);

    
    NSMutableArray *editableItems = [[NSMutableArray alloc] initWithArray:[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMain == NO"]]];
    
   // NSLog(@"editableItems %lu",(unsigned long)editableItems.count);
    
    if (editableItems.count == 1 & items.count == 1){
        [editableItems removeAllObjects];
    }
    
    
    
    if (editableItems.count > 0 && self.options.count > index+1) {
        NSMutableDictionary *nextOption = self.options[index+1];
        nextOption[@"items"]      = items.mutableCopy;
       // nextOption[@"isEditable"] = @(items.count > 1);
    }
    
///    self.btnContinue.hidden = ([editableItems count] > 0) && (self.options.lastObject != option);

    [self.tableView reloadData];
}


- (IBAction)btnDiagnosticOnlyTouch:(id)sender {
    self.isDiagnositcOnlyPriceSelected = YES;
    self.isDiscountedPriceSelected     = NO;
    [self performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
}



#pragma mark - Repair vs Replace Action
- (IBAction)repairVsReplaceClicked:(UIButton *)sender {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isInstantRRFinal"])
        [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
    else {
        if (![job.totalInvestmentsRR isEqualToString:@""] && job.totalInvestmentsRR != nil) {
            [self performSegueWithIdentifier:@"showInstantRRFinalChoiceVC" sender:self];
        }else{
            [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
        }
    }
    
}




#pragma mark - Clicked Next Without Option
- (IBAction)nextClickedWithOutAnyOption:(UIButton *)sender {
    self.isEmptyOptionSelected = YES;
        [self performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
}




#pragma mark - Options Action
- (void)selectOptionsToEditAtRow:(NSInteger)index {
//    NSDictionary *option   = self.options[index];
//    NSMutableArray *items    = option[@"items"];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    EditServiceOptionsVC* vc = [sb instantiateViewControllerWithIdentifier:@"EditServiceOptionsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.servicesArray = self.options;
    vc.selectedIndex = index;
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - ZeroPercent Button
- (IBAction)zeroPercentButtonClicked:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.greenskycredit.com/Consumer/"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Can't open url");
    }
}

#pragma mark - Next Action
- (IBAction)nextBtnClicked:(UIButton *)sender {
    if ([self servicesOptionsWereEdited]) {
        [self performSegueWithIdentifier:@"showViewOptionsVC" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No options have been changed. Are you sure you wish to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}



- (BOOL)servicesOptionsWereEdited {
    for (NSInteger i = 0; i < self.options.count; i++) {
        NSMutableDictionary *option = self.options[i];
        if ([option[@"items"] count] != [option[@"removedItems"] count]) {
            return YES;
        }
    }
    return NO;
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"showViewOptionsVC" sender:self];
    }
}



#pragma mark - UITableViewDelegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.options objectAtIndex:indexPath.section];
    
    return [RecommendationTableViewCell heightWithData:items];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.options.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //[cell setBackgroundColor:[UIColor clearColor]];
    cell.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ServiceOptionVC *weakSelf = self;
    NSDictionary           *option   = self.options[indexPath.section];
    NSArray                *items    = option[@"items"];
    NSArray         *removedItems    = option[@"removedItems"];

    RecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.choiceImageView.image        = option[@"optionImage"];
    cell.lbRecommandationName.text    = option[@"title"];
    cell.rowIndex                     = indexPath.section;
    
    if (self.optionsDisplayType == odtEditing) {
        cell.isEditable = [option[@"isEditable"] boolValue];
    }
    cell.optionsDisplayType = self.optionsDisplayType;

    [cell setOnOptionReset:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf resetOptions];
     }];

    [cell displayServiceOptions:items andRemovedServiceOptions:removedItems];
    [cell setOnOptionSelected:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf didSelectOptionsWithRow:rowIndex withOptionIndex:itemIndex];
     }];

    [cell setOnPriceSelected:^(NSInteger rowIndex, BOOL isDiscounted) {
        self.isEmptyOptionSelected = NO;
        weakSelf.isDiscountedPriceSelected = isDiscounted;
        weakSelf.isDiagnositcOnlyPriceSelected = NO;
        weakSelf.customerSelectedOptions = self.options[indexPath.section];
        [weakSelf performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
     }];
    
    
    
    ////////
    [cell setOptionButtonSelected:^(NSInteger rowIndex){
        [weakSelf selectOptionsToEditAtRow:rowIndex];
    }];
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary           *option   = self.options[indexPath.section];
    NSArray                *items    = option[@"items"];
    
    RecommendationTableViewCell *cell = (RecommendationTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard"
                                                  bundle:nil];

    EnlargeOptionsVC* vc = [sb instantiateViewControllerWithIdentifier:@"EnlargeOptionsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.enlargeOptionName = option[@"title"];
    vc.enlargeTotalPrice = cell.btnPrice1.titleLabel.text;
    vc.enlargeESAPrice = cell.btnPrice2.titleLabel.text;
    vc.enlargeMonthlyPrice = cell.lb24MonthRates.text;
    vc.enlargeSavings = cell.lbESAsaving.text;
    vc.enlargeMidleLabelString = cell.financingLabel.text;
    vc.enlargeOptionsArray = items;
    vc.enlargeFullOptionsArray = [option objectForKey:@"removedItems"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    
    [self presentViewController:vc animated:YES completion:nil];

}



#pragma mark - Unwind Segues
- (IBAction)unwindToServiceOptionVC:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromRRBtn"]){
        self.segueIdentifierToUnwindTo = @"showRRQuestionsVCAfterUnwind";
    }
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromInvoiceBtn"]){
        self.isEmptyOptionSelected = YES;
        self.isInvoiceRRSelected = YES;
        self.segueIdentifierToUnwindTo = @"customerChoiceSegueAfterUnwind";
    }
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromCustomersChoice"]){
        self.isInvoiceRRSelected  = NO;
        self.segueIdentifierToUnwindTo = @"showInstantRRFinalChoiceVC";
    }
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewOptionsVC *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[ViewOptionsVC class]]) {
        
        ViewOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.options;
        
    } else if ([vc isKindOfClass:[ServiceOptionVC class]]) {
        
        ServiceOptionVC *vc = [segue destinationViewController];
        vc.optionsDisplayType         = odtReadonlyWithPrice;
        vc.priceBookAndServiceOptions = self.options;
        
    } else if ([vc isKindOfClass:[CustomerChoiceVC class]]) {
        
        CustomerChoiceVC *vc = [segue destinationViewController];
        vc.fullServiceOptions = self.options.firstObject[@"items"];
        vc.isDiscounted       = self.isDiscountedPriceSelected;
        vc.isOnlyDiagnostic   = self.isDiagnositcOnlyPriceSelected;
        vc.isComingFromInvoice = self.isInvoiceRRSelected;
        
        if (self.isEmptyOptionSelected) {
            NSDictionary *d = @{};
            vc.selectedServiceOptions = d;
        }else{
            vc.selectedServiceOptions = self.customerSelectedOptions;
        }
        
        
        
        
//        if (self.isDiagnositcOnlyPriceSelected) {
//            
//            PricebookItem *diagnosticOnlyItem = [[DataLoader sharedInstance] diagnosticOnlyOption];
//            
//            PricebookItem *diagnosticOnlyItemNoTitle = [PricebookItem new];
//            diagnosticOnlyItemNoTitle.itemID     = diagnosticOnlyItem.itemID;
//            diagnosticOnlyItemNoTitle.itemNumber = diagnosticOnlyItem.itemNumber;
//            diagnosticOnlyItemNoTitle.itemGroup  = diagnosticOnlyItem.itemGroup;
//            diagnosticOnlyItemNoTitle.amount     = diagnosticOnlyItem.amount;
//            
//            NSDictionary *d = @{
//                                @"items" : @[diagnosticOnlyItemNoTitle],
//                                @"title" : @"Diagnostic Only"
//                                };
//            
//            vc.selectedServiceOptions = d;
//        } else {
//            vc.selectedServiceOptions = self.customerSelectedOptions;
//        }
        
    } else if ([vc isKindOfClass:[PlatinumOptionsVC class]]) {
        
        PlatinumOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.options;
        
    }
    
    
    if ([segue.identifier isEqualToString:@"showInstantRRFinalChoiceVC"]) {
        RRFinalChoiceVC *vc = [segue destinationViewController];
        Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
        vc.totalInvestment = job.totalInvestmentsRR;
    }
    
    
    //    if ([segue.destinationViewController isKindOfClass:[EnlargeOptionsVC class]])
    //    {
    //        EnlargeOptionsVC *vc = (EnlargeOptionsVC*)segue.destinationViewController;
    //        vc.enlargeIndex = [NSString stringWithFormat:@"%ld",(long)self.selectedOption + 1];
    //
    ////        NSDictionary           *option   = self.options[self.selectedOption];
    ////        NSArray                *items    = option[@"items"];
    //        
    //        
    //
    //    }
}





@end
