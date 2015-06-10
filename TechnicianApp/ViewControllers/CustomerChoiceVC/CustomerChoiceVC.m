//
//  CustomerChoiceVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "CustomerChoiceVC.h"
#import "RecommendationTableViewCell.h"
#import <SignatureView.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface CustomerChoiceVC ()

@property (weak, nonatomic) IBOutlet UIView        *vContainer;
@property (weak, nonatomic) IBOutlet UITableView   *tvMainTable;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UITableView   *tvUnselectedOptions;
@property (strong, nonatomic) NSMutableArray       *unusedServiceOptions;

@end

@implementation CustomerChoiceVC

static NSString *kCELL_IDENTIFIER = @"RecommendationTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = NSLocalizedString(@"Customer's Choice", nil);

    self.vContainer.layer.borderWidth = 1.0;
    self.vContainer.layer.borderColor = [[UIColor colorWithRed:0.471 green:0.741 blue:0.267 alpha:1.000] CGColor];

    [self.tvMainTable registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
//    [self.tvMainTable reloadData];

    self.signatureView.layer.borderWidth   = 1.5;
    self.signatureView.layer.borderColor   = [[UIColor darkGrayColor] CGColor];
    self.signatureView.foregroundLineColor = [UIColor colorWithRed:0.000 green:0.250 blue:0.702 alpha:1.000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSave:(id)sender {

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (!job.completionTime) {
        job.completionTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    job.jobStatus = @(jstNeedDebrief);
   // job.startTime = [NSDate date];
    [job.managedObjectContext save];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationController popToViewController:appDelegate.homeController animated:YES];
}

- (IBAction)btnClearSignature:(id)sender {
    [self.signatureView clear];
}

- (void)setSelectedServiceOptions:(NSDictionary *)selectedServiceOptions {

    _selectedServiceOptions = selectedServiceOptions;
    NSArray *selectedItems = _selectedServiceOptions[@"items"];
    self.unusedServiceOptions = @[].mutableCopy;
    for (PricebookItem *p1 in _fullServiceOptions) {

        BOOL unselected = YES;

        for (PricebookItem *p2 in selectedItems) {
            if ([p1.name isEqualToString:p2.name]) {
                unselected = NO;
                break;
            }
        }

        if (unselected) {
            [self.unusedServiceOptions addObject:p1];
        }
    }
    [self.tvMainTable reloadData];
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvMainTable) {
        return 160;
    }

    if (tableView == self.tvUnselectedOptions) {
        return 35;
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvMainTable) {
        return 1;
    }

    if (tableView == self.tvUnselectedOptions) {
        return [self.unusedServiceOptions count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result;
    if (tableView == self.tvMainTable) {

        NSMutableArray *items1 = self.selectedServiceOptions[@"items"];

        RecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
        cell.gradientView.image        = self.selectedServiceOptions[@"backgroundImage"];
        cell.lbRecommandationName.text = self.selectedServiceOptions[@"title"];
        cell.rowIndex                  = indexPath.row;
        cell.optionsDisplayType        = odtCustomerFinalChoice;
        cell.isDiscounted              = self.isDiscounted;
        [cell displayServiceOptions:items1];
        result = cell;
    }

    if (tableView == self.tvUnselectedOptions) {

        static NSString *cellIdentifier = @"identifier";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        PricebookItem *p = self.unusedServiceOptions[indexPath.row];
        cell.textLabel.text          = p.name;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font          = [UIFont fontWithName:@"Calibri-Light" size:17];
        cell.textLabel.textColor     = [UIColor grayColor];

        result = cell;
    }

    return result;
}

@end
