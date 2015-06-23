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
@end

static NSString *s_PlatinumOptionCellID = @"PlatinumOptionCell";

@implementation PlatinumOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:s_PlatinumOptionCellID bundle:nil] forCellReuseIdentifier:s_PlatinumOptionCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[ViewOptionsVC class]])
    {
        ViewOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.priceBookAndServiceOptions;
    }
    
    if ([[segue destinationViewController] isKindOfClass:[ServiceOptionVC class]]) {
        ServiceOptionVC *vc = [segue destinationViewController];
        vc.optionsDisplayType = odtReadonlyWithPrice;
        vc.priceBookAndServiceOptions = self.priceBookAndServiceOptions;
    }
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
    cell.lbTitle.text = option.name;

    return cell;
}

@end
