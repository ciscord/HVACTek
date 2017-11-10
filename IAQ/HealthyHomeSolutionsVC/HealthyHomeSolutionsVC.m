//
//  ServiceOptionsVC.m
//  HvacTek
//
//  Created by Max on 11/11/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsVC.h"
#import "CHDropDownTextField.h"
#import "CHDropDownTextFieldTableViewCell.h"
@interface HealthyHomeSolutionsVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *optionLabelArray;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *borderFieldArray;

@end

@implementation HealthyHomeSolutionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (UILabel* backlabel in self.optionLabelArray) {
        backlabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    }
    
    for (UITextField* iborderfield in self.borderFieldArray) {
        iborderfield.clipsToBounds = true;
        iborderfield.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        iborderfield.layer.borderWidth = 1;
        
    }
    
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
