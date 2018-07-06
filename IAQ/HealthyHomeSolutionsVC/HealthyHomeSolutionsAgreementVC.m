//
//  HealthyHomeSolutionsAgreementVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsAgreementVC.h"
#import "TYAlertController.h"
#import "IAQDataModel.h"
#import <SignatureView.h>
@interface HealthyHomeSolutionsAgreementVC ()
{
    NSMutableArray* selectedProductArray;
    float totalCost;
    NSString* authid;
    NSString* iaqProductString;
}
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;

@property (weak, nonatomic) IBOutlet UITableView *enlargeTable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView1;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;

@end

@implementation HealthyHomeSolutionsAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
  
    self.signatureView.layer.borderWidth   = 1.0;
    self.signatureView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.signatureView.backgroundColor   = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.signatureView.foregroundLineColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.separatorView1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.priceLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    if (self.iaqType == BEST) {
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBestProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].bestTotalPrice;
        self.optionNameLabel.text = @"BEST";
    }else if (self.iaqType == BETTER) {
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].betterTotalPrice;
        self.optionNameLabel.text = @"BETTER";
    }else if (self.iaqType == GOOD) {
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].goodTotalPrice;
        self.optionNameLabel.text = @"GOOD";
    }
    
    if (self.fromAddCart2) {
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        iaqProductString = [userdefault objectForKey:@"iaqProduct"];
        totalCost = [[userdefault objectForKey:@"totalCost"] floatValue];
        NSString *signature = [userdefault objectForKey:@"signature"];
        if (signature != nil) {
            NSData* imageData = [[NSData alloc] initWithBase64EncodedString:signature options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* signatureImage = [UIImage imageWithData:imageData];
            [self.signatureView setImage:signatureImage];
        }
        
        
    }
    
    if (self.costType == SAVING) {
        self.firstLabel.text = @"15% Savings";
        
        if (totalCost >= 1000) {
            self.secondLabel.text = @"0% Financing";
            self.thirdLabel.text = [NSString stringWithFormat:@"24 Equal Payments Of $%d", (int)((totalCost * 0.85) / 24)];
        }else{
            self.secondLabel.text = @"Does Not Qualify";
            self.thirdLabel.text = @"For Financing";
        }
        
        [self.priceLabel setTextColor:[UIColor blackColor]];
    
        totalCost = totalCost * 0.85;
        self.priceLabel.text = [self changeCurrencyFormat:totalCost];
        
        
        
    }else{
        
        self.firstLabel.text = @"15% Savings";
        
        if (totalCost >= 1000) {
            self.secondLabel.text = @"0% Financing";
            self.thirdLabel.text = [NSString stringWithFormat:@"24 Equal Payments Of $%d", (int)((totalCost * 0.85) / 24)];
        }else{
            self.secondLabel.text = @"Does Not Qualify";
            self.thirdLabel.text = @"For Financing";
        }
        
        [self.priceLabel setTextColor:[UIColor hx_colorWithHexString:@"C42E3C"]];
        self.priceLabel.text = [self changeCurrencyFormat:totalCost];
        
    }
    
    self.authorizeButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.mainMenuButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.emailButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
}
- (IBAction)authorizeSignatureClearClicked:(id)sender {
    [self.signatureView clear];
}
-(IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)mainMenuClick:(id)sender {
    NSArray* viewControllers = self.navigationController.viewControllers;
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:true];
}

-(IBAction)authorizeClick:(id)sender {
    __weak typeof (self) weakSelf = self;
    UIImage *image = [UIImage imageWithData:self.signatureView.signatureData];
    NSString *signature = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (signature == nil) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Signature is required"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    alertView.alertViewWidth = [UIScreen mainScreen].bounds.size.width / 3 * 2;
    alertView.textFieldHeight = 60;
    alertView.buttonHeight = 60;
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* nameField = [alertView.textFieldArray objectAtIndex:0];
        
        if ([nameField.text isEqualToString:@""]) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Empty name"];
            [self presentViewController:alert animated:true completion:nil];
        }else {
            
            NSString* iaqProductStringFormatted = @"";
            if (selectedProductArray.count >= 1) {
                IAQProductModel* iaqProduct = selectedProductArray[0];
                iaqProductStringFormatted = [NSString stringWithFormat:@"%@", iaqProduct.title];
            }
            if (selectedProductArray.count > 1) {
                for (int i = 1; i < selectedProductArray.count; i++) {
                    IAQProductModel* iaqProduct = selectedProductArray[i];
                    iaqProductStringFormatted = [NSString stringWithFormat:@"%@,%@", iaqProductStringFormatted, iaqProduct.title];
                }
            }
            
            if (self.fromAddCart2) {
                NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                
                iaqProductStringFormatted = [userdefault objectForKey:@"iaqProductStringFormatted"];
                if (iaqProductStringFormatted == nil) {
                    iaqProductStringFormatted = @"";
                }
            }
            
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            
            NSString* technicanName = [NSString stringWithFormat:@"%@ %@", [DataLoader sharedInstance].currentUser.firstName, [DataLoader sharedInstance].currentUser.lastName];
            
            [[DataLoader sharedInstance] addIaqAuthorizeSale:iaqProductStringFormatted
                                                    customer:nameField.text
                                                  technician:technicanName
                                                       price:totalCost
                                                   signature:signature
                                                   onSuccess:^(NSDictionary *dataDictionary) {
                                                       
                                                       authid = [dataDictionary objectForKey:@"id"];
                                                       
                                                       [[DataLoader sharedInstance] emailIaqAuthorizeSale:authid email:[DataLoader sharedInstance].currentCompany.invoice_email onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                                                               [userdefault setObject:iaqProductString forKey:@"iaqProduct"];
                                                               [userdefault setObject:iaqProductStringFormatted forKey:@"iaqProductStringFormatted"];
                                                               [userdefault setObject:[NSNumber numberWithFloat:totalCost] forKey:@"totalCost"];
                                                               [userdefault setObject:signature forKey:@"signature"];
                                                               [userdefault synchronize];
                                                               
                                                               [self showEmailSentAlert:[DataLoader sharedInstance].currentCompany.invoice_email];
                                                           });
                                                           
                                                           
                                                       } onError:^(NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed sending Email"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           });
                                                           
                                                       }];
                                                       
                                                   } onError:^(NSError *error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                           if (error.code == 1001) {
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Customer Name is required"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           }else {
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           }
                                                       });
                                                       
                                                   }];
            
        
        }
        
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name:";
    }];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = true;
    [self presentViewController:alertController animated:true completion: nil];
    
    
}

-(IBAction)emailClick:(id)sender {
    
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    alertView.alertViewWidth = [UIScreen mainScreen].bounds.size.width / 3 * 2;
    alertView.textFieldHeight = 60;
    alertView.buttonHeight = 60;
    __weak typeof (self) weakSelf = self;
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* nameField = [alertView.textFieldArray objectAtIndex:0];
        UITextField* emailField = [alertView.textFieldArray objectAtIndex:1];
        
        NSString* emailString = emailField.text;
        if ([emailString isEqualToString:@""]) {
            emailString = [NSString stringWithFormat:@"%@, %@", [DataLoader sharedInstance].currentUser.email, [DataLoader sharedInstance].currentCompany.invoice_email];
        }else {
            emailString = [NSString stringWithFormat:@"%@, %@, %@", emailString, [DataLoader sharedInstance].currentUser.email, [DataLoader sharedInstance].currentCompany.invoice_email];
        }
        if ([nameField.text isEqualToString:@""]) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Empty name"];
            [self presentViewController:alert animated:true completion:nil];
        }else if (![emailString isValidEmail]) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Invalid Email"];
            [self presentViewController:alert animated:true completion:nil];
            
        }else {
            
            NSString* iaqProductStringFormatted = @"";
            if (selectedProductArray.count >= 1) {
                IAQProductModel* iaqProduct = selectedProductArray[0];
                iaqProductStringFormatted = [NSString stringWithFormat:@"%@", iaqProduct.title];
            }
            if (selectedProductArray.count > 1) {
                for (int i = 1; i < selectedProductArray.count; i++) {
                    IAQProductModel* iaqProduct = selectedProductArray[i];
                    iaqProductStringFormatted = [NSString stringWithFormat:@"%@,%@", iaqProductStringFormatted, iaqProduct.title];
                }
            }
            
            if (self.fromAddCart2) {
                NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                
                iaqProductStringFormatted = [userdefault objectForKey:@"iaqProductStringFormatted"];
                if (iaqProductStringFormatted == nil) {
                    iaqProductStringFormatted = @"";
                }
            }
            
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            
            NSString* technicanName = [NSString stringWithFormat:@"%@ %@", [DataLoader sharedInstance].currentUser.firstName, [DataLoader sharedInstance].currentUser.lastName];
            
            [[DataLoader sharedInstance] addIaqAuthorizeSaleUnapproved:iaqProductStringFormatted
                                                    customer:nameField.text
                                                  technician:technicanName
                                                       price:totalCost
                                                   onSuccess:^(NSDictionary *dataDictionary) {
                                                       
                                                       authid = [dataDictionary objectForKey:@"id"];
                                                       
                                                       [[DataLoader sharedInstance] emailIaqAuthorizeSale:authid email:emailString onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                                                               [userdefault setObject:iaqProductString forKey:@"iaqProduct"];
                                                               [userdefault setObject:iaqProductStringFormatted forKey:@"iaqProductStringFormatted"];
                                                               [userdefault setObject:[NSNumber numberWithFloat:totalCost] forKey:@"totalCost"];
                                                               [userdefault synchronize];
                                                               
                                                               [self showEmailSentAlert:emailString];
                                                           });
                                                           
                                                           
                                                       } onError:^(NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed sending Email"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           });
                                                           
                                                       }];
                                                       
                                                   } onError:^(NSError *error) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                           if (error.code == 1001) {
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Customer Name is required"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           }else {
                                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed"];
                                                               [self presentViewController:alert animated:true completion:nil];
                                                           }
                                                       });
                                                       
                                                       
                                                   }];
            
            
        }
        
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name:";
    }];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email:";
    }];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = true;
    [self presentViewController:alertController animated:true completion: nil];
    
}

-(void) showEmailSentAlert:(NSString*) email{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString* messageString = [NSString stringWithFormat:@"Your choice has been sent to %@", email];
    
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"Email Sent" message:messageString];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Back" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self.navigationController popToViewController: self.navigationController.viewControllers[1] animated:NO];
        [[IAQDataModel sharedIAQDataModel] resetAllData];
    }]];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:true completion: nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

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
    if ([selectedProductArray count] == 0){
        return 0;
    }else{
        return [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    IAQProductModel * iaqModel = [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray[indexPath.row];
    
    NSString * serviceString;
    if ([iaqModel.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",iaqModel.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:iaqModel.title];
    
    if (![selectedProductArray containsObject:iaqModel]){
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
        cell.textLabel.attributedText = attrText;
        
        
    }else{
        if (cell.textLabel.attributedText){
            cell.textLabel.attributedText = nil;
        }
        cell.textLabel.text = nameString;
    }
    
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.textColor     = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}
- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithInt:number]];
}

@end
