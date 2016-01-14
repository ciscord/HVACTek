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
#import "TPKeyboardAvoidingScrollView.h"

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
@property (weak, nonatomic) IBOutlet UITextField *textFieldPayment;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDiagnostic;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCPT;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *keyboardAvoiding;
@property (weak, nonatomic) IBOutlet UIView *helperView;

@end

@implementation CustomerChoiceVC

static NSString *kCELL_IDENTIFIER = @"CustomerChoiceCell"; //RecommendationTableViewCell


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = NSLocalizedString(@"Customer's Choice", nil);
    
    self.keyboardAvoiding.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);

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
    self.textFieldPayment.layer.borderWidth   = 1.0;
    self.textFieldPayment.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    self.textFieldDiagnostic.layer.borderWidth   = 1.0;
    self.textFieldDiagnostic.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    self.textFieldCPT.layer.borderWidth   = 1.0;
    self.textFieldCPT.layer.borderColor   = [[UIColor colorWithRed:119/255.0f green:189/255.0f blue:67/255.0f alpha:1.0f] CGColor];
    
    [self refreshSubtotalPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSubtotalPrice {
    NSMutableArray *items1 = self.selectedServiceOptions[@"removedItems"];
    
    if (items1.count) {
        CGFloat totalPriceNormal = 0;
        CGFloat totalPriceESA = 0;
        for (PricebookItem *p in items1) {
            int totalQuantity = 1;
            if ([p.quantity intValue] > 1)
                totalQuantity = [p.quantity intValue];
            
            totalPriceNormal += p.amount.floatValue * totalQuantity;
            totalPriceESA += p.amountESA.floatValue * totalQuantity;
        }

        
        if (self.isDiscounted)
            self.subtotaPriceLabel.text = [self changeCurrencyFormat:totalPriceESA];
        else
            self.subtotaPriceLabel.text = [self changeCurrencyFormat:totalPriceNormal];
        
    }else{
        self.subtotaPriceLabel.text = @"$0.00";
    }
}


- (IBAction)btnContinue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"newCustomerChoiceSegue" sender:self];
}


- (IBAction)btnBack:(UIButton *)sender {
    if (self.isComingFromInvoice) {
        [self performSegueWithIdentifier:@"unwindToServiceOptionsFromCustomersChoice" sender:self];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)btnSave:(id)sender {

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (!job.completionTime) {
        job.completionTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    
    job.signatureFile = self.signatureView.signatureData;
    job.unselectedServiceOptiunons = self.unusedServiceOptions;
    job.selectedServiceOptions = self.selectedServiceOptions[@"removedItems"];
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
    NSArray *selectedItems = _selectedServiceOptions[@"removedItems"];
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



- (NSDictionary *)addDiscountsToDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.selectedServiceOptions[@"removedItems"]];

    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]].floatValue != 0) {
        PricebookItem *clubMembership = [PricebookItem new];
       clubMembership.itemID  = @"-1";
        clubMembership.amount     = [NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]];
        clubMembership.amountESA = [NSNumber numberWithFloat:[[self cutString:self.textFieldComfortClub.text] floatValue]];
        clubMembership.name = @"Comfort Club Membership";
        clubMembership.itemGroup = @"Additional items";
        clubMembership.itemNumber = @"-1";
        clubMembership.quantity = @"";
        
        [newArray addObject:clubMembership];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldDeposit.text] floatValue]].floatValue != 0){
        PricebookItem *deposit = [PricebookItem new];
        deposit.itemID = @"-2";
        deposit.amount     = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDeposit.text] floatValue])];
        deposit.amountESA = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDeposit.text] floatValue])];
        deposit.name = @"Payment or 50% Deposit";
        deposit.itemGroup = @"Additional items";
        deposit.itemNumber = @"-2";
        deposit.quantity = @"";
        [newArray addObject:deposit];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldDisconts.text] floatValue]].floatValue != 0) {
        PricebookItem *discount = [PricebookItem new];
        discount.itemID = @"-3";
        discount.amount     = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDisconts.text] floatValue])];
        discount.amountESA = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldDisconts.text] floatValue])];
        discount.name = @"Discounts";
        discount.itemGroup = @"Additional items";
        discount.itemNumber = @"-3";
        discount.quantity = @"";
        [newArray addObject:discount];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldDiagnostic.text] floatValue]].floatValue != 0) {
        PricebookItem *payment = [PricebookItem new];
        payment.itemID = @"-5";
        payment.amount     = [NSNumber numberWithFloat:[[self cutString:self.textFieldDiagnostic.text] floatValue]];
        payment.amountESA = [NSNumber numberWithFloat:[[self cutString:self.textFieldDiagnostic.text] floatValue]];
        payment.name = @"Diagnostic";
        payment.itemGroup = @"Additional items";
        payment.itemNumber = @"-5";
        payment.quantity = @"";
        [newArray addObject:payment];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldCPT.text] floatValue]].floatValue != 0) {
        PricebookItem *payment = [PricebookItem new];
        payment.itemID = @"-6";
        payment.amount     = [NSNumber numberWithFloat:[[self cutString:self.textFieldCPT.text] floatValue]];
        payment.amountESA = [NSNumber numberWithFloat:[[self cutString:self.textFieldCPT.text] floatValue]];
        payment.name = @"Comprehensive Precision Tune";
        payment.itemGroup = @"Additional items";
        payment.itemNumber = @"-6";
        payment.quantity = @"";
        [newArray addObject:payment];
    }
    
    if ([NSNumber numberWithFloat:[[self cutString:self.textFieldPayment.text] floatValue]].floatValue != 0) {
        PricebookItem *payment = [PricebookItem new];
        payment.itemID = @"-4";
        payment.amount     = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldPayment.text] floatValue])];
        payment.amountESA = [NSNumber numberWithFloat:-fabsf([[self cutString:self.textFieldPayment.text] floatValue])];
        payment.name = @"Payment";
        payment.itemGroup = @"Additional items";
        payment.itemNumber = @"-4";
        payment.quantity = @"";
        [newArray addObject:payment];
    }
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    
    [newDict removeObjectForKey:@"removedItems"];
    [newDict setObject:newArray forKey:@"removedItems"];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvMainTable) {
        return [self.selectedServiceOptions[@"removedItems"] count] + 1;
    }
    
    if (tableView == self.tvUnselectedOptions) {
        return [self.unusedServiceOptions count];
    }
    
    return 0;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *result;
    
    if (tableView == self.tvMainTable) {
        
        CustomerChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
        
        
        if (indexPath.row % 2)
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }else {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:246/255.0f blue:225/255.0f alpha:1.0f];
        }
        
        if (self.isOnlyDiagnostic)
            cell.descriptionLabel.text = self.selectedServiceOptions[@"title"];
        else {
            
            if (indexPath.row == 0) {
                cell.descriptionLabel.text = @"Customer's Choice";
                cell.priceLabel.text = self.subtotaPriceLabel.text;
            }else {
                PricebookItem *p = [self.selectedServiceOptions[@"removedItems"] objectAtIndex:indexPath.row - 1];
                NSString * serviceString;
                if ([p.quantity intValue] > 1) {
                    serviceString = [NSString stringWithFormat:@"     (%@) ",p.quantity];
                }else{
                    serviceString = @"     ";
                }
                cell.descriptionLabel.text = [serviceString stringByAppendingString:p.name];
                cell.priceLabel.text = @"";
            }
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
        
        NSString * serviceString;
        if ([p.quantity intValue] > 1) {
            serviceString = [NSString stringWithFormat:@"(%@) ",p.quantity];
        }else{
            serviceString = @"";
        }
        NSString * nameString = [serviceString stringByAppendingString:p.name];
        
        cell.textLabel.text          = nameString;
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
    [formatterCurrency setMaximumFractionDigits:2];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithFloat:number]];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"newCustomerChoiceSegue"]) {
        NewCustomerChoiceVC *vc = [segue destinationViewController];
        vc.isDiscounted       = self.isDiscounted;
        vc.isOnlyDiagnostic   = self.isOnlyDiagnostic;
        vc.unselectedOptionsArray = self.unusedServiceOptions;
        //vc.selectedServiceOptionsDict = self.selectedServiceOptions;
        vc.selectedServiceOptionsDict = [self addDiscountsToDictionary:self.selectedServiceOptions];
        vc.initialTotal = self.subtotaPriceLabel.text;
        if ([NSNumber numberWithFloat:[[self cutString:self.textFieldPayment.text] floatValue]].floatValue != 0) {
            vc.paymentValue = [self changeCurrencyFormat:[[self cutString:self.textFieldPayment.text] floatValue]];
        }else{
            vc.paymentValue = @"$0.00";
        }
        
        
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
    
    
}




@end
