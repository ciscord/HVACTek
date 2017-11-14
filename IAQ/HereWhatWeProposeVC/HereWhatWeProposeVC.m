//
//  HereWhatWeProposeVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HereWhatWeProposeVC.h"
#import "IAQCustomerChoiceVC.h"
@interface HereWhatWeProposeVC ()
@property (weak, nonatomic) IBOutlet UIView *myhomeCircleView;
@property (weak, nonatomic) IBOutlet UILabel *myhomePointLabel;
@end

@implementation HereWhatWeProposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.myhomeCircleView.bounds;
    gradient.colors = @[(id)[UIColor hx_colorWithHexString:@"#FDF462"].CGColor, (id)[UIColor hx_colorWithHexString:@"#F6CA47"].CGColor];
    
    [self.myhomeCircleView.layer insertSublayer:gradient atIndex:0];
}

#pragma mark IBAction button
- (IBAction)nextClick:(id)sender {
    
    IAQCustomerChoiceVC* iaqCustomerChoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IAQCustomerChoiceVC"];
    iaqCustomerChoiceVC.mode = 1;
    [self.navigationController pushViewController:iaqCustomerChoiceVC animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation




@end
