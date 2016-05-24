//
//  StringBetweenStrings.m
//  HvacTek
//
//  Created by Dorin on 5/24/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "StringBetweenStrings.h"

@implementation NSString (NSAddition)

- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

@end
