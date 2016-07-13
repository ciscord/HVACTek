//
//  NSDate+Utilities.m
//  HvacTek
//
//  Created by Dorin on 7/13/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (NSString *)stringFromDate;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    return [dateFormatter stringFromDate:self];
}

@end