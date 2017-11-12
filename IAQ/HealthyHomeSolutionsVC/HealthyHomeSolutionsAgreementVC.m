//
//  HealthyHomeSolutionsAgreementVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsAgreementVC.h"

@interface HealthyHomeSolutionsAgreementVC ()
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
    self.topBannerView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.circleButton setTitle:@"Good" forState:UIControlStateNormal];
    self.circleButton.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.circleButton.layer.cornerRadius = self.circleButton.bounds.size.width/2;
    self.circleButton.clipsToBounds = true;
    
    self.descriptionLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    if (self.mode == 0) {
        self.priceButton.titleLabel.textColor = [UIColor blackColor];
    }else{
        self.priceButton.titleLabel.textColor = [UIColor hx_colorWithHexString:@"C42E3C"];
    }
    
}

-(IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)authorizeClick:(id)sender {
    
}

-(IBAction)emailClick:(id)sender {
    
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
