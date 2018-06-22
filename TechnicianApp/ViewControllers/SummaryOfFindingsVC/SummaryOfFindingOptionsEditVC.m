//
//  SummaryOfFindingOptionsEditVCViewController.m
//  HvacTek
//
//  Created by Admin on 6/22/18.
//  Copyright © 2018 Unifeyed. All rights reserved.
//


#import "SummaryOfFindingOptionsEditVC.h"
#import "ServiceOptionViewCell.h"
#import "SummaryOfFindingsVC.h"
#import "PricebookItem.h"
#import "SortFindingsVC.h"
#import "AddCustomRepairVC.h"


@interface SummaryOfFindingOptionsEditVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray               *allOptions;
@property (nonatomic, strong) NSMutableArray        *filteredOptions;
@property (nonatomic, strong) NSMutableArray        *selectedOptions;

@property (weak, nonatomic) IBOutlet UITextField    *tfSearch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *customRepairButton;
@end

@implementation SummaryOfFindingOptionsEditVC

static NSString *kCellIdentifier = @"ServiceOptionViewCell";
static NSString *localPriceBookFileName = @"LocalPriceBook.plist";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Common Repairs";
    
//    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
//    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self configureColorScheme];
    
    self.filteredOptions = @[].mutableCopy;
    
    self.tfSearch.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, 0.0)];
    self.tfSearch.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"summary-findings-search-icon"]];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setFrame: CGRectMake(0.0, 0.0, 40.0, 30.0)];
    
    
    self.tfSearch.rightView = imageView;
    self.tfSearch.rightViewMode = UITextFieldViewModeAlways;
    
    self.tfSearch.font = [UIFont fontWithName:@"Calibri" size:18];
    [self.collectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.allOptions = [self getOptionsTypeOfArray:[[DataLoader sharedInstance] iPadCommonRepairsOptions]];
    
    if ([[DataLoader sharedInstance] selectedRepairTemporarOptions].count > 0){
        self.selectedOptions = [[DataLoader sharedInstance] selectedRepairTemporarOptions].mutableCopy;
    }else{
        self.selectedOptions = self.allOptions.mutableCopy;
    }
    
}

-(NSMutableArray *)getOptionsTypeOfArray:(NSMutableArray *)array {
    if ([[DataLoader sharedInstance] currentJobCallType] == qtPlumbing) {
        if ([array isEqualToArray:[[DataLoader sharedInstance] iPadCommonRepairsOptions]])
            return [[DataLoader sharedInstance] plumbingCommonRepairsOptions];
        else if ([array isEqualToArray:[[DataLoader sharedInstance] otherOptions]])
            return [[DataLoader sharedInstance] plumbingOtherOptions];
    }else{
        if ([array isEqualToArray:[[DataLoader sharedInstance] iPadCommonRepairsOptions]])
            return [[DataLoader sharedInstance] iPadCommonRepairsOptions];
        else if ([array isEqualToArray:[[DataLoader sharedInstance] otherOptions]])
            return [[DataLoader sharedInstance] otherOptions];
    }
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    return returnArr;
}

- (void)customRepairOtionAdded:(NSNotification *)info {
    self.allOptions = nil;
    NSMutableArray *allOptionsArray = [[NSMutableArray alloc] initWithArray:[self getOptionsTypeOfArray:[[DataLoader sharedInstance] otherOptions]]];
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions] count] > 0){
        [allOptionsArray addObjectsFromArray:[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions]];
    }
    self.allOptions = allOptionsArray.mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.customRepairButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.tfSearch.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.tfSearch.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.tfSearch.layer.borderWidth   = 1.0;
    self.tfSearch.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
}
#pragma mark -

-(void)setAllOptions:(NSArray *)allOptions {
    
    _allOptions = allOptions;
    [self setFilterTerm:@""];
}

-(void) setFilterTerm:(NSString *)filterTerm
{
    if ([filterTerm length]) {
        
        [self.filteredOptions removeAllObjects];
        [self.allOptions enumerateObjectsUsingBlock:^(PricebookItem *priceBook, NSUInteger idx, BOOL *stop) {
            if ([priceBook.name rangeOfString: filterTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.filteredOptions addObject: priceBook];
            }
        }];
        
    } else {
        self.filteredOptions = [NSMutableArray arrayWithArray: self.allOptions];
    }
    
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    self.filteredOptions = [[NSMutableArray alloc]initWithArray:[self.filteredOptions sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
    
    [self.collectionView reloadData];
}

#pragma mark - Continue Action
- (IBAction)btnContinueTouch:(id)sender {
    
    [DataLoader saveOptionsLocal:self.selectedOptions];
   
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Custom Repair Button
- (IBAction)customRepairClicked:(id)sender {
    
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filteredOptions count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = indexPath.item;
    PricebookItem *item      = self.filteredOptions[itemIndex];
    
    __weak SummaryOfFindingOptionsEditVC *weakSelf = self;
    ServiceOptionViewCell             *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.btnCheckbox.selected = [self.selectedOptions containsObject:item];
    cell.lbValue.text         = item.name;
    cell.qtyTextField.delegate = self;
    cell.qtyTextField.text    = item.quantity;
    cell.qtyTextField.tag = itemIndex;
    cell.tag = itemIndex;
    [cell setOnCheckboxToggle:^(BOOL selected){
        id selectedItem = weakSelf.filteredOptions[itemIndex];
        if ([self.selectedOptions containsObject:selectedItem]) {
            [weakSelf.selectedOptions removeObject:selectedItem];
        } else {
            [weakSelf.selectedOptions addObject:selectedItem];
        }
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id selectedItem = self.filteredOptions[indexPath.item];
    
    if ([self.selectedOptions containsObject:selectedItem]) {
        [self.selectedOptions removeObject:selectedItem];
    } else {
        [self.selectedOptions addObject:selectedItem];
    }
    
    ServiceOptionViewCell *cell = (ServiceOptionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnCheckbox.selected = [self.selectedOptions containsObject:selectedItem];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *term = [textField.text stringByReplacingCharactersInRange:range withString: string];
    
    if ([textField isEqual:self.tfSearch]) {
        self.filterTerm = term;
    }else{
        NSInteger itemIndex = textField.tag;
        PricebookItem *item = self.filteredOptions[itemIndex];
        
        NSUInteger globalIndex = [[self getOptionsTypeOfArray:[[DataLoader sharedInstance] iPadCommonRepairsOptions]] indexOfObject:item];
        item.quantity = term;
        [self.filteredOptions replaceObjectAtIndex:itemIndex withObject:item];
        [[self getOptionsTypeOfArray:[[DataLoader sharedInstance] iPadCommonRepairsOptions]] replaceObjectAtIndex:globalIndex withObject:item];
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Unwind Segues
- (IBAction)unwindToSummaryOfFindings:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToSummaryOfFindingsFromCalculations"]){
        [self performSelector: @selector(showViewControllerAfterUnwind) withObject: nil afterDelay: 0];
    }
    
    //
    //
}

-(void)showViewControllerAfterUnwind
{
    [self performSegueWithIdentifier:@"showAddCustomRepairsVC" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsOptionsVC class]])
//    {
//        SummaryOfFindingsOptionsVC *vc = (SummaryOfFindingsOptionsVC*)segue.destinationViewController;
//        vc.isiPadCommonRepairsOptions = NO;
//        
//    }else if ([segue.identifier isEqualToString:@"showAddCustomRepairsVC"]) {
//        AddCustomRepairVC *vc = [segue destinationViewController];
//        vc.defaultPrice = self.calculatedCustomRepairPrice;
//    }
}

@end
