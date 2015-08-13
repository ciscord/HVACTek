//
//  ServiceOptionsVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "SummaryOfFindingsOptionsVC.h"
#import "ServiceOptionViewCell.h"
#import "SummaryOfFindingsVC.h"
#import "PricebookItem.h"

@interface SummaryOfFindingsOptionsVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray               *allOptions;
@property (nonatomic, strong) NSMutableArray        *filteredOptions;
@property (nonatomic, strong) NSMutableArray        *selectedOptions;
@property (weak, nonatomic) IBOutlet UITextField    *tfSearch;
@end

@implementation SummaryOfFindingsOptionsVC

static NSString *kCellIdentifier = @"ServiceOptionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Common Repairs";
    
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
    
    if (self.isiPadCommonRepairsOptions) {
        self.allOptions = [[DataLoader sharedInstance] iPadCommonRepairsOptions];
        self.selectedOptions = self.allOptions.mutableCopy;
    }
    else {
        
        if (!self.selectedOptions) {
            self.selectedOptions = @[].mutableCopy;
        }
        self.allOptions = [[DataLoader sharedInstance] otherOptions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.collectionView reloadData];
}

#pragma mark - Navigation

- (IBAction)btnContinueTouch:(id)sender {

    [DataLoader saveOptionsLocal:self.selectedOptions];
    [self performSegueWithIdentifier:(self.isiPadCommonRepairsOptions ? @"selectOptionsSegue" : @"selectPriceBookSegue") sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsOptionsVC class]])
    {
        SummaryOfFindingsOptionsVC *vc = (SummaryOfFindingsOptionsVC*)segue.destinationViewController;
        vc.isiPadCommonRepairsOptions = NO;
        vc.selectedOptions = self.selectedOptions.mutableCopy;
    }
    else if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsVC class]])
    {
        SummaryOfFindingsVC *vc = (SummaryOfFindingsVC*)segue.destinationViewController;
        vc.selectedServiceOptions = self.selectedOptions;
    }
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

    __weak SummaryOfFindingsOptionsVC *weakSelf = self;
    ServiceOptionViewCell             *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.btnCheckbox.selected = [self.selectedOptions containsObject:item];
    cell.lbValue.text         = item.name;
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
    
    self.filterTerm = term;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
