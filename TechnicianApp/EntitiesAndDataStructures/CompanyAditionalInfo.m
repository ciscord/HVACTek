//
//  CompanyAditionalInfo.m
//  HvacTek
//
//  Created by Dorin on 6/2/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "CompanyAditionalInfo.h"

@implementation CompanyAditionalInfo

+(instancetype) companyAdditionalInfoWithID:(NSString*)info_id
                           info_description:(NSString*)info_description
                                 info_title:(NSString*)info_title
                                   info_url:(NSString*)info_url
                                    isVideo:(BOOL)isVideo
                                  isPicture:(BOOL)isPicture {
    
    CompanyAditionalInfo *company   = [CompanyAditionalInfo new];
    company.info_id                 = info_id;
    company.info_description        = info_description;
    company.info_title              = info_title;
    company.info_url                = info_url;
    company.isVideo                 = isVideo;
    company.isPicture               = isPicture;
    return company;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.info_id            = [aDecoder decodeObjectForKey:@"info_id"];
        self.info_description   = [aDecoder decodeObjectForKey:@"info_description"];
        self.info_title         = [aDecoder decodeObjectForKey:@"info_title"];
        self.info_url           = [aDecoder decodeObjectForKey:@"info_url"];
        self.isVideo            = [[aDecoder decodeObjectForKey:@"isVideo"] boolValue];
        self.isPicture          = [[aDecoder decodeObjectForKey:@"isPicture"] boolValue];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes
    [aCoder encodeObject:self.info_id               forKey:@"info_id"];
    [aCoder encodeObject:self.info_description      forKey:@"info_description"];
    [aCoder encodeObject:self.info_title            forKey:@"info_title"];
    [aCoder encodeObject:self.info_url              forKey:@"info_url"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isVideo] forKey:@"isVideo"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPicture] forKey:@"isPicture"];
}


@end
