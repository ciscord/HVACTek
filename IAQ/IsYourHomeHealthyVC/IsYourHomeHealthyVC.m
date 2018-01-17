//
//  IsYourHomeHealthyVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "IsYourHomeHealthyVC.h"
#import "SVSegmentedControl.h"
#import "IAQDataModel.h"
#import "BreatheEasyHealthyHomeVC.h"
#import "HereWhatWeProposeVC.h"
@interface IsYourHomeHealthyVC ()

@property (strong, nonatomic)  SVSegmentedControl *purificationSegment;
@property (strong, nonatomic)  SVSegmentedControl *humidificationSegment;
@property (strong, nonatomic)  SVSegmentedControl *filtrationSegment;
@property (strong, nonatomic)  SVSegmentedControl *dehumidificationSegment;
@property (weak, nonatomic) IBOutlet UIView *myhomeCircleView;
@property (weak, nonatomic) IBOutlet UILabel *myhomePointLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *plantImageView;
@end

@implementation IsYourHomeHealthyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Is Your Home Healthy?";
    // Do any additional setup after loading the view.
    self.baseView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    [self.baseView bringSubviewToFront:self.plantImageView];
    
    
    self.purificationSegment = [[SVSegmentedControl alloc] initWithSectionTitles: @[@"Good", @"Fair", @"Poor"]];
    self.purificationSegment.backgroundTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.purificationSegment.cornerRadius = 0;
    self.purificationSegment.frame = CGRectMake(120, 10, 200, 40);
    [self.segmentView addSubview:self.purificationSegment];
    
    self.humidificationSegment = [[SVSegmentedControl alloc] initWithSectionTitles: @[@"Good", @"Fair", @"Poor"]];
    self.humidificationSegment.backgroundTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.humidificationSegment.cornerRadius = 0;
    self.humidificationSegment.frame = CGRectMake(120, 69, 200, 40);
    [self.segmentView addSubview:self.humidificationSegment];
    
    self.filtrationSegment = [[SVSegmentedControl alloc] initWithSectionTitles: @[@"Good", @"Fair", @"Poor"]];
    self.filtrationSegment.backgroundTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.filtrationSegment.cornerRadius = 0;
    self.filtrationSegment.frame = CGRectMake(120, 128, 200, 40);
    [self.segmentView addSubview:self.filtrationSegment];
    
    self.dehumidificationSegment = [[SVSegmentedControl alloc] initWithSectionTitles: @[@"Good", @"Fair", @"Poor"]];
    self.dehumidificationSegment.backgroundTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.dehumidificationSegment.cornerRadius = 0;
    self.dehumidificationSegment.frame = CGRectMake(120, 187, 200, 40);
    [self.segmentView addSubview:self.dehumidificationSegment];
    
    __weak typeof(self) weakSelf = self;
    self.purificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
        [IAQDataModel sharedIAQDataModel].airPurification = (int)newIndex;
        [weakSelf reloadData];
    };
    
    self.humidificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
        [IAQDataModel sharedIAQDataModel].humidification = (int)newIndex;
        [weakSelf reloadData];
    };
    
    self.filtrationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
        [IAQDataModel sharedIAQDataModel].airFiltration = (int)newIndex;
        [weakSelf reloadData];
    };
    
    self.dehumidificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
        [IAQDataModel sharedIAQDataModel].dehumidification = (int)newIndex;
        [weakSelf reloadData];
    };
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQIsYourHomeHealthy) {
        
        [IAQDataModel sharedIAQDataModel].airPurification = [[userdefault objectForKey:@"airPurification"] intValue];
        [IAQDataModel sharedIAQDataModel].humidification = [[userdefault objectForKey:@"humidification"] intValue];
        [IAQDataModel sharedIAQDataModel].airFiltration = [[userdefault objectForKey:@"airFiltration"] intValue];
        [IAQDataModel sharedIAQDataModel].dehumidification = [[userdefault objectForKey:@"dehumidification"] intValue];
        
        //go to next screen
        if ([IAQDataModel sharedIAQDataModel].isfinal == 1) {
            HereWhatWeProposeVC* hereWhatWeProposeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HereWhatWeProposeVC"];
            [self.navigationController pushViewController:hereWhatWeProposeVC animated:true];
        }else {
            BreatheEasyHealthyHomeVC* breatheEasyHealthyHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BreatheEasyHealthyHomeVC"];
            [self.navigationController pushViewController:breatheEasyHealthyHomeVC animated:true];
        }
        
    }
    
    [self reloadData];
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillAppear:(BOOL)animated {
    if ([IAQDataModel sharedIAQDataModel].isfinal == 1) {
        self.purificationSegment.userInteractionEnabled = false;
        self.humidificationSegment.userInteractionEnabled = false;
        self.filtrationSegment.userInteractionEnabled = false;
        self.dehumidificationSegment.userInteractionEnabled = false;
    }
}
- (void) reloadData {
    [self.purificationSegment setSelectedSegmentIndex:[IAQDataModel sharedIAQDataModel].airPurification animated:false];
    [self.humidificationSegment setSelectedSegmentIndex:[IAQDataModel sharedIAQDataModel].humidification animated:false];
    [self.filtrationSegment setSelectedSegmentIndex:[IAQDataModel sharedIAQDataModel].airFiltration animated:false];
    [self.dehumidificationSegment setSelectedSegmentIndex:[IAQDataModel sharedIAQDataModel].dehumidification animated:false];
    
    int calculatedScore = 0;
    
    //calculate the score
    switch ([IAQDataModel sharedIAQDataModel].airPurification) {
        case 0:
            calculatedScore += 29;
            break;
        case 1:
            calculatedScore += 15;
            break;
        case 2:
            calculatedScore += 0;
            break;
    }
    
    switch ([IAQDataModel sharedIAQDataModel].humidification) {
        case 0:
            calculatedScore += 27;
            break;
        case 1:
            calculatedScore += 15;
            break;
        case 2:
            calculatedScore += 0;
            break;
    }
    
    switch ([IAQDataModel sharedIAQDataModel].airFiltration) {
        case 0:
            calculatedScore += 23;
            break;
        case 1:
            calculatedScore += 10;
            break;
        case 2:
            calculatedScore += 0;
            break;
    }
    
    switch ([IAQDataModel sharedIAQDataModel].dehumidification) {
        case 0:
            calculatedScore += 21;
            break;
        case 1:
            calculatedScore += 10;
            break;
        case 2:
            calculatedScore += 0;
            break;
    }
    [IAQDataModel sharedIAQDataModel].calculatedScore = calculatedScore;
    
    self.myhomePointLabel.text = [NSString stringWithFormat:@"%d", calculatedScore];
    
    self.myhomeCircleView.backgroundColor = [UIColor hx_colorWithHexString:@"#99ccff" alpha:1];
    if (calculatedScore <= 50) {
        self.homeImageView.image = [UIImage imageNamed:@"sad"];
        self.scoreLabel.text = @"POOR";
    }else if (calculatedScore < 70) {
        self.homeImageView.image = [UIImage imageNamed:@"ok"];
        self.scoreLabel.text = @"FAIR";
    }else if (calculatedScore < 85) {
        self.homeImageView.image = [UIImage imageNamed:@"happy"];
        self.scoreLabel.text = @"GOOD";
    }else if (calculatedScore <= 100) {
        self.homeImageView.image = [UIImage imageNamed:@"best"];
        self.scoreLabel.text = @"BEST";

        self.myhomeCircleView.backgroundColor = [UIColor hx_colorWithHexString:@"#ffcc00" alpha:1];
    }
}

#pragma mark Button event
-(IBAction)nextButtonClick:(id)sender {
    if ([IAQDataModel sharedIAQDataModel].currentStep == IAQNone) {
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        
        [userdefault setObject:[NSNumber numberWithInt:[IAQDataModel sharedIAQDataModel].airPurification] forKey:@"airPurification"];
        [userdefault setObject:[NSNumber numberWithInt:[IAQDataModel sharedIAQDataModel].humidification] forKey:@"humidification"];
        [userdefault setObject:[NSNumber numberWithInt:[IAQDataModel sharedIAQDataModel].airFiltration] forKey:@"airFiltration"];
        [userdefault setObject:[NSNumber numberWithInt:[IAQDataModel sharedIAQDataModel].dehumidification] forKey:@"dehumidification"];
        
        if ([IAQDataModel sharedIAQDataModel].isfinal == 0) {
            [userdefault setObject:[NSNumber numberWithInteger:IAQIsYourHomeHealthy]  forKey:@"iaqCurrentStep"];
        }else {
            [userdefault setObject:[NSNumber numberWithInteger:IAQIsYourHomeHealthyFinal]  forKey:@"iaqCurrentStep"];
        }
    
        [userdefault synchronize];
    }
    if ([IAQDataModel sharedIAQDataModel].isfinal == 1) {
        HereWhatWeProposeVC* hereWhatWeProposeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HereWhatWeProposeVC"];
        [self.navigationController pushViewController:hereWhatWeProposeVC animated:true];
    }else {
        BreatheEasyHealthyHomeVC* breatheEasyHealthyHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BreatheEasyHealthyHomeVC"];
        [self.navigationController pushViewController:breatheEasyHealthyHomeVC animated:true];
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
