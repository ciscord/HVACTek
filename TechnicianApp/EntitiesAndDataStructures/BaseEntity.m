//
//  BaseEntity.m
//  Signature
//
//  Created by Iurie Manea on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

-(instancetype)initWithDictionary:(NSDictionary*)dictionaryInfo
{
    self = [super init];
    // Override in descending classes
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes
}

@end
