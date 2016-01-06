//
//  BaseEntity.h
//  Signature
//
//  Created by Iurie Manea on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject<NSCoding>

-(instancetype)initWithDictionary:(NSDictionary*)dictionaryInfo;

@end
