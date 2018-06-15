//
//  Add2CartData.h
//  HvacTek
//
//  Created by Admin on 6/16/18.
//  Copyright © 2018 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Add2CartData : NSObject
@property (nonatomic, strong)  NSMutableArray *savedCarts;

+(Add2CartData*) sharedAdd2CartData;
@end
