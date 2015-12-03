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
                       quantity:(NSString *)quantity
                         amount:(NSNumber *)amount
                   andAmountESA:(NSNumber *)amountESA {
    PricebookItem *pricebook = [PricebookItem new];
    pricebook.itemID     = itemID;
    pricebook.itemNumber = itemNumber;
    pricebook.itemGroup  = itemGroup;
    pricebook.name       = name;
    pricebook.quantity   = quantity;
    pricebook.amount     = amount;
    pricebook.amountESA  = amountESA;
    pricebook.isMain     = NO;
    return pricebook;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.itemID     = [aDecoder decodeObjectForKey:@"itemID"] ;
        self.itemNumber = [aDecoder decodeObjectForKey:@"itemNumber"];
        self.itemGroup  = [aDecoder decodeObjectForKey:@"itemGroup"];
        self.name       = [aDecoder decodeObjectForKey:@"name"];
        self.quantity   = [aDecoder decodeObjectForKey:@"quantity"];
        self.amount     = [aDecoder decodeObjectForKey:@"amount"];
        self.amountESA  = [aDecoder decodeObjectForKey:@"amountESA"];
        self.isMain     = [[aDecoder decodeObjectForKey:@"isMain"]boolValue];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes
   [aCoder encodeObject:self.itemID forKey:@"itemID"] ;
   [aCoder encodeObject:self.itemNumber forKey:@"itemNumber"];
   [aCoder encodeObject:self.itemGroup forKey:@"itemGroup"];
   [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.quantity forKey:@"quantity"];
    [aCoder encodeObject:self.amount forKey:@"amount"];
   [aCoder encodeObject:self.amountESA forKey:@"amountESA"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isMain]   forKey:@"isMain"];

}
@end