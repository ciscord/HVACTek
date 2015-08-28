//
//  CustomerChoiceVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "CustomerChoiceVC.h"
#import "RecommendationTableViewCell.h"
#import <SignatureView.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CustomerChoiceCell.h"
#import "NewCustomerChoiceVC.h"

@interface CustomerChoiceVC ()

@property (weak, nonatomic) IBOutlet UIView        *vContainer;
@property (weak, nonatomic) IBOutlet UITableView   *tvMainTable;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UITableView   *tvUnselectedOptions;
@property (strong, nonatomic) NSMutableArray       *unusedServiceOptions;
@property (weak, nonatomic) IBOutlet UILabel *subtotaPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldComfortClub;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDisconts;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDeposit;

@end

@implementation CustomerChoiceVC

static NSString *kCELL_IDENTIFIER = @"CustomerChoiceCell"; //RecommendationTableViewCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = NSLocalizedString(@"Customer's Choice", nil);

    self.vContainer.layer.borderWidth = 1.0;
    self.vContainer.layer.borderColor = [[UIColor colorWithRed:0.471 green:0.741 blue:0.267 alpha:1.000] CGColor];

    [self.tvMainTable registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
//    [self.tvMainTable reloadData];

    
    self.descriptionView.layer.borderWidth   = 1.5;
    self.descriptionView.layer.borderColor   = [[UIColor lightGrayColor] CGColor];
    
    self.signatureView.layer.borderWidth   = 1.5;
    self.signatureView.layer.borderColor   = [[UIColor darkGrayColor] CGColor];
    self.signatureView.foregroundLineColor = [UIColor colorWithRed:0.000 green:0.250 blue:0.702 alpha:1.000];
    
    self.textFieldComfortClub.layer.borderWidth   = 1.0;
    self.textFieldComfortClub.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    self.textFieldDisconts.layer.borderWidth   = 1.0;
    self.textFieldDisconts.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    self.textFieldDeposit.layer.borderWidth   = 1.0;
    self.textFieldDeposit.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];

    
    [self refreshSubtotalPrice];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSubtotalPrice {
    NSMutableArray *items1 = self.selectedServiceOptions[@"items"];
    
    if (items1.count) {
        CGFloat totalPriceNormal = 0;
        CGFloat totalPriceESA = 0;
        for (PricebookItem *p in items1) {
            totalPriceNormal += p.amount.floatValue;
            totalPriceESA += p.amountESA.floatValue;
        }
        
        //[self.btnPrice1 setTitle:[NSString stringWithFormat:@"$%.0f", totalPriceESA ] forState:UIControlStateNormal];
        //[self.btnPrice2 setTitle:[NSString stringWithFormat:@"$%.0f", totalPriceNormal] forState:UIControlStateNormal];

        
        if (self.isDiscounted)
            self.subtotaPriceLabel.text = [self changeCurrencyFormat:totalPriceESA];
        else
            self.subtotaPriceLabel.text = [self changeCurrencyFormat:totalPriceNormal];

        
    }
}
- (IBAction)btnContinue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"newCustomerChoiceSegue" sender:self];
}

- (IBAction)btnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (!job.completionTime) {
        job.completionTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    
    job.signatureFile = self.signatureView.signatureData;
    job.unselectedServiceOptiunons = self.unusedServiceOptions;
    job.selectedServiceOptions = self.selectedServiceOptions[@"items"];
    job.serviceLevel = [NSNumber numberWithInt:[self.selectedServiceOptions[@"ServiceID"]intValue]];
    
    job.jobStatus = @(jstNeedDebrief);
   // job.startTime = [NSDate date];
    [job.managedObjectContext save];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController popToViewController:appDelegate.homeController animated:YES];
}

- (IBAction)btnClearSignature:(id)sender {
    [self.signatureView clear];
}

- (void)setSelectedServiceOptions:(NSDictionary *)selectedServiceOptions {

    _selectedServiceOptions = selectedServiceOptions;
    NSArray *selectedItems = _selectedServiceOptions[@"items"];
    self.unusedServiceOptions = @[].mutableCopy;
    for (PricebookItem *p1 in _fullServiceOptions) {

        BOOL unselected = YES;

        for (PricebookItem *p2 in selectedItems) {
            if ([p1.name isEqualToString:p2.name]) {
                unselected = NO;
                break;
            }
        }

        if (unselected) {
            [self.unusedServiceOptions addObject:p1];
        }
    }
    [self.tvMainTable reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    NewCustomerChoiceVC *vc = [segue destinationViewController];
    vc.isDiscounted       = self.isDiscounted;
    vc.isOnlyDiagnostic   = self.isOnlyDiagnostic;
    vc.unselectedOptionsArray = self.unusedServiceOptions;
    //vc.selectedServiceOptionsDict = self.selectedServiceOptions;
    vc.selectedServiceOptionsDict = [self addDiscountsToDictionary:self.selectedServiceOptions];

    
    if (self.isOnlyDiagnostic) {
        
        PricebookItem *diagnosticOnlyItem = [[DataLoader sharedInstance] diagnosticOnlyOption];
        
        PricebookItem *diagnosticOnlyItemNoTitle = [PricebookItem new];
        diagnosticOnlyItemNoTitle.itemID     = diagnosticOnlyItem.itemID;
        diagnosticOnlyItemNoTitle.itemNumber = diagnosticOnlyItem.itemNumber;
        diagnosticOnlyItemNoTitle.itemGroup  = diagnosticOnlyItem.itemGroup;
        diagnosticOnlyItemNoTitle.amount     = diagnosticOnlyItem.amount;
        
        NSDictionary *d = @{
                            @"items" : @[diagnosticOnlyItemNoTitle],
                            @"title" : @"Diagnostic Only"
                            };
        
        vc.selectedServiceOptionsDict = [self addDiscountsToDictionary:d];//d;
    }
    
}

- (NSDictionary *)addDiscountsToDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.selectedServiceOptions[@"items"]];

    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]].floatValue != 0) {
        PricebookItem *clubMembership = [PricebookItem new];
        clubMembership.amount     = [NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]];
        clubMembership.amountESA = [NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]];
        clubMembership.name = @"Comfort Club Membership";
        
        [newArray addObject:clubMembership];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldDeposit.text] floatValue]].floatValue != 0){
        PricebookItem *deposit = [PricebookItem new];
        deposit.amount     = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDeposit.text] floatValue])];
        deposit.amountESA = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDeposit.text] floatValue])];
        deposit.name = @"50% Deposit";
        
        [newArray addObject:deposit];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldDisconts.text] floatValue]].floatValue != 0) {
        PricebookItem *discount = [PricebookItem new];
        discount.amount     = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDisconts.text] floatValue])];
        discount.amountESA = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDisconts.text] floatValue])];
        discount.name = @"Discount";
        
        [newArray addObject:discount];
    }
    
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:dictionary]; //self.selectedServiceOptions
    
    [newDict removeObjectForKey:@"items"];
    [newDict setObject:newArray forKey:@"items"];
    
    return newDict;
}

- (NSString *)cutString:(NSString*)string {
    
    NSString *newText;
    
    if (string.length > 1){
        newText = [string substringFromIndex:1];
    }else{
        newText = @"0";
    }
    
    return newText;
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length  == 0)
    {
        //textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
        textField.text = @"$";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Make sure that the currency symbol is always at the beginning of the string:
    if (![newText hasPrefix:@"$"])
    {
        return NO;
    }
    
    // Default:
    return YES;
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvMainTable) {
        return 25;
    }

    if (tableView == self.tvUnselectedOptions) {
        return 25;
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvMainTable) {
        return [self.selectedServiceOptions[@"items"] count];
    }

    if (tableView == self.tvUnselectedOptions) {
        return [self.unusedServiceOptions count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *result;
    
    if (tableView == self.tvMainTable) {

//        NSMutableArray *items1 = self.selectedServiceOptions[@"items"];
//
//        RecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
//        cell.gradientView.image        = self.selectedServiceOptions[@"backgroundImage"];
//        cell.lbRecommandationName.text = self.selectedServiceOptions[@"title"];
//        cell.rowIndex                  = indexPath.row;
//        cell.optionsDisplayType        = odtCustomerFinalChoice;
//        cell.isDiscounted              = self.isDiscounted;
//        [cell displayServiceOptions:items1];
//       
//        //set job price
//         Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
//        job.price = [NSNumber numberWithFloat:[cell.lbSelectOption.text floatValue]];
//        [job.managedObjectContext save];
//        result = cell;
        

        
        CustomerChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
        
        
        if (indexPath.row % 2)
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }else {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:246/255.0f blue:225/255.0f alpha:1.0f];
        }
        
        if (self.isOnlyDiagnostic)
            cell.descriptionLabel.text = self.selectedServiceOptions[@"title"];
        else
            cell.descriptionLabel.text = [[self.selectedServiceOptions[@"items"] objectAtIndex:indexPath.row] name];
        
        if (self.isDiscounted) {
            NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptions[@"items"] objectAtIndex:indexPath.row] amountESA] floatValue]];
            
            cell.priceLabel.text = priceString;
        }
        else{
                NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptions[@"items"] objectAtIndex:indexPath.row] amount] floatValue]];
                cell.priceLabel.text = priceString;
            }
        
        result = cell;
    }

    if (tableView == self.tvUnselectedOptions) {

        static NSString *cellIdentifier = @"identifier";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        PricebookItem *p = self.unusedServiceOptions[indexPath.row];
        cell.textLabel.text          = p.name;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font          = [UIFont fontWithName:@"Calibri-Light" size:17];
        cell.textLabel.textColor     = [UIColor darkGrayColor];

        result = cell;
    }

    return result;
}

#pragma mark - Currency String

- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithFloat:number]];
}

@end
