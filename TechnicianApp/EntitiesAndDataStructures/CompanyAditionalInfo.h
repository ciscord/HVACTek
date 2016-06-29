//
//  CompanyAditionalInfo.h
//  HvacTek
//
//  Created by Dorin on 6/2/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyAditionalInfo : NSObject

@property (nonatomic, strong) NSString *info_description;
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *info_title;
@property (nonatomic, strong) NSString *info_url;
@property (nonatomic) BOOL isVideo;
@property (nonatomic) BOOL isPicture;


+(instancetype) companyAdditionalInfoWithID:(NSString*)info_id
                           info_description:(NSString*)info_description
                                 info_title:(NSString*)info_title
                                   info_url:(NSString*)info_url
                                    isVideo:(BOOL)isVideo
                                  isPicture:(BOOL)isPicture;


@end
