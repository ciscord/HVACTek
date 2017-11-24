//
//  IAQEditServiceOptionsVC.m
//  HvacTek
//
//  Created by Max on 11/16/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "IAQEditServiceOptionsVC.h"
#import "EditServiceOptionsCell.h"
#import "IAQDataModel.h"
@interface IAQEditServiceOptionsVC ()

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;
@property (weak, nonatomic) IBOutlet UIButton *bacBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation IAQEditServiceOptionsVC

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureVC {
    self.title = @"Customer's Choice";
    [self.serviceTableView registerNib:[UINib nibWithNibName:@"EditServiceOptionsCell" bundle:nil] forCellReuseIdentifier:@"EditServiceOptionsCell"];
    
    [self configureColorScheme];
    
    switch (self.selectedIndex) {
        case 0:
            self.serviceNameLabel.text = @"Best";
            self.changedServicesArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqBestProductsArray];
            break;
        case 1:
            self.serviceNameLabel.text = @"Better";
            self.changedServicesArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqBetterProductsArray];
            break;
        case 2:
            self.serviceNameLabel.text = @"Good";
            self.changedServicesArray = [NSMutableArray arrayWithArray:[IAQDataModel sharedIAQDataModel].iaqGoodProductsArray];
            break;
            
        default:
            break;
    }
    self.servicesArray = [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray;
    
    [self.serviceTableView reloadData];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.bacBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.saveBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.serviceNameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

#pragma mark - Buttons Actions
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    
    switch (self.selectedIndex) {
        case 0:
            [IAQDataModel sharedIAQDataModel].iaqBestProductsArray = [NSMutableArray arrayWithArray:self.changedServicesArray];
            break;
        case 1:
            [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray = [NSMutableArray arrayWithArray:self.changedServicesArray];
            break;
        case 2:
            [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray = [NSMutableArray arrayWithArray:self.changedServicesArray];
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.servicesArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditServiceOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditServiceOptionsCell"];
    
    IAQProductModel *productModel   = self.servicesArray[indexPath.section];
    
    NSString * serviceString;
    if ([productModel.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",productModel.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:productModel.title];
    
    if ([self.changedServicesArray containsObject:productModel]){
        if (cell.serviceNameLabel.attributedText){
            cell.serviceNameLabel.attributedText = nil;
        }
        cell.serviceNameLabel.text = nameString;
        
        cell.changeStatusButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        [cell.changeStatusButton setTitle:@"x" forState:UIControlStateNormal];
        
    }else{
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
        cell.serviceNameLabel.attributedText = attrText;
        
        cell.changeStatusButton.backgroundColor = [UIColor colorWithRed:239/255.0f green:64/255.0f blue:55/255.0f alpha:1.0f];
        [cell.changeStatusButton setTitle:@"+" forState:UIControlStateNormal];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IAQProductModel *productModel   = self.servicesArray[indexPath.section];
    
    if ([self.changedServicesArray containsObject:productModel]) {
        if (self.changedServicesArray.count == 1) {
            TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"At least one service option must be selected."];
            [self presentViewController:alert animated:true completion:nil];
            
        }else
            [self.changedServicesArray removeObject:productModel];
    }else{
        [self.changedServicesArray addObject:productModel];
    }
    [self.serviceTableView reloadData];
}

@end
