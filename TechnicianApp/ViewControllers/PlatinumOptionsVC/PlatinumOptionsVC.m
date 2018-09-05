//
//  PlatinumOptionsVC.m
//  Signature
//
//  Created by Iurie Manea on 17.03.2015.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "PlatinumOptionsVC.h"
#import "ViewOptionsVC.h"
#import "PlatinumOptionCell.h"
#import "ServiceOptionVC.h"

@interface PlatinumOptionsVC ()
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UIButton     *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@end

static NSString *s_PlatinumOptionCellID = @"PlatinumOptionCell";

@implementation PlatinumOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Summary of Findings";
    
    UIColor* titleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 45,25)];
    [someButton setTitle:@" IAQ " forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(tapIAQButton)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    someButton.layer.borderWidth = 1;
    someButton.layer.borderColor = titleColor.CGColor;
    [someButton setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *iaqButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:s_PlatinumOptionCellID bundle:nil] forCellReuseIdentifier:s_PlatinumOptionCellID];
      
    self.btnContinue.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.pictureButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.priceBookAndServiceOptions = [DataLoader loadLocalFinalOptions];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > PlatinumOptions) {
        [DataLoader saveOptionsDisplayType:odtReadonlyWithPrice];
        [DataLoader saveFinalOptionsLocal:[NSMutableArray arrayWithArray:self.priceBookAndServiceOptions]];
        ServiceOptionVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceOptionVC2"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        
        [[TechDataModel sharedTechDataModel] saveCurrentStep:PlatinumOptions];
    }
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = PlatinumOptions;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.priceBookAndServiceOptions.firstObject[@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PricebookItem *option = self.priceBookAndServiceOptions.firstObject[@"items"][indexPath.row];
    PlatinumOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:s_PlatinumOptionCellID];
    NSString * serviceString;
    if ([option.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",option.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:option.name];
    cell.lbTitle.text = nameString;

    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[ViewOptionsVC class]])
    {
        [DataLoader saveFinalOptionsLocal:[NSMutableArray arrayWithArray:self.priceBookAndServiceOptions]];
       
    }
    
    if ([[segue destinationViewController] isKindOfClass:[ServiceOptionVC class]]) {
//        ServiceOptionVC *vc = [segue destinationViewController];
        [DataLoader saveOptionsDisplayType:odtReadonlyWithPrice];
        [DataLoader saveFinalOptionsLocal:[NSMutableArray arrayWithArray:self.priceBookAndServiceOptions]];
    }
}

@end
