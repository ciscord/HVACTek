//
//  HereWhatWeProposeVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HereWhatWeProposeVC.h"
#import "IAQCustomerChoiceVC.h"
#import "VideoForCustomerVC.h"
#import "IAQDataModel.h"
@interface HereWhatWeProposeVC ()
@property (weak, nonatomic) IBOutlet UIView *myhomeCircleView;
@property (weak, nonatomic) IBOutlet UILabel *myhomePointLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@end

@implementation HereWhatWeProposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Here's What We Propose";
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    self.myhomeCircleView.backgroundColor = [UIColor hx_colorWithHexString:@"#ffcc00" alpha:1];
    self.myhomePointLabel.text = [NSString stringWithFormat:@"%d", [IAQDataModel sharedIAQDataModel].calculatedScore];
    
    self.myhomeCircleView.backgroundColor = [UIColor hx_colorWithHexString:@"#99ccff" alpha:1];
    if ([IAQDataModel sharedIAQDataModel].calculatedScore <= 50) {
        self.homeImageView.image = [UIImage imageNamed:@"sad"];
        self.scoreLabel.text = @"POOR";
    }else if ([IAQDataModel sharedIAQDataModel].calculatedScore < 70) {
        self.homeImageView.image = [UIImage imageNamed:@"ok"];
        self.scoreLabel.text = @"FAIR";
    }else if ([IAQDataModel sharedIAQDataModel].calculatedScore < 85) {
        self.homeImageView.image = [UIImage imageNamed:@"happy"];
        self.scoreLabel.text = @"GOOD";
    }else if ([IAQDataModel sharedIAQDataModel].calculatedScore <= 100) {
        self.homeImageView.image = [UIImage imageNamed:@"best"];
        self.scoreLabel.text = @"BEST";
        
        self.myhomeCircleView.backgroundColor = [UIColor hx_colorWithHexString:@"#ffcc00" alpha:1];
    }
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark IBAction button
- (IBAction)nextButtonClick:(id)sender {
    int viewsToPop = 2;//go to cutomer's choice screen
    [self.navigationController popToViewController: self.navigationController.viewControllers[self.navigationController.viewControllers.count-viewsToPop-1] animated:NO];
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        
    [userdefault setObject:[NSNumber numberWithInt:1] forKey:@"isfinal"];
    [userdefault setObject:[NSNumber numberWithInteger:IAQCustomerChoiceFinal]  forKey:@"iaqCurrentStep"];
    [userdefault synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation




@end
