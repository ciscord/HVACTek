//
//  Logs+Functional.m
//  HvacTek
//
//  Created by Dorin on 7/13/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "Logs+Functional.h"
#import "NSManagedObject+CoreData.h"
#import "NSManagedObjectContext+Custom.h"



@implementation Logs(Functional)

+ (instancetype)initLogWithUserID:(NSString *)userID
                             date:(NSDate *)date
                          message:(NSString *)message
                           module:(NSString *)module
                          request:(NSString *)request
                      andResponse:(NSString *)response {
    
    Logs *log = [Logs findFirstByAttribute:@"date" withValue:date createNewIfNotExists:YES];
    log.userID = userID;
    log.date = date;
    log.message = message;
    log.module = module;
    log.request = request;
    log.response = response;
    [log.managedObjectContext save];
    
    return log;
}


@end