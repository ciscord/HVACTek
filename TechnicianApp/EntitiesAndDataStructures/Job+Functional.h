//
//  Job+Functional.h
//  Signature
//
//  Created by Iurie Manea on 3/4/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "Job.h"

@class User;

typedef NS_ENUM (NSInteger, JobStatusType){
    jstNew,
    jstAssigned,
    jstNeedDebrief,
    jstDone
};

@interface Job(Functional)

+ (instancetype)jobWithDictionnary:(NSDictionary*)jobInfo forUser:(User*)user;

@property (nonatomic, readonly) NSDictionary *swapiCustomerInfo;

@end
