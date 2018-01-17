//
//  FirstOption.m
//  Signature
//
//  Created by James Buckley on 20/08/2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "FirstOption.h"

@implementation FirstOption
-(id) init {
    if (self = [super init]) {
        self.coolingValue = @"";
        self.heatingValue = @"";
        self.boilersValue = @"";
        self.ductlessValue = @"";
    }
    
    return self;
}

@end
