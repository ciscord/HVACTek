//
//  User.h
//  
//
//  Created by Mihai Tugui on 4/16/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Job;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * add2cart;
@property (nonatomic, retain) NSNumber * tech;
@property (nonatomic, retain) NSString * userCode;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *jobs;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addJobsObject:(Job *)value;
- (void)removeJobsObject:(Job *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

@end
