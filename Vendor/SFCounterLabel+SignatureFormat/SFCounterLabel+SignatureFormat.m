//
//  SFCounterLabel+SignatureFormat.m
//  Signature
//
//  Created by Iurie Manea on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "SFCounterLabel+SignatureFormat.h"


@implementation SFCounterLabel(SignatureFormat)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)timeFormattedStringForValue:(unsigned long long)value
{
    unsigned long long msperhour = 3600000;
    unsigned long long mspermin = 60000;
    unsigned long long secs = ((value % msperhour) % mspermin) / 1000;
    
    NSString *formattedString = [NSString stringWithFormat:@"%llu  ", secs];
   
    return formattedString;
}


@end
