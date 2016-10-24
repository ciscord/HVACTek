//
//  Financials+CoreDataProperties.m
//  HvacTek
//
//  Created by Dora on 10/22/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "Financials+CoreDataProperties.h"

@implementation Financials (CoreDataProperties)

+ (NSFetchRequest<Financials *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Financials"];
}

@dynamic businessid;
@dynamic discount1;
@dynamic discount2;
@dynamic financialId;
@dynamic months;

@end
