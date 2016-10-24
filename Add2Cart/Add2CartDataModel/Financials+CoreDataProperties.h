//
//  Financials+CoreDataProperties.h
//  HvacTek
//
//  Created by Dora on 10/22/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "Financials+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Financials (CoreDataProperties)

+ (NSFetchRequest<Financials *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *businessid;
@property (nullable, nonatomic, copy) NSString *discount1;
@property (nullable, nonatomic, copy) NSString *discount2;
@property (nullable, nonatomic, copy) NSString *financialId;
@property (nullable, nonatomic, copy) NSString *months;

@end

NS_ASSUME_NONNULL_END
