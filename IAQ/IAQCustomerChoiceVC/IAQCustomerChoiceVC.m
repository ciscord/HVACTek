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
@interface IAQCustomerChoiceVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
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
    }
    
    for (UIButton* detailButton in self.detailButtonArray) {
        detailButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    }
    
    for (UIButton* bigButton in self.bigButtonArray) {
        bigButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    }
    
    if (self.mode == 1) {
        self.lbTitle.text = @"Healthy Home Solutions";
        
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
        self.lbTitle.text = @"Customer's Choice";
        
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
}
- (IBAction)priceClick:(id)sender {
    
    HealthyHomeSolutionsAgreementVC* healthyHomeSolutionsAgreementVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsAgreementVC"];
    
    [self.navigationController pushViewController:healthyHomeSolutionsAgreementVC animated:true];
}
- (IBAction)detailsClick:(id)sender {
    
    HealthyHomeSolutionsDetailVC* healthyHomeSolutionsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsDetailVC"];
    
    [self.navigationController pushViewController:healthyHomeSolutionsDetailVC animated:true];
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
