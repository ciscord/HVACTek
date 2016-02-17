//
//  RRFinalChoiceVC.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RRFinalChoiceVC.h"
#import "CustomerChoiceVC.h"
#import "ServiceOptionVC.h"
#import "NSMutableAttributedString+Color.h"

@interface RRFinalChoiceVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *contentRoundView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *initialTechTextField;
@property (weak, nonatomic) IBOutlet UIView *customerPriceView;
@property (weak, nonatomic) IBOutlet UITextField *initialCostumerTextField;
@property (weak, nonatomic) IBOutlet UIButton *invoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *rvsrBtn;
@property (weak, nonatomic) IBOutlet UIButton *optionsBtn;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet RoundCornerView *hideRoundView;

@end

@implementation RRFinalChoiceVC



#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    [self configureVC];
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.initialTechTextField.layer.borderWidth   = .5;
    self.initialTechTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.initialTechTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.initialTechTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.initialCostumerTextField.layer.borderWidth   = .5;
    self.initialCostumerTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.initialCostumerTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.initialCostumerTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.customerPriceView.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    self.hideBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.invoiceBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.optionsBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.currencyBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.rvsrBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label2.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.hideRoundView.layer.borderWidth   = 3.0;
    self.hideRoundView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
}


- (void)configureVC {
    self.title = @"Customer's Choice";

  NSString * initialText = [NSString stringWithFormat:@"Over the next 5 years it looks like you are going to be spending approximately %@ on your current system. Do you think it makes sense to look at investing that money into a new system, or would you just like me to start the repair?", self.totalInvestment];
//    self.descriptionLabel.text = [NSString stringWithFormat:@"Over the next 5 years it looks like you are going to be spending approximately %@ on your current system. Do you think it makes sense to look at investing that money into a new system, or would you just like me to start the repair?", self.totalInvestment];
  
  NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:initialText];
  [atrString setColorForText:self.totalInvestment withColor:[UIColor redColor]];
  self.descriptionLabel.attributedText = atrString;
  
    [self.view bringSubviewToFront:self.customerPriceView];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    job.totalInvestmentsRR = self.totalInvestment;
    [job.managedObjectContext save];
}


#pragma mark - Button Actions
- (IBAction)optionsBtnClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isInstantRRFinal"];
    [self performSegueWithIdentifier:@"unwindToServiceOptionsFromOptionsBtn" sender:self];
}


- (IBAction)rrBtnClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isInstantRRFinal"];
    [self performSegueWithIdentifier:@"unwindToServiceOptionsFromRRBtn" sender:self];
}


- (IBAction)invoiceBtnClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:@"unwindToServiceOptionsFromInvoiceBtn" sender:self];
}


#pragma mark - Customer Price Actions
- (IBAction)customerPriceBtnClicked:(UIButton *)sender {
    self.customerPriceView.hidden = NO;
}

- (IBAction)hideCustomerPriceView:(id)sender {
    self.customerPriceView.hidden = YES;
}



#pragma mark - TextField
- (void)textFieldDidEndEditing:(UITextField *)textField {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];

    if (textField == self.initialTechTextField) {
        job.initialTechRR = self.initialTechTextField.text;
        [job.managedObjectContext save];
    }else if (textField == self.initialCostumerTextField) {
        job.initialCostumerRR = self.initialCostumerTextField.text;
        [job.managedObjectContext save];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[CustomerChoiceVC class]]) {
        CustomerChoiceVC *vc = [segue destinationViewController];
 //       vc.fullServiceOptions = self.options.firstObject[@"items"];
        vc.isDiscounted       = NO;
        vc.isOnlyDiagnostic   = NO;
        NSDictionary *d = @{};
        vc.selectedServiceOptions = d;
    }
}



@end
