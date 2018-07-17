//
//  EnlargeOptionsVC.m
//  Signature
//
//  Created by Dorin on 8/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "EnlargeOptionsVC.h"
#import "SummaryOfFindingsOptionsVC.h"
@interface EnlargeOptionsVC ()

@property (weak, nonatomic) IBOutlet UITableView *enlargeTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *ESAPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPaymentsLbl;
@property (weak, nonatomic) IBOutlet UILabel *savingESALbl;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *midleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView1;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;
@property (weak, nonatomic) IBOutlet UIView *separatorView3;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation EnlargeOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Customer's Choice", nil);
    
    [self configureColorScheme];
    
    self.optionNameLabel.text = self.enlargeOptionName;
    self.totalPriceLbl.text = self.enlargeTotalPrice;
    self.ESAPriceLbl.text = self.enlargeESAPrice;
    self.monthlyPaymentsLbl.text = self.enlargeMonthlyPrice;
    self.savingESALbl.text = self.enlargeSavings;
    self.midleLabel.text = self.enlargeMidleLabelString;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.separatorView1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView3.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.optionNameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.editButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (void)viewWasTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.enlargeOptionsArray count] == 0){
        return 0;
    }else{
        return [self.enlargeFullOptionsArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PricebookItem *p = self.enlargeFullOptionsArray[indexPath.row];
    
    NSString * serviceString;
    if ([p.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",p.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:p.name];
    
    if (![self.enlargeOptionsArray containsObject:p]){
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
        cell.textLabel.attributedText = attrText;
        
        
    }else{
        if (cell.textLabel.attributedText){
            cell.textLabel.attributedText = nil;
        }
        cell.textLabel.text = nameString;
    }
    
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.textColor     = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)tapEditButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSArray* viewcontrollers = self.parentVC.navigationController.viewControllers;
        [[TechDataModel sharedTechDataModel] saveCurrentStep:SummaryOfFindingsOptions1];
        for (UIViewController* viewController in viewcontrollers) {
            if ([viewController isKindOfClass:[SummaryOfFindingsOptionsVC class]]) {
                SummaryOfFindingsOptionsVC* sumaryOfFindingsOptionsVC = (SummaryOfFindingsOptionsVC*) viewController;
                [TechDataModel sharedTechDataModel].currentStep = SummaryOfFindingsOptions1;
                sumaryOfFindingsOptionsVC.isiPadCommonRepairsOptions = YES;
                
                [self.parentVC.navigationController popToViewController:viewController animated:NO];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
        UIViewController* currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC1"];
        SummaryOfFindingsOptionsVC* sumaryOfFindingsOptionsVC = (SummaryOfFindingsOptionsVC*) currentViewController;
        [TechDataModel sharedTechDataModel].currentStep = SummaryOfFindingsOptions1;
        sumaryOfFindingsOptionsVC.isiPadCommonRepairsOptions = YES;
        
        [self.parentVC.navigationController pushViewController:sumaryOfFindingsOptionsVC animated:NO];
    }];
}

@end
