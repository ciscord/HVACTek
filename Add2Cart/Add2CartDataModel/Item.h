//
//  Item.h
//  
//
//  Created by Mihai Tugui on 6/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * currentCart;
@property (nonatomic, retain) NSString * finalOption;
@property (nonatomic, retain) NSNumber * finalPrice;
@property (nonatomic, retain) NSNumber * include;
@property (nonatomic, retain) NSString * manu;
@property (nonatomic, retain) NSString * modelName;
@property (nonatomic, retain) NSNumber * optEightPrice;
@property (nonatomic, retain) NSNumber * optFivePrice;
@property (nonatomic, retain) NSNumber * optFourPrice;
@property (nonatomic, retain) NSString * optionEight;
@property (nonatomic, retain) NSString * optionFive;
@property (nonatomic, retain) NSString * optionFour;
@property (nonatomic, retain) NSString * optionOne;
@property (nonatomic, retain) NSString * optionSeven;
@property (nonatomic, retain) NSString * optionSix;
@property (nonatomic, retain) NSString * optionThree;
@property (nonatomic, retain) NSString * optionTwo;
@property (nonatomic, retain) NSNumber * optOnePrice;
@property (nonatomic, retain) NSNumber * optSevenPrice;
@property (nonatomic, retain) NSNumber * optSixPrice;
@property (nonatomic, retain) NSNumber * optThreePrice;
@property (nonatomic, retain) NSNumber * optTwoPrice;
@property (nonatomic, retain) NSData   * photo;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSNumber * usserAdet;
@property (nonatomic, retain) NSNumber * ord;

@end
