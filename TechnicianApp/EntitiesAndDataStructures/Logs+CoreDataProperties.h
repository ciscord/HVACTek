//
//  Logs+CoreDataProperties.h
//  HvacTek
//
//  Created by Dorin on 7/13/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Logs.h"

NS_ASSUME_NONNULL_BEGIN

@interface Logs (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *module;
@property (nullable, nonatomic, retain) NSString *request;
@property (nullable, nonatomic, retain) NSString *response;
@property (nullable, nonatomic, retain) NSString *userID;

@end

NS_ASSUME_NONNULL_END
