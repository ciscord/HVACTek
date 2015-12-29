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



@interface CartCell ()

 @property (nonatomic, strong)  NSMutableArray *cartItems;
 @property (nonatomic, strong)  NSMutableArray *productList;
 @property (nonatomic, strong)  NSMutableArray *rebates;
 @property (nonatomic, strong)  NSNumber *months;

@end


@implementation CartCell 

- (void)awakeFromNib {
    // Initialization code

      [self.poductTableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
      self.poductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.productList = [[NSMutableArray alloc]init];
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) updateProductList {
    self.cartItems = [self.cart objectForKey:@"cartItems"];
    self.months = [self.cart objectForKey:@"cartMonths"];
    self.rebates = [self.cart objectForKey:@"cartRebates"];

    
    for (int x = 0; x < self.cartItems.count; x++){
        Item *itm = self.cartItems[x];
        
        if ( [itm.type isEqualToString:@"TypeOne"] || [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"] ) {
            // do nothing
            
        } else {
            [self.productList addObject:itm.modelName];
        }
        
        
    }
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
        if ([itm.type isEqualToString:@"TypeThree"]&&[itm.optionOne floatValue]!=0)
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
    switch ([self.months intValue]) {
        case 24:
        {
            finacePay =  (totalAmount - totalSavings)/24;//.915
            invest = (finacePay*24);
         
            break;
        }
            
        case 36:
        {
            finacePay = (totalAmount - totalSavings)/.88/36;
            invest = (finacePay*36);
            break;
        }
        case 48:{
            finacePay = (totalAmount - totalSavings)/.865/48;
            invest = (finacePay*48);
            break;
        }
        case 60:{
            finacePay = (totalAmount - totalSavings)/.85/60;
            invest = (finacePay*60);
            break;
        }
        case 84:{
            finacePay = ((totalAmount - totalSavings)/.8975) * 0.0144;
            invest = (totalAmount - totalSavings)/.8975;
            break;
        }
        case 144:{
            finacePay = ((totalAmount - totalSavings)/.909) * 0.0111;
            invest = (totalAmount - totalSavings)/.909;
            break;
        }
        default:
        {
            finacePay = totalAmount - totalSavings;
            invest=  (totalAmount - totalSavings);
            break;
        }
    }
    
    [self updateLabels:invest :totalSavings :afterSavings :finacePay :monthlyPay ];
}


-(void) updateLabels:(float)total :(float)totalSave :(float)afterSaving :(float)financeP :(float)month {

    
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
    self.investemnt.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]]];
    switch ([self.months intValue]) {
        case 84:
            self.financing.text =[NSString stringWithFormat:@"3.99%% Best Rate \n%i Months",[self.months intValue]];
            
            break;
        case 144:
            self.financing.text =[NSString stringWithFormat:@"7.99%% Lowest Payment \n%i Months",[self.months intValue]];
            break;
            
        case 0:
            self.financing.text =[NSString stringWithFormat:@"Cash /Check /Credit Card"];
            break;
            
        default:
            self.financing.text =[NSString stringWithFormat:@"0%% Financing\n%i Equal Payments",[self.months intValue]];
            break;
    }
    
   self.lblFinaincinSum.text =[NSString stringWithFormat:@"$%@",[nf stringFromNumber:[NSNumber numberWithFloat:financeP]]];
    
    
}


#pragma marck tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return self.productList.count;

};



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ProductCell *acell = [self.poductTableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    acell.lblTitle.text = [self.productList objectAtIndex:indexPath.row];

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
    [self.delegate save:self.cart withIndex:[sender tag]];
}


- (IBAction)editCart:(id)sender {
    [self.delegate editCard:self.cart withIndex:[sender tag]];
}


@end
