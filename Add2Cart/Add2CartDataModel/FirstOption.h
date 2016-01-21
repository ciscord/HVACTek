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
@property (nonatomic) BOOL boilers;
@property (nonatomic) BOOL ductless;
@property (nonatomic,weak) NSString *coolingValue;
@property (nonatomic, weak) NSString *heatingValue;
@property (nonatomic,weak) NSString *boilersValue;
@property (nonatomic, weak) NSString *ductlessValue;


@end
