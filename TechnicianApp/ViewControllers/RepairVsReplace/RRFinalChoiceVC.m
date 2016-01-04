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

@interface RRFinalChoiceVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *contentRoundView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *initialTechTextField;
@property (weak, nonatomic) IBOutlet UIView *customerPriceView;
@property (weak, nonatomic) IBOutlet UITextField *initialCostumerTextField;

@end

@implementation RRFinalChoiceVC



#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}


- (void)configureVC {
    self.title = @"Customer's Choice";
    self.descriptionLabel.text = [NSString stringWithFormat:@"Over the next 5 years it looks like you are going to be spending approximately %@ on your current system. Do you think it makes sense to look at investing that money into a new system, or would you just like me to start the repair?", self.totalInvestment];
    self.initialTechTextField.layer.borderWidth   = .5;
    self.initialTechTextField.layer.borderColor   = [[UIColor colorWithRed:118./255 green:189./255 blue:29./255 alpha:1.] CGColor];
    self.initialCostumerTextField.layer.borderWidth   = .5;
    self.initialCostumerTextField.layer.borderColor   = [[UIColor colorWithRed:118./255 green:189./255 blue:29./255 alpha:1.] CGColor];
    
    [self.view bringSubviewToFront:self.customerPriceView];
    self.customerPriceView.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    [DataLoader sharedInstance].totalInvestmentsRR = self.totalInvestment;
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
