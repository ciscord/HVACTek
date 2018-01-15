//
//  CartCell.m
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "CartCell.h"
#import "ProductCell.h"
#import "Item.h"
#import "HvakTekColorScheme.h"
#import "Financials+CoreDataClass.h"



@interface CartCell ()
{
    float easyPaymentFactor;
}

@property (nonatomic, strong)  NSMutableArray *cartItems;
@property (nonatomic, strong)  NSMutableArray *productList;
@property (nonatomic, strong)  NSMutableArray *occurenciesList;
@property (nonatomic, strong)  NSMutableArray *rebates;
@property (nonatomic, strong)  NSMutableArray *easyFinancialsData;
@property (nonatomic, strong)  NSMutableArray *fastFinancialsData;
@property (nonatomic, strong)  NSNumber *fastMonth;
@property (nonatomic, strong)  NSNumber *easyMonth;

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIButton *sysRebatesButton;
@property (weak, nonatomic) IBOutlet UIButton *investmentButton;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@end


@implementation CartCell 

- (void)awakeFromNib {
    // Initialization code
    [self configureColorScheme];
    [self.poductTableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
    self.poductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.contentView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    self.sysRebatesButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.investmentButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.easyPayButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary35];
    self.fastPayButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary35];
    self.doneButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.saveButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.editButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) updateProductList {
    self.cartItems = [self.cart objectForKey:@"cartItems"];
    self.fastMonth = [self.cart objectForKey:@"fastMonth"];
    self.easyMonth = [self.cart objectForKey:@"easyMonth"];
    self.rebates = [self.cart objectForKey:@"cartRebates"];
    self.fastFinancialsData = [self.cart objectForKey:@"fastFinancialsData"];
    self.easyFinancialsData = [self.cart objectForKey:@"easyFinancialsData"];

    self.productList = [[NSMutableArray alloc]init];
    self.occurenciesList = [[NSMutableArray alloc]init];
    
    
    for (int x = 0; x < self.cartItems.count; x++){
        Item *itm = self.cartItems[x];
        
        if ( [itm.type isEqualToString:@"TypeOne"] || [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"] ) {
            // do nothing
            
        } else {
            
            if ([self.productList containsObject:itm.modelName]){
                [self.occurenciesList addObject:itm.modelName];
                
            }else{
                [self.productList addObject:itm.modelName];
            }
        }
        
    }
        [self.occurenciesList addObjectsFromArray:self.productList];
        [self.poductTableView reloadData];

    [self buildQuote];
}

-(void) buildQuote {
    float totalAmount = 0.0f;
    float totalSavings = 0.0f;
    float afterSavings = 0.0f;
    float finacePay = 0.0f;
    float monthlyPay = 0.0f;
    
    
    for (int jj = 0; jj <self.cartItems.count; jj++) {
        Item *itm = self.cartItems[jj];
        if ([itm.type isEqualToString:@"TypeTwo"]&&[itm.optionOne floatValue]!=0)
        {
            totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
        }
        else
        {
            totalAmount += [itm.finalPrice floatValue];
        }
    }
    
    for (int jj = 0; jj <self.rebates.count; jj++) {
        Item *itm = self.rebates[jj];
        totalSavings += [itm.finalPrice floatValue];
    }
    
    float invest;
    
    Financials *fastFinanceObject;
    for (int i = 0; i < [self.fastFinancialsData count]; i++) {
        Financials *element = [self.fastFinancialsData objectAtIndex:i];
        if (element.month.intValue == self.fastMonth.intValue) {
            fastFinanceObject = element;
            break;
        }
    }
    
    Financials *easyFinanceObject;
    for (int i = 0; i < [self.easyFinancialsData count]; i++) {
        Financials *element = [self.easyFinancialsData objectAtIndex:i];
        if (element.month.intValue == self.easyMonth.intValue) {
            easyFinanceObject = element;
            easyPaymentFactor = element.value.floatValue;
            break;
        }
    }
    
    invest = (float)(totalAmount - totalSavings);
    float localInvest = (float)(totalAmount - totalSavings);
    
    [self updateLabels:invest :totalSavings :afterSavings :finacePay :monthlyPay localInvest:localInvest easyFinanceObject:easyFinanceObject fastFinanceObject:fastFinanceObject];
}

-(void) updateLabels:(float)total :(float)totalSave :(float)afterSaving :(float)financeP :(float)month localInvest:(float)localInvest easyFinanceObject:(Financials*)easyFinanceObject fastFinanceObject:(Financials*)fastFinanceObject {

    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    
    //new
    self.systemRebates.text=[NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalSave]]];
    self.investemnt.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest]]];
    
    if (fastFinanceObject) {
        self.lblFastPayPrice.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest / [self.fastMonth intValue]]]];
        
    }else {
        self.lblFastPayPrice.text = @"No Financial";
        
    }
    
    if (easyFinanceObject) {
        
        self.lblEasyPayPrice.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest * easyPaymentFactor]]];
        
    }else {
        self.lblEasyPayPrice.text = @"No Financial";
        
    }
    
}

#pragma marck tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.productList.count;

};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ProductCell *acell = [self.poductTableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    NSString * title = [self.productList objectAtIndex:indexPath.row];
    
    
    int occurrences = 0;
    for(NSString *name in self.occurenciesList) {
        occurrences += ([name isEqualToString:title] ? 1 : 0);
    }
    
    if (occurrences > 1) {
        NSString *multiplier = [NSString stringWithFormat:@"(%d) ",occurrences];
        NSString *finString = [multiplier stringByAppendingString:title];
        acell.lblTitle.text = finString;
    }else{
        acell.lblTitle.text = title;
    }
    
    return acell;
};


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (IBAction)done:(id)sender {
    [self.delegate done];
}

- (IBAction)saveCart:(id)sender {
    [self.delegate save:self.cart withIndex:[sender tag] andMonths:self.fastMonth];
}


- (IBAction)editCart:(id)sender {
    [self.delegate editCard:self.cart withIndex:[sender tag] andMonths:self.fastMonth];
}

@end
