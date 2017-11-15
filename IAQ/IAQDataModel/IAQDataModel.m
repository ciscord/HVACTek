//
//  IAQDataModel.m
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "IAQDataModel.h"

@implementation IAQDataModel
-(id) init {
    if (self = [super init]) {
        self.iaqProductsArray = [NSMutableArray array];
        self.heatingStaticPressure = [[StaticPressureModel alloc] init];
        self.coolingStaticPressure = [[StaticPressureModel alloc] init];
    }
    
    return self;
}
+(IAQDataModel*) sharedIAQDataModel {
    static IAQDataModel * sharedInstance = nil;
    
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[IAQDataModel alloc] init];
        }
        
        return sharedInstance;
    }
}
@end
