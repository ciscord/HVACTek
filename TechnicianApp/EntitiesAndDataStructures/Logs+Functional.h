//
//  Logs+Functional.h
//  HvacTek
//
//  Created by Dorin on 7/13/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "Logs.h"


@interface Logs(Functional)

+ (instancetype)initLogWithUserID:(NSString *)userID
                             date:(NSDate *)date
                          message:(NSString *)message
                           module:(NSString *)module
                          request:(NSString *)request
                      andResponse:(NSString *)response;


@end