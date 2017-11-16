//
//  HealthyHomeSolutionsDetailVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsDetailVC.h"
#import "HealthyAgreementTableViewCell.h"
@interface HealthyHomeSolutionsDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UIView *topBannerView;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (strong, nonatomic) IBOutlet UITableView *dataTableView;


@end

@implementation HealthyHomeSolutionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    self.topBannerView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.circleButton setTitle:@"Good" forState:UIControlStateNormal];
    [self.circleButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    self.circleButton.layer.cornerRadius = self.circleButton.bounds.size.width/2;
    self.circleButton.clipsToBounds = true;
    
    [self.dataTableView reloadData];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HealthyAgreementTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"agreementcell" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
    
}


@end
