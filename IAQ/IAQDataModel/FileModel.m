//
//  FileModel+CoreDataClass.m
//  HvacTek
//
//  Created by Max on 11/22/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//
//

#import "FileModel.h"

@implementation FileModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.createAt            = [aDecoder decodeObjectForKey:@"createAt"];
        self.desString   = [aDecoder decodeObjectForKey:@"desString"];
        self.fileId         = [aDecoder decodeObjectForKey:@"fileId"];
        self.filename           = [aDecoder decodeObjectForKey:@"filename"];
        self.fullUrl            = [aDecoder decodeObjectForKey:@"fullUrl"] ;
        self.iqaId          = [aDecoder decodeObjectForKey:@"iqaId"] ;
        self.ord            = [aDecoder decodeObjectForKey:@"ord"] ;
        self.type          = [aDecoder decodeObjectForKey:@"type"] ;
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes
    [aCoder encodeObject:self.createAt               forKey:@"createAt"];
    [aCoder encodeObject:self.desString      forKey:@"desString"];
    [aCoder encodeObject:self.fileId            forKey:@"fileId"];
    [aCoder encodeObject:self.filename              forKey:@"filename"];
    [aCoder encodeObject:self.fullUrl               forKey:@"fullUrl"];
    [aCoder encodeObject:self.iqaId      forKey:@"iqaId"];
    [aCoder encodeObject:self.ord            forKey:@"ord"];
    [aCoder encodeObject:self.type              forKey:@"type"];
}

@end
