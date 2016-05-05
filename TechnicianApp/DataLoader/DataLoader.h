//
//  DataLoader.h
//  Signature
//
//  Created by Iurie Manea on 11/7/14.
//  Copyright (c) 2014 EBS. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "SWAPIRequestManager.h"
#import "PricebookItem.h"
#import "NSManagedObject+CoreData.h"
#import "NSManagedObjectContext+Custom.h"
#import "NSPersistentStoreCoordinator+Custom.h"
#import "NSManagedObjectModel+KCOrderedAccessorFix.h"
#import "Job+Functional.h"
#import "User+Functional.h"
#import "CompanyItem.h"
#import "HvacTekConstants.h"
#import "UIImageView+AFNetworking.h"

//#define NSLog(...)

typedef NS_ENUM (NSInteger, QuestionType){
    qtHeating = 1,
    qtCooling,
    qtTechnician,
    qRepairVsReplace

};

typedef NS_ENUM (NSInteger, QuestionTypeAPI){
    apiqtCustomer = 1,
    apiqtTechnician = 2
};

typedef NS_ENUM (NSInteger, ServiceType){
    stPlatinum,
    stGold,
    stSilver,
    stBronze,
    stBasic
};


static UIFont *s_CalibriLight13 = nil;
static UIFont *s_CalibriLight14 = nil;
static UIFont *s_Calibri13      = nil;
static UIFont *s_Calibri14      = nil;


FOUNDATION_EXTERN NSString *kSWAPI_BASE_URL;
FOUNDATION_EXTERN NSString *kSWAPIAgentName;
FOUNDATION_EXTERN NSString *kSWAPIAgentPassword;
FOUNDATION_EXTERN NSString *kSWAPIMasterID;
FOUNDATION_EXTERN NSString *kSWAPIMode;
FOUNDATION_EXTERN NSString *kSWAPICompanyNo;
FOUNDATION_EXTERN NSString *kPricebookGroup;
FOUNDATION_EXTERN NSString *const kSWAPIUsername;
FOUNDATION_EXTERN NSString *const kSWAPIUserPassword;
FOUNDATION_EXTERN NSString *const kSWAPITerminal;
FOUNDATION_EXTERN NSString *const kSWAPIRemoteTC;


void ShowOkAlertWithTitle(NSString *title, UIViewController *parentViewController);

@interface DataLoader : AFHTTPRequestOperationManager
{
    @public
}

@property (nonatomic, strong) SWAPIRequestManager *SWAPIManager;
@property (nonatomic, strong) User                *currentUser;
@property (nonatomic, readonly) NSString          *userEmail;
@property (nonatomic, readonly) NSString          *username;
@property (nonatomic, readonly) NSString          *token;
@property (nonatomic, readonly) NSString          *userID;

@property (nonatomic, readonly) NSString *inspirationImagePath;
@property (nonatomic, readonly) NSString *inspirationSentence;

@property (nonatomic, strong) NSString *recivedSWRJobID;

@property (nonatomic, strong) NSMutableArray *iPadCommonRepairsOptions;
@property (nonatomic, strong) NSMutableArray *otherOptions;
@property (nonatomic, readonly) PricebookItem *diagnosticOnlyOption;

@property (nonatomic, readonly) CompanyItem *currentCompany;


+ (DataLoader *)sharedInstance;
+ (void)        saveOptionsLocal:(NSMutableArray *)selectedOptions;
+ (NSMutableArray *)loadLocalSavedOptions;

//------------------------------------------------------------------------------------------
#pragma mark - Login
//------------------------------------------------------------------------------------------

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                onSuccess:(void (^)(NSString *successMessage))onSuccess
                  onError:(void (^)(NSError *error))onError;


-(void)addRebatesToPortal:(NSString *)title
                   amount:(CGFloat)amount
                 included:(NSString *)included
                onSuccess:(void (^)(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd))onSuccess
                  onError:(void (^)(NSError *error))onError;

-(void)updateRebatesToPortal:(NSString *)title
                   amount:(CGFloat)amount
                 included:(NSString *)included
                rebate_id:(NSString *)rebate_id
                onSuccess:(void (^)(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd))onSuccess
                  onError:(void (^)(NSError *error))onError;

-(void)deleteRebatesFromPortalWithId:(NSString *)rebate_id
                onSuccess:(void (^)(NSString *successMessage))onSuccess
                  onError:(void (^)(NSError *error))onError;


-(void)getAdd2CartProducts:(NSURL *)reqUrl
                 onSuccess:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                   onError:(void (^)(NSError *error))onError;


-(void)getAssignmentListFromSWAPIWithJobID:(NSString*)JobID
                                 onSuccess:(void (^)(NSString *successMessage))onSuccess
                                   onError:(void (^)(NSError *error))onError;

- (void)getInspirationInfoOnSuccess:(void (^)(NSString *successMessage))onSuccess
                            onError:(void (^)(NSError *error))onError;

- (void)getQuestionsOfType:(QuestionType)questionType
                 onSuccess:(void (^)(NSArray *resultQuestions))onSuccess
                   onError:(void (^)(NSError *error))onError;

- (void)getPricebookOptionsOnSuccess:(void (^)(NSArray *iPadCommonRepairsOptions, NSArray *otherOptions, PricebookItem *diagnosticOnlyOption))onSuccess
                             onError:(void (^)(NSError *error))onError;

- (void)debriefJobWithInfo:(NSDictionary*)debriefInfo
                 onSuccess:(void (^)(NSString *message))onSuccess
                   onError:(void (^)(NSError *error))onError;


- (void)postInvoice:(NSDictionary*)InvoiceInfo
                 onSuccess:(void (^)(NSString *message))onSuccess
                   onError:(void (^)(NSError *error))onError;


//- (void)connectToSWAPIonSucces:(void (^)(NSString *message))onSuccess
//                   onError:(void (^)(NSError *error))onError;

@end
