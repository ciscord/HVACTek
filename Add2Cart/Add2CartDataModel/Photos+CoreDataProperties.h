//
//  Photos+CoreDataProperties.h
//  HvacTek
//
//  Created by Dorin on 2/9/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photos.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photos (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *photoData;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface Photos (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
