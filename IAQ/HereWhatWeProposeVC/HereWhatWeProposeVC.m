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
