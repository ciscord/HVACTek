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

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *swrButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;

@property (weak, nonatomic) IBOutlet UIView *separator1;
@property (weak, nonatomic) IBOutlet UIView *separator2;

@end

@implementation NewCustomerChoiceVC

static NSString *kCELL_IDENTIFIER = @"CustomerChoiceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Customer's Choice", nil);
    [self configureColorScheme];

    
    [self.selectedOptionsTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    [self.selectedOptionsTableView reloadData];
    
    
    if (!self.isDiscounted)
        self.stopView.hidden = YES;
    
    [self updateTotalPrice];
}



#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.textFieldInitials.layer.borderWidth   = 1.0;
    self.textFieldInitials.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.textFieldInitials.backgroundColor   = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.textFieldInitials.textColor   = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.btnSendByEmail.layer.borderWidth = 1.0;
    self.btnSendByEmail.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
    self.optionsView.layer.borderWidth   = 1.5;
    self.optionsView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    self.optionsView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    
    self.signatureView.layer.borderWidth   = 1.0;
    self.signatureView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.signatureView.backgroundColor   = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.signatureView.foregroundLineColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.stopView.layer.borderWidth   = 1.0;
    self.stopView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.stopView.backgroundColor   = [UIColor cs_getColorWithProperty:kColorPrimary0];
    
    self.mainView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    self.separator1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separator2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label2.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label3.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label4.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label5.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label6.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label7.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label8.textColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.label9.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label10.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label11.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.totalPriceLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.paymentLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.dueLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.lblSavedWithESA.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lblSavePrice.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    
    self.backBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.saveBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.swrButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}




- (void)updateTotalPrice {
    NSMutableArray *items1 = self.selectedServiceOptionsDict[@"removedItems"];
    
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
    }else{
        self.paymentLabel.text = self.paymentValue;
        self.totalPriceLabel.text = self.initialTotal;
        self.dueLabel.text = @"$0";
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

#pragma mark - Button Actions
- (IBAction)clickedBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedSaveBtn:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud showWhileExecuting:@selector(resetRebatesOnHome) onTarget:self withObject:nil animated:YES];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isInstantRRFinal"];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (!job.completionTime) {
        job.completionTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    
    job.signatureFile = self.signatureView.signatureData;
    job.unselectedServiceOptiunons = self.unselectedOptionsArray;
    job.selectedServiceOptions = self.selectedServiceOptionsDict[@"removedItems"];
    job.serviceLevel = [NSNumber numberWithInt:[self.selectedServiceOptionsDict[@"ServiceID"]intValue]];
    
    job.jobStatus = @(jstNeedDebrief);
    
    if (!job.startTime) {
        job.startTime = [NSDate date];
    }
    
    //job.startTime = [NSDate date];
    [job.managedObjectContext save];
   
    NSMutableArray *items1 = self.selectedServiceOptionsDict[@"removedItems"];
    NSMutableArray * selArray = [[NSMutableArray alloc]init];
    
    for (PricebookItem *p in items1) {
        if (p.itemID != nil) {
        
        
            [selArray addObject:@{@"itemID" :p.itemID,
                                  @"itemNumber" : p.itemNumber,
                                  @"itemGroup" :p.itemGroup,
                                  @"name":p.name,
                                  @"quantity":p.quantity,
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
                                  @"quantity":p.quantity,
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
    NSMutableArray *aitems = self.selectedServiceOptionsDict[@"removedItems"];
    CGFloat totalPriceNormal = 0;
    CGFloat totalPriceESA = 0;
    if (aitems.count) {
     
        for (PricebookItem *p in aitems) {
            int totalQuantity = 1;
            if ([p.quantity intValue] > 1)
              totalQuantity = [p.quantity intValue];
          
            totalPriceNormal += p.amount.floatValue* totalQuantity;
            totalPriceESA += p.amountESA.floatValue* totalQuantity;
        }
    }

  
    int tprice = self.isDiscounted? (int)totalPriceESA : (int)totalPriceNormal;
    
    
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
                            @"totalprice" : [NSString stringWithFormat:@"%d",tprice],
                            @"serviceLevel" : [NSNumber numberWithInt:[self.selectedServiceOptionsDict[@"ServiceID"]intValue]],
                            @"sendEmail":self.btnSendByEmail.selected ? @"1" : @"0",
                            @"signature" : signature,
                            @"packageTotal" : [self cutSymbolOfString:self.initialTotal]
                            };
    
    __weak __typeof(self)weakSelf = self;
    
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


#pragma mark - SWR Button
- (IBAction)swrButtonClicked:(id)sender {
  
  NSMutableArray *selectedItems = self.selectedServiceOptionsDict[@"removedItems"];
  NSMutableArray * selectedArray = [[NSMutableArray alloc] init];
  
  for (PricebookItem *p in selectedItems) {
//    if (p.itemID != nil && ![p.itemID isEqual:@"-1"] && ![p.itemID isEqual:@"-2"] && ![p.itemID isEqual:@"-3"] && ![p.itemID isEqual:@"-4"] && ![p.itemID isEqual:@"-5"] && ![p.itemID isEqual:@"-6"]) {
//        }

    NSNumber *price = self.isDiscounted? p.amountESA : p.amount;
    
    [selectedArray addObject:@{@"sku" : p.itemNumber,
                               @"qty" : [NSNumber numberWithInt:[p.quantity intValue]],
                               @"price" : price,
                               @"taxable" : @false}];
  }

  
  
  NSDictionary * dict = @{ @"items" : selectedArray };
  
  //post invoice
  // NSLog(@"dictionary: %@", dict.description);
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
  NSString * passedString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSString *urlString = [NSString stringWithFormat:@"swremote://?invoiceItems=%@", [self urlEncode:passedString]];
  
  NSURL *url = [NSURL URLWithString:urlString];
  if ([[UIApplication sharedApplication] canOpenURL:url])
  {
    [[UIApplication sharedApplication] openURL:url];
  } else {
    NSLog(@"Handle unable to find a registered app with 'swremote:' scheme");
  }
}


- (NSString *)urlEncode:(NSString *)rawStr {
  NSString *encodedStr = (NSString *)CFBridgingRelease(
                                                       CFURLCreateStringByAddingPercentEscapes(
                                                                                               NULL,
                                                                                               (__bridge CFStringRef)rawStr,
                                                                                               NULL,
                                                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                               kCFStringEncodingUTF8));
  return encodedStr;
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
            return [self.selectedServiceOptionsDict[@"removedItems"] count];
        else
            return [self.selectedServiceOptionsDict[@"removedItems"] count] + 1;
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
            cell.contentView.backgroundColor = [UIColor cs_getColorWithProperty:kColorSecondary0];
        }
        
        if (self.isOnlyDiagnostic)
        {
            if (indexPath.row == 0)
                cell.descriptionLabel.text = self.selectedServiceOptionsDict[@"title"];
            else
                cell.descriptionLabel.text = [[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row] name];
        }
        else
        {
            if (indexPath.row == 0)
                cell.descriptionLabel.text = @"Customer's Choice";
            else
            {
                PricebookItem *p = [self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] ;
                NSString * serviceString;
                if ([p.quantity intValue] > 1) {
                    serviceString = [NSString stringWithFormat:@"     (%@) ",p.quantity];
                }else{
                    serviceString = @"     ";
                }
                
                
                if ([[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Discounts"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"50% Deposit"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comfort Club Membership"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Diagnostic"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comprehensive Precision Tune Up"]) {
                    
                    cell.descriptionLabel.text = p.name;
                }else{
                    cell.descriptionLabel.text = [serviceString stringByAppendingString:p.name];
                }
                
            }
        }

        
        if (!self.isOnlyDiagnostic){
            if (indexPath.row == 0)
                cell.priceLabel.text = self.initialTotal;
            
        }
        
        
        if (indexPath.row != 0) {
            
            if ([[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Discounts"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"50% Deposit"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comfort Club Membership"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Payment"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Diagnostic"] || [[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] name] isEqualToString:@"Comprehensive Precision Tune Up"]) {
                
                if (self.isDiscounted) {
                    NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] amountESA] intValue]];
                    cell.priceLabel.text = [self appendSymbolToString:priceString];
                }
                else{
                    NSString * priceString = [self changeCurrencyFormat:[[[self.selectedServiceOptionsDict[@"removedItems"] objectAtIndex:indexPath.row - 1] amount] intValue]];
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
        
        NSString * serviceString;
        if ([p.quantity intValue] > 1) {
            serviceString = [NSString stringWithFormat:@"(%@) ",p.quantity];
        }else{
            serviceString = @"";
        }
        NSString * nameString = [serviceString stringByAppendingString:p.name];
        
        cell.textLabel.text          = nameString;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textColor     = [UIColor cs_getColorWithProperty:kColorPrimary];
        
        result = cell;
    }
    
    return result;
}

#pragma mark - Currency String

- (NSString *)changeCurrencyFormat:(int)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithInt:number]];
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
