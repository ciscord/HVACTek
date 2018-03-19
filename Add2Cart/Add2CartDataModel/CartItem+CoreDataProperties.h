//
//  CartItem+CoreDataProperties.h
//  
//
//  Created by Admin on 3/15/18.
//
//

#import "CartItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CartItem (CoreDataProperties)

+ (NSFetchRequest<CartItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *currentCart;
@property (nullable, nonatomic, copy) NSString *finalOption;
@property (nullable, nonatomic, copy) NSNumber *finalPrice;
@property (nullable, nonatomic, copy) NSNumber *include;
@property (nullable, nonatomic, copy) NSString *manu;
@property (nullable, nonatomic, copy) NSString *modelName;
@property (nullable, nonatomic, copy) NSNumber *optEightPrice;
@property (nullable, nonatomic, copy) NSNumber *optFivePrice;
@property (nullable, nonatomic, copy) NSNumber *optFourPrice;
@property (nullable, nonatomic, copy) NSString *optionEight;
@property (nullable, nonatomic, copy) NSString *optionFive;
@property (nullable, nonatomic, copy) NSString *optionFour;
@property (nullable, nonatomic, copy) NSString *optionOne;
@property (nullable, nonatomic, copy) NSString *optionSeven;
@property (nullable, nonatomic, copy) NSString *optionSix;
@property (nullable, nonatomic, copy) NSString *optionThree;
@property (nullable, nonatomic, copy) NSString *optionTwo;
@property (nullable, nonatomic, copy) NSNumber *optOnePrice;
@property (nullable, nonatomic, copy) NSNumber *optSevenPrice;
@property (nullable, nonatomic, copy) NSNumber *optSixPrice;
@property (nullable, nonatomic, copy) NSNumber *optThreePrice;
@property (nullable, nonatomic, copy) NSNumber *optTwoPrice;
@property (nullable, nonatomic, copy) NSNumber *ord;
@property (nullable, nonatomic, retain) NSData *photo;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *typeID;
@property (nullable, nonatomic, copy) NSNumber *usserAdet;
@property (nullable, nonatomic, retain) NSManagedObject *image;

@end

NS_ASSUME_NONNULL_END
