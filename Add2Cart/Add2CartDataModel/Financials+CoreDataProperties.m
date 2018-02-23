//
//  Financials+CoreDataProperties.m
//  
//
//  Created by Max on 1/11/18.
//
//

#import "Financials+CoreDataProperties.h"

@implementation Financials (CoreDataProperties)

+ (NSFetchRequest<Financials *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Financials"];
}

@dynamic businessid;
@dynamic description1;
@dynamic type;
@dynamic financialId;
@dynamic month;
@dynamic value;
@dynamic sortIndex;
@end
