//
//  Pricebook.m
//  Signature
//
//  Created by Iurie Manea on 3/3/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "PricebookItem.h"

@implementation PricebookItem

+ (instancetype)pricebookWithID:(NSString *)itemID
                     itemNumber:(NSString *)itemNumber
                      itemGroup:(NSString *)itemGroup
                           name:(NSString *)name
                         amount:(NSNumber *)amount
                   andAmountESA:(NSNumber *)amountESA {
    PricebookItem *pricebook = [PricebookItem new];
    pricebook.itemID     = itemID;
    pricebook.itemNumber = itemNumber;
    pricebook.itemGroup  = itemGroup;
    pricebook.name       = name;
    pricebook.amount     = amount;
    pricebook.amountESA  = amountESA;
    pricebook.isMain     = NO;
    return pricebook;
}

@end