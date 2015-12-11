//
//  RROverviewVC.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RROverviewVC.h"
#import "RROverviewCell.h"
#import "Question.h"
#import "RRFinalChoiceVC.h"

@interface RROverviewVC ()

@property (weak, nonatomic) IBOutlet UITableView *overviewTable;
@property(nonatomic, strong) NSMutableArray *tableArray;
@property(nonatomic, strong) NSString *totalString;


@end



@implementation RROverviewVC


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}


-(void)configureVC {
    self.title = @"Customer's Choice";
    [self.overviewTable registerNib:[UINib nibWithNibName:@"RROverviewCell" bundle:nil] forCellReuseIdentifier:@"RROverviewCell"];
    self.tableArray = self.overviewArray.mutableCopy;
    for (Question *q in self.overviewArray) {
        if ([q.name isEqualToString:@"RR1"] || [q.name isEqualToString:@"RR2"]) {
            [self.tableArray removeObject:q];
        }
    }
    [self changeQuestionsNames];
    [self calculateTotalInvestments];
    
}


- (void)changeQuestionsNames {
    for (Question *q in self.overviewArray) {
        if ([q.name isEqualToString:@"RR3"]) {
            q.question = @"Cost Of Today's Repairs:";
        }else if ([q.name isEqualToString:@"RR4"]) {
            q.question = @"Additional Investment In Current System:";
        }else if ([q.name isEqualToString:@"RR5"]) {
            q.question = @"Utility Overpayment Over The Next 5 Years:";
        }else if ([q.name isEqualToString:@"RR6"]) {
            q.question = @"Cost Of Inflation Over The Next 5 Years:";
        }else if ([q.name isEqualToString:@"RR7"]) {
            q.question = @"Trade In Value Of Current System:";
        }
    }
}

- (void)calculateTotalInvestments {
    
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:YES];
    
    float total = 0.00f;
    for (Question *q in self.tableArray) {
        NSNumber *number = [paymentFormatter numberFromString:q.answer];
        total += [number floatValue];
    }
    self.totalString = [paymentFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
}



#pragma mark - Next Clicked
- (IBAction)nextBtnClicked:(UIButton *)sender {
}


#pragma mark - UITableViewDelegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RROverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RROverviewCell"];
    Question *q = [self.tableArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = q.question;
    cell.priceLabel.text = q.answer;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRRFinalChoiceVC"]) {
        RRFinalChoiceVC *vc = [segue destinationViewController];
        vc.totalInvestment = self.totalString;
    }
}

@end
