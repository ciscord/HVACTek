//
//  HealthyHomeProcessVC.m
//  HvacTek
//
//  Created by Max on 11/8/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeProcessVC.h"

@interface HealthyHomeProcessVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UILabel *technicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerDetailLabel;


@end

@implementation HealthyHomeProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureColorScheme];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {

    self.layer1View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    
    self.technicalLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.customerLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.technicalDetailLabel.textColor = [UIColor blackColor];
    self.customerDetailLabel.textColor = [UIColor blackColor];
    
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
