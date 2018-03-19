//
//  CartItem+CoreDataProperties.m
//  
//
//  Created by Admin on 3/15/18.
//
//

#import "CartItem+CoreDataProperties.h"

@implementation CartItem (CoreDataProperties)

+ (NSFetchRequest<CartItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
}

@dynamic currentCart;
@dynamic finalOption;
@dynamic finalPrice;
@dynamic include;
@dynamic manu;
@dynamic modelName;
@dynamic optEightPrice;
@dynamic optFivePrice;
@dynamic optFourPrice;
@dynamic optionEight;
@dynamic optionFive;
@dynamic optionFour;
@dynamic optionOne;
@dynamic optionSeven;
@dynamic optionSix;
@dynamic optionThree;
@dynamic optionTwo;
@dynamic optOnePrice;
@dynamic optSevenPrice;
@dynamic optSixPrice;
@dynamic optThreePrice;
@dynamic optTwoPrice;
@dynamic ord;
@dynamic photo;
@dynamic type;
@dynamic typeID;
@dynamic usserAdet;
@dynamic image;

@end
