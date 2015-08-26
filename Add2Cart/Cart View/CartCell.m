//
//  CartCell.m
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "CartCell.h"
#import "ProductCell.h"

@implementation CartCell

- (void)awakeFromNib {
    // Initialization code

      [self.poductTableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
     self.poductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}


#pragma marck tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return 3;
    
    //self.productList.count;
};



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ProductCell *acell = [self.poductTableView dequeueReusableCellWithIdentifier:@"ProductCell"];

    //    CellProducts *acell = [self.tableView dequeueReusableCellWithIdentifier:@"cellP" forIndexPath:indexPath];
    //    [acell.lblTitle setText:self.productList[indexPath.row]];
    return acell;
    
};


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}






@end
