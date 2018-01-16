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
    NSString* customerName;
    NSString* iaqProductString;
}
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic) IBOutlet UIView *topBannerView;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;

@end

@implementation HealthyHomeSolutionsAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    self.topBannerView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [self.circleButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    self.circleButton.layer.cornerRadius = self.circleButton.bounds.size.width/2;
    self.circleButton.clipsToBounds = true;
    
    self.descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.signatureView.layer.borderWidth   = 1.0;
    self.signatureView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.signatureView.backgroundColor   = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.signatureView.foregroundLineColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    if (self.iaqType == BEST) {
        [self.circleButton setTitle:@"Best" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBestProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].bestTotalPrice;
    }else if (self.iaqType == BETTER) {
        [self.circleButton setTitle:@"Better" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].betterTotalPrice;
    }else if (self.iaqType == GOOD) {
        [self.circleButton setTitle:@"Good" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray;
        totalCost = [IAQDataModel sharedIAQDataModel].goodTotalPrice;
    }
    
    iaqProductString = @"";
    for (IAQProductModel* iaqProduct in selectedProductArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
        
    }
    
    customerName = [IAQDataModel sharedIAQDataModel].heatingStaticPressure.customerName;
    if (self.fromAddCart2) {
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        iaqProductString = [userdefault objectForKey:@"iaqProduct"];
        customerName = [userdefault objectForKey:@"customerName"];
        totalCost = [[userdefault objectForKey:@"totalCost"] floatValue];
        NSString *signature = [userdefault objectForKey:@"signature"];
        if (signature != nil) {
            NSData* imageData = [[NSData alloc] initWithBase64EncodedString:signature options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* signatureImage = [UIImage imageWithData:imageData];
            [self.signatureView setImage:signatureImage];
        }
        
        
    }
    self.descriptionLabel.text = iaqProductString;
    
    if (self.costType == SAVING) {
        [self.priceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (totalCost < 1000) {
            [self.priceButton setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
        }else{
            totalCost = totalCost * 0.85;
            [self.priceButton setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
        }
        
    }else{
        [self.priceButton setTitleColor:[UIColor hx_colorWithHexString:@"C42E3C"] forState:UIControlStateNormal];
        [self.priceButton setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
    }
    
    self.authorizeButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.emailButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
}
- (IBAction)authorizeSignatureClearClicked:(id)sender {
    [self.signatureView clear];
}
-(IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* emailField = [alertView.textFieldArray objectAtIndex:0];
        
        if (![emailField.text isValidEmail]) {
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
            
            [[DataLoader sharedInstance] addIaqAuthorizeSale:iaqProductStringFormatted
                                                    customer:customerName
                                                  technician:technicanName
                                                       price:totalCost
                                                   signature:signature
                                                   onSuccess:^(NSDictionary *dataDictionary) {
                                                       
                                                       authid = [dataDictionary objectForKey:@"id"];
                                                       
                                                       [[DataLoader sharedInstance] emailIaqAuthorizeSale:authid email:emailField.text onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                                                               [userdefault setObject:iaqProductString forKey:@"iaqProduct"];
                                                               [userdefault setObject:iaqProductStringFormatted forKey:@"iaqProductStringFormatted"];
                                                               [userdefault setObject:customerName forKey:@"customerName"];
                                                               [userdefault setObject:[NSNumber numberWithFloat:totalCost] forKey:@"totalCost"];
                                                               [userdefault setObject:signature forKey:@"signature"];
                                                               [userdefault synchronize];
                                                               
                                                               [self showEmailSentAlert:emailField.text];
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
        textField.placeholder = @"Email:";
    }];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:true completion: nil];
    
    
}

-(IBAction)emailClick:(id)sender {
    
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    __weak typeof (self) weakSelf = self;
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* emailField = [alertView.textFieldArray objectAtIndex:0];
        
        if (![emailField.text isValidEmail]) {
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
                                                    customer:customerName
                                                  technician:technicanName
                                                       price:totalCost
                                                   onSuccess:^(NSDictionary *dataDictionary) {
                                                       
                                                       authid = [dataDictionary objectForKey:@"id"];
                                                       
                                                       [[DataLoader sharedInstance] emailIaqAuthorizeSale:authid email:emailField.text onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
                                                               [userdefault setObject:iaqProductString forKey:@"iaqProduct"];
                                                               [userdefault setObject:iaqProductStringFormatted forKey:@"iaqProductStringFormatted"];
                                                               [userdefault setObject:customerName forKey:@"customerName"];
                                                               [userdefault setObject:[NSNumber numberWithFloat:totalCost] forKey:@"totalCost"];
                                                               [userdefault synchronize];
                                                               
                                                               [self showEmailSentAlert:emailField.text];
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
        textField.placeholder = @"Email:";
    }];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
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
        [IAQDataModel sharedIAQDataModel].isfinal = 0;
    }]];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:true completion: nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
