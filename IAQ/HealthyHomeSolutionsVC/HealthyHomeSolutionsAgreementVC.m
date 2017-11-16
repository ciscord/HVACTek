//
//  HealthyHomeSolutionsAgreementVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsAgreementVC.h"
#import "TYAlertController.h"
@interface HealthyHomeSolutionsAgreementVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UIView *topBannerView;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation HealthyHomeSolutionsAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    self.topBannerView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.circleButton setTitle:@"Good" forState:UIControlStateNormal];
    [self.circleButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    self.circleButton.layer.cornerRadius = self.circleButton.bounds.size.width/2;
    self.circleButton.clipsToBounds = true;
    
    self.descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    if (self.mode == 0) {
        self.priceButton.titleLabel.textColor = [UIColor blackColor];
    }else{
        self.priceButton.titleLabel.textColor = [UIColor hx_colorWithHexString:@"C42E3C"];
    }
    
    self.authorizeButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.emailButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
}

-(IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)authorizeClick:(id)sender {
    
}

-(IBAction)emailClick:(id)sender {
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"Continue" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField* emailField = [alertView.textFieldArray objectAtIndex:0];
        
        if (![emailField.text isValidEmail]) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Invalid Email"];
            [self presentViewController:alert animated:true completion:nil];
        }
        
        [self showEmailSentAlert:emailField.text];
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
