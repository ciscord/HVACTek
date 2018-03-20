//
//  TechDataModel.h
//  HvacTek
//
//  Created by Admin on 3/20/18.
//  Copyright © 2018 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TechCurrentView) {
    TechNone = -1,
    TechnicianHome,
    Dispatch,
    CustomerOverview,
    SettingAgenda,
    AgendaPicture,
    Questions,
    UtilityOverpayment,
    ExploreSummary,
    SummaryOfFindingsOptions,
    SortFindings,
    SummaryOfFindingsOptions2,
    
    SummaryOfFindingsOptions1,
    
};

@interface TechDataModel : NSObject
@property (readwrite) TechCurrentView currentStep;
+(TechDataModel*) sharedTechDataModel;

- (NSString*) getEditJobID;
- (void) clearEditJobID;
- (void) saveEditJobID : (NSString*) jobid;
- (void) saveCurrentStep : (TechCurrentView) currentStep;
@end
