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
    Questions,//5
    ESABenefits,//6
    Questions1,//7
    UtilityOverpayment,
    ExploreSummary,
    SummaryOfFindingsOptions1,
    SummaryOfFindingsOptions2,//11
    SortFindings,
    ServiceOption1,
    ViewOptions,
    PlatinumOptions,
    ServiceOption2,
    
    CustomerChoice,
    AdditionalInfoPage,
    NewCustomerChoice,
    InvoicePreview,//
    EmailVerification,
    
    RepairVsService,
    RRFinalChoice,
    RROverview,
    
    TechnicianDebrief,//19
    
    SummaryOfFindings,//15
    
    DebriefReminder,//20
    
    
};

@interface TechDataModel : NSObject
@property (readwrite) TechCurrentView currentStep;
+(TechDataModel*) sharedTechDataModel;

- (NSString*) getEditJobID;
- (void) clearEditJobID;
- (void) saveEditJobID : (NSString*) jobid;
- (void) saveCurrentStep : (TechCurrentView) currentStep;
@end
