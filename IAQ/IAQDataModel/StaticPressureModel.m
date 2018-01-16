//
//  HeatingStaticPressureModel.m
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "StaticPressureModel.h"

@implementation StaticPressureModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    //encode properties
    [encoder encodeObject:self.customerName forKey:@"customerName"];
    [encoder encodeObject:self.todayDate forKey:@"todayDate"];
    [encoder encodeObject:self.filterSize forKey:@"filterSize"];
    [encoder encodeObject:self.filterMervRating forKey:@"filterMervRating"];
    [encoder encodeObject:self.systemType forKey:@"systemType"];
    [encoder encodeObject:self.heatingA forKey:@"heatingA"];
    [encoder encodeObject:self.heatingB forKey:@"heatingB"];
    [encoder encodeObject:self.heatingC forKey:@"heatingC"];
    [encoder encodeObject:self.heatingD forKey:@"heatingD"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties
        self.customerName = [decoder decodeObjectForKey:@"customerName"];
        self.todayDate = [decoder decodeObjectForKey:@"todayDate"];
        self.filterSize = [decoder decodeObjectForKey:@"filterSize"];
        self.filterMervRating = [decoder decodeObjectForKey:@"filterMervRating"];
        self.systemType = [decoder decodeObjectForKey:@"systemType"];
        self.heatingA = [decoder decodeObjectForKey:@"heatingA"];
        self.heatingB = [decoder decodeObjectForKey:@"heatingB"];
        self.heatingC = [decoder decodeObjectForKey:@"heatingC"];
        self.heatingD = [decoder decodeObjectForKey:@"heatingD"];
    }
    return self;
}
@end
