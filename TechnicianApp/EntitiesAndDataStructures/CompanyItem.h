//
//  CompanyItem.h
//  HvacTek
//
//  Created by Dorin on 1/22/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyItem : NSObject

@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *business_name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *contact_f_name;
@property (nonatomic, strong) NSString *contact_l_name;
@property (nonatomic, strong) NSString *contact_phone;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *primary_color;
@property (nonatomic, strong) NSString *secondary_color;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;


+(instancetype) companyItemWithID:(NSString*)itemID
                         address1:(NSString*)address1
                         address2:(NSString*)address2
                    business_name:(NSString *)business_name
                             city:(NSString *)city
                   contact_f_name:(NSString *)contact_f_name
                   contact_l_name:(NSString *)contact_l_name
                    contact_phone:(NSString *)contact_phone
                             logo:(NSString *)logo
                    primary_color:(NSString *)primary_color
                  secondary_color:(NSString *)secondary_color
                            state:(NSString *)state
                              zip:(NSString *)zip;

@end
