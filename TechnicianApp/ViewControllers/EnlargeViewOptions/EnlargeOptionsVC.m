//
//  EnlargeOptionsVC.m
//  Signature
//
//  Created by Dorin on 8/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "EnlargeOptionsVC.h"

@interface EnlargeOptionsVC ()

@property (weak, nonatomic) IBOutlet UITableView *enlargeTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *ESAPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthlyPaymentsLbl;
@property (weak, nonatomic) IBOutlet UILabel *savingESALbl;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@end

@implementation EnlargeOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Customer's Choice", nil);
    
    self.optionNameLabel.text = self.enlargeOptionName;
    self.totalPriceLbl.text = self.enlargeTotalPrice;
    self.ESAPriceLbl.text = self.enlargeESAPrice;
    self.monthlyPaymentsLbl.text = self.enlargeMonthlyPrice;
    self.savingESALbl.text = self.enlargeSavings;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
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
    cell.textLabel.font          = [UIFont fontWithName:@"Calibri-Light" size:17];
    cell.textLabel.textColor     = [UIColor blackColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
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
