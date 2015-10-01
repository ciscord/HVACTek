//
//  NewCustomerChoiceVC.m
//  Signature
//
//  Created by Dorin on 8/11/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "NewCustomerChoiceVC.h"
#import "CustomerChoiceCell.h"
#import "AppDelegate.h"
#import <SignatureView.h>

@interface NewCustomerChoiceVC ()

@property (weak, nonatomic) IBOutlet UITableView *unselectedOptionsTableView;
@property (weak, nonatomic) IBOutlet UITableView *selectedOptionsTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueLabel;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInitials;
@property (weak, nonatomic) IBOutlet UIView *stopView;
@property (weak, nonatomic) IBOutlet UIView *snapShotView;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property (strong, nonatomic) IBOutlet UIButton *btnSendByEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblSavePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSavedWithESA;



@end

@implementation NewCustomerChoiceVC

static NSString *kCELL_IDENTIFIER = @"CustomerChoiceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Customer's Choice", nil);
    
    self.textFieldInitials.layer.borderWidth   = 1.0;
    self.textFieldInitials.layer.borderColor   = [[UIColor grayColor] CGColor];
    
    [self.selectedOptionsTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    [self.selectedOptionsTableView reloadData];
    
    
    if (!self.isDiscounted)
        self.stopView.hidden = YES;
    
    [self updateTotalPrice];
}


- (void)updateTotalPrice {
    NSMutableArray *items1 = self.selectedServiceOptionsDict[@"items"];
    
    if (items1.count) {
        CGFloat totalPriceNormal = 0;
        CGFloat totalPriceESA = 0;
        for (PricebookItem *p in items1) {
            totalPriceNormal += p.amount.floatValue;
            totalPriceESA += p.amountESA.floatValue;
        }

        
        
        NSNumber *paymentNumber = [NSNumber numberWithFloat:fabsf([[self cutString:self.paymentValue] floatValue])];
        
        self.paymentLabel.text = self.paymentValue;
        if (self.isDiscounted){
            self.totalPriceLabel.text = self.initialTotal;//[self changeCurrencyFormat:totalPriceESA];
            self.dueLabel.text = [self changeCurrencyFormat:totalPriceESA];
        }
        else {
            self.totalPriceLabel.text = self.initialTotal;//[self changeCurrencyFormat:totalPriceNormal];
            self.dueLabel.text = [self changeCurrencyFormat:totalPriceNormal];
        }
        
       
        self.lblSavePrice.text = [NSString stringWithFormat:@"If You Were A Member Of Our Comfort Club Program You Would Save %@",[self changeCurrencyFormat:(totalPriceESA - totalPriceNormal)]];
        self.lblSavedWithESA.text = [NSString stringWithFormat:@"You Saved %@ By Being A Member Of Our Comfort Club!",[self changeCurrencyFormat:(totalPriceESA - totalPriceNormal)]];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickedBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedSaveBtn:(UIButton *)sender {
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (!job.completionTime) {
        job.completionTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    
    job.signatureFile = self.signatureView.signatureData;
    job.unselectedServiceOptiunons = self.unselectedOptionsArray;
    job.selectedServiceOptions = self.selectedServiceOptionsDict[@"items"];
    job.serviceLevel = [NSNumber numberWithInt:[self.selectedServiceOptionsDict[@"ServiceID"]intValue]];
    
    job.jobStatus = @(jstNeedDebrief);
    // job.startTime = [NSDate date];
    [job.managedObjectContext save];
   
    NSMutableArray *items1 = self.selectedServiceOptionsDict[@"items"];
    NSMutableArray * selArray = [[NSMutableArray alloc]init];
    
    for (PricebookItem *p in items1) {
        if (p.itemID != nil) {
        
        
            [selArray addObject:@{@"itemID" :p.itemID,
                                  @"itemNumber" : p.itemNumber,
                                  @"itemGroup" :p.itemGroup,
                                  @"name":p.name,
                                  @"amount":p.amount,
                                  @"amountESA": p.amountESA }];
        }
    }
    
    
    NSMutableArray * unselArray = [[NSMutableArray alloc]init];
    NSMutableArray *items2 =  self.unselectedOptionsArray;
    for (PricebookItem *p in items2) {
      if (p.itemID != nil) {

          [unselArray addObject:@{@"itemID" :p.itemID,
                                  @"itemNumber" : p.itemNumber,
                                  @"itemGroup" :p.itemGroup,
                                  @"name":p.name,
                                  @"amount":p.amount,
                                  @"amountESA": p.amountESA }];
      }
        
    }
    
   
    NSMutableDictionary *customerInfo = [[NSMutableDictionary alloc]initWithDictionary: job.swapiCustomerInfo];
    
    UIImage *image = [UIImage imageWithData:[DataLoader sharedInstance].currentUser.activeJob.signatureFile];
    NSString *signature = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (signature == nil)  //signature was removed
        signature = @"";
   
    /*(total paid, club membership, discount, deposit*/
    NSMutableArray *aitems = self.selectedServiceOptionsDict[@"items"];
    CGFloat totalPriceNormal = 0;
    CGFloat totalPriceESA = 0;
    if (aitems.count) {
     
        for (PricebookItem *p in aitems) {
            totalPriceNormal += p.amount.floatValue;
            totalPriceESA += p.amountESA.floatValue;
        }
    }
    
    CGFloat tprice = self.isDiscounted? totalPriceESA : totalPriceNormal;
    
    NSDictionary * dict = @{@"userID" : [DataLoader sharedInstance].currentUser.userID,
                            @"userCode" : [DataLoader sharedInstance].currentUser.userCode,
                            @"userName" : [DataLoader sharedInstance].currentUser.userName,
                            @"jobID" : job.jobID,
                            @"FirstName" : [customerInfo objectForKeyNotNull:@"FirstName"],
                            @"LastName": [customerInfo objectForKeyNotNull:@"LastName"],
                            @"Address1": [customerInfo objectForKeyNotNull:@"Address1"],
                            @"Address2": [customerInfo objectForKeyNotNull:@"Address2"],
                            @"City": [customerInfo objectForKeyNotNull:@"City"],
                            @"State": [customerInfo objectForKeyNotNull:@"State"],
                            @"Zip":[customerInfo objectForKeyNotNull:@"Zip"],
                            @"AccountEmail" : [customerInfo objectForKeyNotNull:@"AccountEmail"],
                            @"Phone" :[customerInfo objectForKeyNotNull:@"Phone"],
                            @"unselectedServiceOptiunons" : unselArray,
                            @"selectedServiceOptions" : selArray,
                            @"totalprice" : [NSString stringWithFormat:@"%.2f",tprice],
                            @"serviceLevel" : [NSNumber numberWithInt:[self.selectedServiceOptionsDict[@"ServiceID"]intValue]],
                            @"sendEmail":self.btnSendByEmail.selected ? @"1" : @"0",
                            @"signature" : signature,
                            @"packageTotal" : [self cutSymbolOfString:self.initialTotal]
                            };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 [[DataLoader sharedInstance] postInvoice:dict onSuccess:^(NSString *message) {
     [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     [weakSelf.navigationController popToViewController:appDelegate.homeController animated:YES];
     
 } onError:^(NSError *error) {
      [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
 }];
}
- (IBAction)agreeBtnClicked:(id)sender {
    UIButton *button = sender;
    
    if (!button.selected)
        button.selected = YES;
    else
        button.selected = NO;
}

- (IBAction)sendByEmailButton:(id)sender {
   
    
    if (!self.btnSendByEmail.selected)
        self.btnSendByEmail.selected = YES;
    else
        self.btnSendByEmail.selected = NO;
}

#pragma mark - SignatureView

- (IBAction)btnClearSignature:(id)sender {
    [self.signatureView clear];
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.selectedOptionsTableView) {
        return 25;
    }
    
    if (tableView == self.unselectedOptionsTableView) {
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
    
    if (tableView == self.selectedOptionsTableView) {
        
        if (self.isOnlyDiagnostic)
            return [self.selectedServiceOptionsDict[@"items"] count];
        else
            return [self.selectedServiceOptionsDict[@"items"] count] + 1;
    }
    
    if (tableView == self.unselectedOptionsTableView) {
        return [self.unselectedOptionsArray count];
    }
    
    
    return 0;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *result;
    
    if (tableView == self.selectedOptionsTableView) {

        
        CustomerChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
        
        
        if (indexPath.row % 2)
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }else {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:246/255.0f blue:225/255.0f alpha:1.0f];
        }
        
        if (self.isOnlyDiagnostic)
        {
            if (indexPath.row == 0)
                cell.descriptionLabel.text = self.selectedServiceOptionsDict[@"title"];
            else
                cell.descriptionLabel.text = [[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row] name];
        }
        else
        {
            if (indexPath.row == 0)
                cell.descriptionLabel.text = @"Package Total";
            else
            {
                
                if ([[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Discounts"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment or 50% Deposit"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comfort Club Membership"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment"]) {
                    
                    cell.descriptionLabel.text = [[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name];
                }else{
                    cell.descriptionLabel.text = [@"     " stringByAppendingString:[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name]];
                }
                
            }
        }
        
        
        if (!self.isOnlyDiagnostic){
            if (indexPath.row == 0)
                cell.priceLabel.text = self.initialTotal;
            
        }
        
        
        if (indexPath.row != 0) {
            
            if ([[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Discounts"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment or 50% Deposit"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comfort Club Membership"] || [[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment"]) {
                
                if (self.isDiscounted) {
                    NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] amountESA] floatValue]];
                    cell.priceLabel.text = [self appendSymbolToString:priceString];
                }
                else{
                    NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptionsDict[@"items"] objectAtIndex:indexPath.row - 1] amount] floatValue]];
                    cell.priceLabel.text = [self appendSymbolToString:priceString];
                }
            }else{
                
                cell.priceLabel.text = @"";
            }
        }
        
        
        result = cell;
    }
    
    if (tableView == self.unselectedOptionsTableView) {
        
        static NSString *cellIdentifier = @"identifier";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        PricebookItem *p = self.unselectedOptionsArray[indexPath.row];
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

- (NSString *)appendSymbolToString:(NSString *)string {
    
    NSString *returnString = string;
    
    if (string.length > 0){
        NSString * firstLetter = [string substringToIndex:1];
        if ([firstLetter  isEqual: @"$"]){
            returnString = [@"+ " stringByAppendingString:returnString];
        }else if ([firstLetter  isEqual: @"-"]){
            returnString = [returnString stringByReplacingOccurrencesOfString:@"-$" withString:@"- $"];
        }
    }
    
    return returnString;
}

- (NSString *)cutSymbolOfString:(NSString *)string {
    
    NSString *returnString = [string stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return returnString;
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
