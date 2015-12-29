//
//  CartCell.h
//  Signature
//
//  Created by Mihai Tugui on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CartCell;
@protocol CartCellDelegate
-(void)editCard:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex;
-(void)save:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex;
-(void)done;
@end

@interface CartCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) id<CartCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *poductTableView;
@property (nonatomic, strong)  NSMutableDictionary *cart;
@property (strong, nonatomic) IBOutlet UILabel *lblCartNumber;

@property (weak, nonatomic) IBOutlet UILabel *systemRebates;
@property (weak, nonatomic) IBOutlet UILabel *financing;
@property (weak, nonatomic) IBOutlet UILabel *investemnt;
@property (strong, nonatomic) IBOutlet UILabel *lblFinaincinSum;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
-(void) updateProductList;
@end
