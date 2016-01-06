//
//  Job+Functional.m
//  Signature
//
//  Created by Iurie Manea on 3/4/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "Job+Functional.h"
#import "NSManagedObject+CoreData.h"
#import "NSManagedObjectContext+Custom.h"

@implementation Job(Functional)

+ (instancetype)jobWithDictionnary:(NSDictionary*)jobInfo forUser:(User*)user {
    
    Job *job = [Job findFirstByAttribute:@"jobID" withValue:jobInfo[@"JobID"] createNewIfNotExists:YES];
    job.user = user;
    job.swapiJobInfo = jobInfo;

    [job.managedObjectContext save];
    
    return job;
}
-(NSDictionary*)swapiCustomerInfo {
    
    return self.swapiJobInfo;
   // return [self.swapiJobInfo valueForKeyPath:@"dsLocationList.dsLocation"];
}

@end
