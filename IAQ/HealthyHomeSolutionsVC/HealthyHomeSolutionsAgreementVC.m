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
    
    NSString* iaqProductString = @"";
    for (IAQProductModel* iaqProduct in selectedProductArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
        
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
    NSString* iaqProductString = @"";
    if (selectedProductArray.count >= 1) {
        IAQProductModel* iaqProduct = selectedProductArray[0];
        iaqProductString = [NSString stringWithFormat:@"%@", iaqProduct.title];
    }
    if (selectedProductArray.count > 1) {
        for (int i = 1; i < selectedProductArray.count; i++) {
            IAQProductModel* iaqProduct = selectedProductArray[i];
            iaqProductString = [NSString stringWithFormat:@"%@,%@", iaqProductString, iaqProduct.title];
        }
    }
    
    UIImage *image = [UIImage imageWithData:self.signatureView.signatureData];
    NSString *signature = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (signature == nil)  //signature was removed
        signature = @"";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    NSString* technicanName = [NSString stringWithFormat:@"%@ %@", [DataLoader sharedInstance].currentUser.firstName, [DataLoader sharedInstance].currentUser.lastName];
    
    [[DataLoader sharedInstance] addIaqAuthorizeSale:iaqProductString
                                            customer:[IAQDataModel sharedIAQDataModel].heatingStaticPressure.customerName
                                          technician:technicanName
                                               price:totalCost
                                           signature:signature
                                           onSuccess:^(NSDictionary *dataDictionary) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               authid = [dataDictionary objectForKey:@"id"];
                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Success"];
                                               [self presentViewController:alert animated:true completion:nil];
                                               
                                           } onError:^(NSError *error) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed"];
                                               [self presentViewController:alert animated:true completion:nil];
                                           }];
}

-(IBAction)emailClick:(id)sender {
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* emailField = [alertView.textFieldArray objectAtIndex:0];
        
        if (![emailField.text isValidEmail]) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Invalid Email"];
            [self presentViewController:alert animated:true completion:nil];
            
        }else {
            
            if (authid != nil) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                __weak typeof (self) weakSelf = self;
                
                [[DataLoader sharedInstance] emailIaqAuthorizeSale:authid email:emailField.text onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [self showEmailSentAlert:emailField.text];
                
            
                } onError:^(NSError *error) {
                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Failed sending Email"];
                    [self presentViewController:alert animated:true completion:nil];
                }];
            }else {
                //???
            }
        }
        
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email:";
    }];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:true completion: nil];
    
}

-(void) showEmailSentAlert:(NSString*) email{
    NSString* messageString = [NSString stringWithFormat:@"Your choice has been sent to %@", email];
    
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"Email Sent" message:messageString];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Back" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
    }]];
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:true completion: nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
