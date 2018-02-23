//
//  Financials+CoreDataProperties.h
//  
//
//  Created by Max on 1/11/18.
//
//

#import "Financials+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Financials (CoreDataProperties)

+ (NSFetchRequest<Financials *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *businessid;
@property (nullable, nonatomic, copy) NSString *description1;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *financialId;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSNumber *sortIndex;
@end

NS_ASSUME_NONNULL_END
