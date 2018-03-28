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
    Questions1,
    UtilityOverpayment,
    ExploreSummary,
    SortFindings,
    SummaryOfFindingsOptions2,//10
    EmailVerification,
    SummaryOfFindingsOptions1,
    ESABenefits,//
    ViewOptions,
    SummaryOfFindings,//15
    CustomerChoice,
    InvoicePreview,//
    RepairVsService,
    TechnicianDebrief,//19
    DebriefReminder,//20
    ServiceOption1,
    ServiceOption2,
    PlatinumOptions,
    RROverview,
    RRFinalChoice,
    NewCustomerChoice,
    AdditionalInfoPage
    
};

@interface TechDataModel : NSObject
@property (readwrite) TechCurrentView currentStep;
+(TechDataModel*) sharedTechDataModel;

- (NSString*) getEditJobID;
- (void) clearEditJobID;
- (void) saveEditJobID : (NSString*) jobid;
- (void) saveCurrentStep : (TechCurrentView) currentStep;
@end
