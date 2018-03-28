//
//  TechDataModel.m
//  HvacTek
//
//  Created by Admin on 3/20/18.
//  Copyright © 2018 Unifeyed. All rights reserved.
//

#import "TechDataModel.h"

@implementation TechDataModel

-(id) init {
    if (self = [super init]) {
        
    }
    
    return self;
}
+(TechDataModel*) sharedTechDataModel {
    static TechDataModel * sharedInstance = nil;
    
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[TechDataModel alloc] init];
        }
        
        return sharedInstance;
    }
}

- (NSString*) getEditJobID {
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    return [userdefault objectForKey:@"editjobid"];
}

- (void) clearEditJobID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"editjobid"];
}

- (void) saveEditJobID : (NSString*) jobid{
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:jobid forKey:@"editjobid"];
    [userdefault synchronize];
}

- (void) saveCurrentStep : (TechCurrentView) currentStep {
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:[NSNumber numberWithInteger:currentStep]  forKey:@"techCurrentStep"];
    [userdefault synchronize];

}
@end
