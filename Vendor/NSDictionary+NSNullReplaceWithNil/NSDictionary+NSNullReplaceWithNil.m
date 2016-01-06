//
//  NSDictionary+NSNullReplaceWithNil.m
//  HugeList
//
//  Created by Alexei on 25.03.2014.
//  Copyright (c) 2014 HugeList. All rights reserved.
//

#import "NSDictionary+NSNullReplaceWithNil.h"

@implementation NSDictionary (NSNullReplaceWithNil)


// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key
{
     id object = [self objectForKey:key];
     if (object == [NSNull null] || !object)
     {
        return @"";
     }
     return object;
}

@end
