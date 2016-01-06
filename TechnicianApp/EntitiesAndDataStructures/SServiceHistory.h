//
//  SServiceHistory.h
//  Signature
//
//  Created by Iurie Manea on 3/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SServiceHistory : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSString *workDone;
@property (nonatomic, strong) NSString *workSugested;

@end
