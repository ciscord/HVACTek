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

- (void) saveHeatingStaticPressure {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.heatingStaticPressure];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"heatingStaticPressure"];
    [defaults synchronize];
}

- (void) loadHeatingStaticPressure {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"heatingStaticPressure"];
    self.heatingStaticPressure = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

- (void) saveCoolingStaticPressure {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.coolingStaticPressure];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"coolingStaticPressure"];
    [defaults synchronize];
}

- (void) loadCoolingStaticPressure {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"coolingStaticPressure"];
    self.coolingStaticPressure = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}
/*
 resetAllData is called when Authorize or Email success.
 */
- (void) resetAllData {
    self.isfinal = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"heatingStaticPressure"];
    [defaults removeObjectForKey:@"coolingStaticPressure"];
    [defaults removeObjectForKey:@"iaqCurrentStep"];
    [defaults removeObjectForKey:@"iaqSortedProductsIdArray"];
    [defaults removeObjectForKey:@"iaqSortedProductsQuantityArray"];
    [defaults removeObjectForKey:@"iaqBestProductsIdArray"];
    [defaults removeObjectForKey:@"iaqBetterProductsIdArray"];
    [defaults removeObjectForKey:@"iaqGoodProductsIdArray"];
    [defaults removeObjectForKey:@"airPurification"];
    [defaults removeObjectForKey:@"humidification"];
    [defaults removeObjectForKey:@"airFiltration"];
    [defaults removeObjectForKey:@"dehumidification"];
    [defaults removeObjectForKey:@"isfinal"];
    [defaults synchronize];
}

@end
