//
//  Pricebook.h
//  Signature
//
//  Created by Iurie Manea on 3/3/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PricebookItem : NSObject
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemNumber;
@property (nonatomic, strong) NSString *itemGroup;
@property (nonatomic, strong) NSString *itemCategory;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *amountESA;
@property (nonatomic, assign) BOOL isMain;

+(instancetype) pricebookWithID:(NSString*)itemID
                     itemNumber:(NSString*)itemNumber
                      itemGroup:(NSString*)itemGroup
                   itemCategory:(NSString*)itemCategory
                           name:(NSString *)name
                       quantity:(NSString *)quantity
                         amount:(NSNumber *)amount
                   andAmountESA:(NSNumber *)amountESA;
@end