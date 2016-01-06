//
//  User+Functional.m
//  Signature
//
//  Created by Iurie Manea on 3/4/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "User+Functional.h"
#import "NSManagedObject+CoreData.h"
#import "NSManagedObjectContext+Custom.h"
#import "Job+Functional.h"
#import "DataLoader.h"

@implementation User(Functional)

+ (instancetype)userWithName:(NSString*)userName userID:(NSNumber*)userID andCode:(NSString*)userCode {

    User *user = [User findFirstByAttribute:@"userName" withValue:userName createNewIfNotExists:YES];
    user.userCode = userCode;
    user.userID = userID;
    [user.managedObjectContext save];
    
    return user;
}

-(Job*)activeJob
{
    
    return [[self.jobs filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"jobStatus != %i", jstDone]] anyObject];
}

+(NSMutableDictionary*)getNextJobFromList:(NSArray*)jobslist withJobID:(NSString *)JobID {
    
    NSMutableArray * jobIds = [[NSMutableArray alloc]init];
    for (Job * job in [DataLoader sharedInstance].currentUser.jobs) {
        [jobIds addObject:job.jobID];
    }
    NSArray *activeJobs = [jobslist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(NOT (JobID IN %@) ) AND (Progress == %@)", jobIds, @"new"]];
    
    //NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Scheduled" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"JobID == %@",JobID];
    
    return  [activeJobs filteredArrayUsingPredicate:predicate].firstObject;
}
@end
