//
//  User+Functional.h
//  Signature
//
//  Created by Iurie Manea on 3/4/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "User.h"

@interface User(Functional)

+ (instancetype)userWithName:(NSString*)userName userID:(NSNumber*)userID andCode:(NSString*)userCode;

+ (NSDictionary*)getNextJobFromList:(NSArray*)jobslist;

@property(nonatomic, readonly) Job *activeJob;

@end
