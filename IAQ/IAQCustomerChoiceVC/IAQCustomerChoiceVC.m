//
//  IAQCustomerChoiceVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "IAQCustomerChoiceVC.h"
#import "HealthyHomeSolutionsAgreementVC.h"
#import "HealthyHomeSolutionsDetailVC.h"
#import "IAQDataModel.h"
#import "IAQEditServiceOptionsVC.h"
#import "IsYourHomeHealthyVC.h"
@interface IAQCustomerChoiceVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UILabel *bestChoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *betterChoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodChoiceLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *detailButtonArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtonArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *descriptionLabelArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bigButtonArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *priceViewArray;

@property (weak, nonatomic) IBOutlet UIButton *bestFirstPrice;
@property (weak, nonatomic) IBOutlet UIButton *bestSecondPrice;
@property (weak, nonatomic) IBOutlet UIButton *betterFirstPrice;
@property (weak, nonatomic) IBOutlet UIButton *betterSecondPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodFirstPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodSecondPrice;

@property (weak, nonatomic) IBOutlet UILabel *bestFinancingLabel;
@property (weak, nonatomic) IBOutlet UILabel *betterFinancingLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodFinancingLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestEqual24Label;
@property (weak, nonatomic) IBOutlet UILabel *betterEqual24Label;
@property (weak, nonatomic) IBOutlet UILabel *goodEqual24Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelHeightConstraint;

@end

@implementation IAQCustomerChoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UILabel* descriptionLabel in self.descriptionLabelArray) {
        descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    }
    
    for (UIButton* optionButton in self.optionButtonArray) {
        optionButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        [optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton* detailButton in self.detailButtonArray) {
        detailButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    }
    
    for (UIButton* bigButton in self.bigButtonArray) {
        bigButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        bigButton.userInteractionEnabled = false;
    }
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQHealthyHomeSolutionSort) {
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        
        [IAQDataModel sharedIAQDataModel].iaqBestProductsIdArray = [userdefault objectForKey:@"iaqBestProductsIdArray"];
        [IAQDataModel sharedIAQDataModel].iaqBetterProductsIdArray = [userdefault objectForKey:@"iaqBetterProductsIdArray"];
        [IAQDataModel sharedIAQDataModel].iaqGoodProductsIdArray = [userdefault objectForKey:@"iaqGoodProductsIdArray"];
        
        //load products
        for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray) {
            
            //best
            if ([[IAQDataModel sharedIAQDataModel].iaqBestProductsIdArray containsObject:iaqModel.productId]) {
                [[IAQDataModel sharedIAQDataModel].iaqBestProductsArray addObject:iaqModel];
            }
            
            //better
            if ([[IAQDataModel sharedIAQDataModel].iaqBetterProductsIdArray containsObject:iaqModel.productId]) {
                [[IAQDataModel sharedIAQDataModel].iaqBetterProductsArray addObject:iaqModel];
            }
            
            //good
            if ([[IAQDataModel sharedIAQDataModel].iaqGoodProductsIdArray containsObject:iaqModel.productId]) {
                [[IAQDataModel sharedIAQDataModel].iaqGoodProductsArray addObject:iaqModel];
            }
        }
        
    }else{
        [IAQDataModel sharedIAQDataModel].iaqBestProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
        [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
        [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
    }
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void) reloadData {
    
    if ([IAQDataModel sharedIAQDataModel].isfinal == 1) {
        self.title = @"Healthy Home Solutions";
        
        for (UIButton* priceView in self.priceViewArray) {
            priceView.hidden = false;
        }
        for (UIButton* optionButton in self.optionButtonArray) {
            optionButton.hidden = true;
        }
        for (UIButton* detailButton in self.detailButtonArray) {
            detailButton.hidden = false;
        }
        self.topLabelHeightConstraint.constant = 44;
        
        self.nextButton.hidden = true;
    }else {
        self.title = @"Customer's Choice";
        
        for (UIButton* priceView in self.priceViewArray) {
            priceView.hidden = true;
        }
        for (UIButton* optionButton in self.optionButtonArray) {
            optionButton.hidden = false;
        }
        for (UIButton* detailButton in self.detailButtonArray) {
            detailButton.hidden = true;
        }
        self.topLabelHeightConstraint.constant = 0;
    }
    
    //calculate best price
    NSString* iaqProductString = @"";
    float totalCost = 0;
    
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqBestProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
        totalCost += [iaqProduct.price floatValue] * [iaqProduct.quantity intValue];
    }
    
    [IAQDataModel sharedIAQDataModel].bestTotalPrice = totalCost;
    self.bestChoiceLabel.text = iaqProductString;
    [self.bestFirstPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.bestSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost * 0.85] forState:UIControlStateNormal];
        self.bestFinancingLabel.text = @"0% Financing";
        self.bestEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%.2f", totalCost / 24];
    }else{
        [self.bestSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
        self.bestFinancingLabel.text = @"Does Not Qualify";
        self.bestEqual24Label.text = @"For 0% Financing";
    }
    
    //calculate better price
    iaqProductString = @"";
    totalCost = 0;
    
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
        totalCost += [iaqProduct.price floatValue] * [iaqProduct.quantity intValue];
    }
    
    [IAQDataModel sharedIAQDataModel].betterTotalPrice = totalCost;
    self.betterChoiceLabel.text = iaqProductString;
    [self.betterFirstPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.betterSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost * 0.85] forState:UIControlStateNormal];
        self.betterFinancingLabel.text = @"0% Financing";
        self.betterEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%.2f", totalCost / 24];
    }else{
        [self.betterSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
        self.betterFinancingLabel.text = @"Does Not Qualify";
        self.betterEqual24Label.text = @"For 0% Financing";
    }
    
    //calculate good price
    iaqProductString = @"";
    totalCost = 0;
    
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
        totalCost += [iaqProduct.price floatValue] * [iaqProduct.quantity intValue];
    }
    
    [IAQDataModel sharedIAQDataModel].goodTotalPrice = totalCost;
    self.goodChoiceLabel.text = iaqProductString;
    [self.goodFirstPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.goodSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost * 0.85] forState:UIControlStateNormal];
        self.goodFinancingLabel.text = @"0% Financing";
        self.goodEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%.2f", totalCost / 24];
    }else{
        [self.goodSecondPrice setTitle:[NSString stringWithFormat:@"$%.2f", totalCost] forState:UIControlStateNormal];
        self.goodFinancingLabel.text = @"Does Not Qualify";
        self.goodEqual24Label.text = @"For 0% Financing";
    }
}
#pragma mark Button event
- (IBAction)priceClick:(id)sender {
    UIButton* priceButton = (UIButton*) sender;
    HealthyHomeSolutionsAgreementVC* healthyHomeSolutionsAgreementVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsAgreementVC"];
    switch (priceButton.tag) {
        case 0:
            healthyHomeSolutionsAgreementVC.iaqType = BEST;
            healthyHomeSolutionsAgreementVC.costType = ORIGIN;
            break;
        case 1:
            healthyHomeSolutionsAgreementVC.iaqType = BEST;
            healthyHomeSolutionsAgreementVC.costType = SAVING;
            break;
        case 2:
            healthyHomeSolutionsAgreementVC.iaqType = BETTER;
            healthyHomeSolutionsAgreementVC.costType = ORIGIN;
            break;
        case 3:
            healthyHomeSolutionsAgreementVC.iaqType = BETTER;
            healthyHomeSolutionsAgreementVC.costType = SAVING;
            break;
        case 4:
            healthyHomeSolutionsAgreementVC.iaqType = GOOD;
            healthyHomeSolutionsAgreementVC.costType = ORIGIN;
            break;
        case 5:
            healthyHomeSolutionsAgreementVC.iaqType = GOOD;
            healthyHomeSolutionsAgreementVC.costType = SAVING;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:healthyHomeSolutionsAgreementVC animated:true];
}
- (IBAction)detailsClick:(id)sender {
    UIButton* detailButton = (UIButton*) sender;
    HealthyHomeSolutionsDetailVC* healthyHomeSolutionsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsDetailVC"];
    
    switch (detailButton.tag) {
        case 0:
            healthyHomeSolutionsDetailVC.iaqType = BEST;
            break;
        case 1:
            healthyHomeSolutionsDetailVC.iaqType = BETTER;
            break;
        case 2:
            healthyHomeSolutionsDetailVC.iaqType = GOOD;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:healthyHomeSolutionsDetailVC animated:true];
}
-(IBAction)nextButtonClick:(id)sender {
    IsYourHomeHealthyVC* isYourHomeHealthyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IsYourHomeHealthyVC"];
    [self.navigationController pushViewController:isYourHomeHealthyVC animated:true];
}
-(IBAction)optionButtonClick:(id)sender {

    UIButton* button = (UIButton*) sender;
    IAQEditServiceOptionsVC* iaqEditServiceOptionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IAQEditServiceOptionsVC"];
    iaqEditServiceOptionsVC.selectedIndex = button.tag;
    [self.navigationController pushViewController:iaqEditServiceOptionsVC animated:true];
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
