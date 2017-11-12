//
//  IsYourHomeHealthyVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "IsYourHomeHealthyVC.h"
#import "SVSegmentedControl.h"
@interface IsYourHomeHealthyVC ()
@property (strong, nonatomic)  SVSegmentedControl *purificationSegment;
@property (strong, nonatomic)  SVSegmentedControl *humidificationSegment;
@property (strong, nonatomic)  SVSegmentedControl *filtrationSegment;
@property (strong, nonatomic)  SVSegmentedControl *dehumidificationSegment;
@property (weak, nonatomic) IBOutlet UIView *myhomeCircleView;
@property (weak, nonatomic) IBOutlet UILabel *myhomePointLabel;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@end

@implementation IsYourHomeHealthyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    self.purificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
    };
    
    self.humidificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
    };
    
    self.filtrationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
    };
    
    self.dehumidificationSegment.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
    };
    
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
