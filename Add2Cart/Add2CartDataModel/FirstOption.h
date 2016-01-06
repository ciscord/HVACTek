//
//  FirstOption.h
//  Signature
//
//  Created by James Buckley on 20/08/2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstOption : NSObject

@property (nonatomic) BOOL cooling;
@property (nonatomic) BOOL heating;
@property (nonatomic,weak) NSString *coolingValue;
@property (nonatomic, weak) NSString *heatingValue;


@end
