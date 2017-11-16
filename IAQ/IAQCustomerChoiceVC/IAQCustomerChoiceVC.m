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
    }
    
    if (self.mode == 1) {
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
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [IAQDataModel sharedIAQDataModel].iaqBestProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
    [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
    [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void) reloadData {
    NSString* iaqProductString = @"";
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqBestProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
    }
    self.bestChoiceLabel.text = iaqProductString;
    
    iaqProductString = @"";
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
    }
    self.betterChoiceLabel.text = iaqProductString;
    
    iaqProductString = @"";
    for (IAQProductModel* iaqProduct in [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray) {
        iaqProductString = [NSString stringWithFormat:@"%@\n%@", iaqProductString, iaqProduct.title];
    }
    self.goodChoiceLabel.text = iaqProductString;
}
#pragma mark Button event
- (IBAction)priceClick:(id)sender {
    
    HealthyHomeSolutionsAgreementVC* healthyHomeSolutionsAgreementVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsAgreementVC"];
    
    [self.navigationController pushViewController:healthyHomeSolutionsAgreementVC animated:true];
}
- (IBAction)detailsClick:(id)sender {
    
    HealthyHomeSolutionsDetailVC* healthyHomeSolutionsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsDetailVC"];
    
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
