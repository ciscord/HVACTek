//
//  Item+CoreDataProperties.h
//  HvacTek
//
//  Created by Dorin on 2/9/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *currentCart;
@property (nullable, nonatomic, retain) NSString *finalOption;
@property (nullable, nonatomic, retain) NSNumber *finalPrice;
@property (nullable, nonatomic, retain) NSNumber *include;
@property (nullable, nonatomic, retain) NSString *manu;
@property (nullable, nonatomic, retain) NSString *modelName;
@property (nullable, nonatomic, retain) NSNumber *optEightPrice;
@property (nullable, nonatomic, retain) NSNumber *optFivePrice;
@property (nullable, nonatomic, retain) NSNumber *optFourPrice;
@property (nullable, nonatomic, retain) NSString *optionEight;
@property (nullable, nonatomic, retain) NSString *optionFive;
@property (nullable, nonatomic, retain) NSString *optionFour;
@property (nullable, nonatomic, retain) NSString *optionOne;
@property (nullable, nonatomic, retain) NSString *optionSeven;
@property (nullable, nonatomic, retain) NSString *optionSix;
@property (nullable, nonatomic, retain) NSString *optionThree;
@property (nullable, nonatomic, retain) NSString *optionTwo;
@property (nullable, nonatomic, retain) NSNumber *optOnePrice;
@property (nullable, nonatomic, retain) NSNumber *optSevenPrice;
@property (nullable, nonatomic, retain) NSNumber *optSixPrice;
@property (nullable, nonatomic, retain) NSNumber *optThreePrice;
@property (nullable, nonatomic, retain) NSNumber *optTwoPrice;
@property (nullable, nonatomic, retain) NSNumber *ord;
@property (nullable, nonatomic, retain) NSData *photo;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *typeID;
@property (nullable, nonatomic, retain) NSNumber *usserAdet;
@property (nullable, nonatomic, retain) NSManagedObject *image;

@end

NS_ASSUME_NONNULL_END
