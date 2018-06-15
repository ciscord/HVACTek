//
//  Add2CartData.m
//  HvacTek
//
//  Created by Admin on 6/16/18.
//  Copyright © 2018 Unifeyed. All rights reserved.
//

#import "Add2CartData.h"

@implementation Add2CartData


-(id) init {
    if (self = [super init]) {
        self.savedCarts = [[NSMutableArray alloc]init];
      
    }
    
    return self;
}
+(Add2CartData*) sharedAdd2CartData {
    static Add2CartData * sharedInstance = nil;
    
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[Add2CartData alloc] init];
        }
        
        return sharedInstance;
    }
}

@end
