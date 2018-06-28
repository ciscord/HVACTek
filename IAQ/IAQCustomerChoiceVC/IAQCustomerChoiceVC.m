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
#import "BreatheEasyHealthyHomeVC.h"

#import "MediaLibraryVC.h"

@interface IAQCustomerChoiceVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UITextView *bestChoiceLabel;
@property (weak, nonatomic) IBOutlet UITextView *betterChoiceLabel;
@property (weak, nonatomic) IBOutlet UITextView *goodChoiceLabel;

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
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
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
    }
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    self.libraryButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQCustomerChoice) {
        [IAQDataModel sharedIAQDataModel].iaqBestProductsArray = [NSMutableArray array];
        [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray = [NSMutableArray array];
        [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray = [NSMutableArray array];
           
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
        
        if ([IAQDataModel sharedIAQDataModel].currentStep == IAQCustomerChoiceFinal) {
            [IAQDataModel sharedIAQDataModel].isfinal = [[userdefault objectForKey:@"isfinal"] intValue];
            
        }else {
            //go to next screen
            BreatheEasyHealthyHomeVC* breatheEasyHealthyHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BreatheEasyHealthyHomeVC"];
            [self.navigationController pushViewController:breatheEasyHealthyHomeVC animated:true];
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
    
    //calculate best price ------------------
    
    float totalCost = 0;
    
    UIFont *text2Font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    NSMutableAttributedString *attributedString1 =
    [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName : text2Font }];
    
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray) {
        
        if ([[IAQDataModel sharedIAQDataModel].iaqBestProductsArray containsObject:iaqModel]) {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font }];
            [attributedString1 appendAttributedString:attributedString2];
            
            totalCost += [iaqModel.price floatValue] * [iaqModel.quantity intValue];
        }else {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font, NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] }];
            [attributedString1 appendAttributedString:attributedString2];
        }
        [attributedString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];

        
    }
    
    [IAQDataModel sharedIAQDataModel].bestTotalPrice = totalCost;
    self.bestChoiceLabel.attributedText = attributedString1;
    [self.bestFirstPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.bestSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)(totalCost * 0.85)] forState:UIControlStateNormal];
        self.bestFinancingLabel.text = @"0% Financing";
        self.bestEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%d", (int)(totalCost / 24)];
    }else{
        [self.bestSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
        self.bestFinancingLabel.text = @"0% Financing";
        self.bestEqual24Label.text = @"";
    }
    
    //calculate better price ----------------
    totalCost = 0;
    
    attributedString1 =
    [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName : text2Font }];
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray) {
        
        if ([[IAQDataModel sharedIAQDataModel].iaqBetterProductsArray containsObject:iaqModel]) {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font }];
            [attributedString1 appendAttributedString:attributedString2];
            
            totalCost += [iaqModel.price floatValue] * [iaqModel.quantity intValue];
        }else {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font, NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] }];
            [attributedString1 appendAttributedString:attributedString2];
        }
        [attributedString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
   
        
    }
    
    [IAQDataModel sharedIAQDataModel].betterTotalPrice = totalCost;
    self.betterChoiceLabel.attributedText = attributedString1;
    [self.betterFirstPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.betterSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)(totalCost * 0.85)] forState:UIControlStateNormal];
        self.betterFinancingLabel.text = @"0% Financing";
        self.betterEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%d", (int)(totalCost / 24)];
    }else{
        [self.betterSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
        self.betterFinancingLabel.text = @"0% Financing";
        self.betterEqual24Label.text = @"";
    }
    
    //calculate good price ----------------
    totalCost = 0;
    
    attributedString1 =
    [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName : text2Font }];
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray) {
        
        if ([[IAQDataModel sharedIAQDataModel].iaqGoodProductsArray containsObject:iaqModel]) {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font }];
            [attributedString1 appendAttributedString:attributedString2];
            
            totalCost += [iaqModel.price floatValue] * [iaqModel.quantity intValue];
        }else {
            
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:iaqModel.title attributes:@{NSFontAttributeName : text2Font, NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] }];
            [attributedString1 appendAttributedString:attributedString2];
        }
        [attributedString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        
        
    }
    
    [IAQDataModel sharedIAQDataModel].goodTotalPrice = totalCost;
    self.goodChoiceLabel.attributedText = attributedString1;
    [self.goodFirstPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
    
    if (totalCost >= 1000) {
        [self.goodSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)(totalCost * 0.85)] forState:UIControlStateNormal];
        self.goodFinancingLabel.text = @"0% Financing";
        self.goodEqual24Label.text = [NSString stringWithFormat:@"24 Equal Payments Of $%d", (int)(totalCost / 24)];
    }else{
        [self.goodSecondPrice setTitle:[NSString stringWithFormat:@"$%d", (int)totalCost] forState:UIControlStateNormal];
        self.goodFinancingLabel.text = @"0% Financing";
        self.goodEqual24Label.text = @"";
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
    BreatheEasyHealthyHomeVC* breatheEasyHealthyHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BreatheEasyHealthyHomeVC"];
    [self.navigationController pushViewController:breatheEasyHealthyHomeVC animated:true];
    
    [IAQDataModel sharedIAQDataModel].iaqBestProductsIdArray = [NSMutableArray array];
    [IAQDataModel sharedIAQDataModel].iaqBetterProductsIdArray = [NSMutableArray array];
    [IAQDataModel sharedIAQDataModel].iaqGoodProductsIdArray = [NSMutableArray array];
    
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqBestProductsArray) {
        [[IAQDataModel sharedIAQDataModel].iaqBestProductsIdArray addObject:iaqModel.productId];
    }
    
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray) {
        [[IAQDataModel sharedIAQDataModel].iaqBetterProductsIdArray addObject:iaqModel.productId];
    }
    
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray) {
        [[IAQDataModel sharedIAQDataModel].iaqGoodProductsIdArray addObject:iaqModel.productId];
    }
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:[IAQDataModel sharedIAQDataModel].iaqBestProductsIdArray forKey:@"iaqBestProductsIdArray"];
    [userdefault setObject:[IAQDataModel sharedIAQDataModel].iaqBetterProductsIdArray forKey:@"iaqBetterProductsIdArray"];
    [userdefault setObject:[IAQDataModel sharedIAQDataModel].iaqGoodProductsIdArray forKey:@"iaqGoodProductsIdArray"];
    
    [userdefault setObject:[NSNumber numberWithInteger:IAQBreatheEasyHealtyHome]  forKey:@"iaqCurrentStep"];
    [userdefault synchronize];

}
-(IBAction)optionButtonClick:(id)sender {

    UIButton* button = (UIButton*) sender;
    IAQEditServiceOptionsVC* iaqEditServiceOptionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IAQEditServiceOptionsVC"];
    iaqEditServiceOptionsVC.selectedIndex = button.tag;
    [self.navigationController pushViewController:iaqEditServiceOptionsVC animated:true];
}

- (IBAction)libraryButtonClick:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    
    MediaLibraryVC* mediaLibraryVC = [storyboard instantiateViewControllerWithIdentifier:@"MediaLibraryVC"];
    [self.navigationController pushViewController:mediaLibraryVC animated:true];
    
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
