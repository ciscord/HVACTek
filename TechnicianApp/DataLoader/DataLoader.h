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
#import "Logs+Functional.h"


//#define NSLog(...)
typedef NS_ENUM (NSInteger, OptionsDisplayType){
    odtEditing,
    odtNoValues,
    odtReadonlyWithPrice,
    odtCustomerFinalChoice
};

typedef NS_ENUM (NSInteger, QuestionType){
    qtHeating = 1,
    qtCooling,
    qtTechnician,
    qRepairVsReplace,
    qtPlumbing

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
@property (nonatomic, strong) CompanyItem   *currentCompany;
@property (nonatomic, readonly) NSString          *userEmail;
@property (nonatomic, readonly) NSString          *username;
@property (nonatomic, readonly) NSString          *token;
@property (nonatomic, readonly) NSString          *userID;

@property (nonatomic, readonly) NSString *inspirationImagePath;
@property (nonatomic, readonly) NSString *inspirationSentence;

@property (nonatomic, strong) NSString *recivedSWRJobID;

@property (nonatomic, strong) NSMutableArray *iPadCommonRepairsOptions;
@property (nonatomic, strong) NSMutableArray *otherOptions;
@property (nonatomic, strong) NSMutableArray *plumbingCommonRepairsOptions;
@property (nonatomic, strong) NSMutableArray *plumbingOtherOptions;
@property (nonatomic, strong) NSArray *companyAdditionalInfo;

@property (nonatomic, assign) QuestionType currentJobCallType;

@property (nonatomic, readonly) PricebookItem *diagnosticOnlyOption;

+ (DataLoader *)sharedInstance;

+ (void)    saveOptionsLocal:(NSMutableArray *)selectedOptions;
+ (NSMutableArray *)loadLocalSavedOptions;

+ (void)    saveFindingOptionsLocal:(NSMutableArray*)selectedOptions;
+ (NSMutableArray*) loadLocalSavedFindingOptions;

+ (void)    savePriceBookAndServiceOptionsLocal:(NSMutableArray*)selectedOptions;
+ (NSMutableArray*) loadLocalPriceBookAndServiceOptions;

+ (void)    saveFinalOptionsLocal:(NSMutableArray*)selectedOptions;
+ (NSMutableArray*) loadLocalFinalOptions;
+ (void) removeLocalFinalOptions;

+ (void) saveCustomerChoiceData:(NSDictionary*)customerChoiceData;
+ (NSDictionary*)loadLocalCustomerChoiceData;

+ (void) saveAdditionalInfo:(NSDictionary*)customerChoiceData;
+(NSDictionary*)loadLocalAdditionalInfo;

+ (void) saveNewCustomerChoice:(NSDictionary*)customerChoiceData;
+(NSDictionary*)loadLocalNewCustomerChoice;

+ (void) saveOptionsDisplayType : (OptionsDisplayType) currentType;

+ (OptionsDisplayType) loadOptionsDisplayType;

+ (void) saveQuestionType : (QuestionType) currentType;

+ (QuestionType) loadQuestionType;

+ (void) clearAllLocalData;

+ (void)saveOptions;
+ (void)loadOptions;

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


-(void)getAdd2CartProducts:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                   onError:(void (^)(NSError *error))onError;

-(void)add2cartFinancials:(NSDictionary *) parameters
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


- (void)postInvoice:(NSDictionary*)InvoiceInfo requestingPreview:(int)previewInt
                 onSuccess:(void (^)(NSString *message))onSuccess
                   onError:(void (^)(NSError *error))onError;



- (void)getAdditionalInfoOnSuccess:(void (^)(NSDictionary *infoDict))onSuccess
                             onError:(void (^)(NSError *error))onError;



//- (void)connectToSWAPIonSucces:(void (^)(NSString *message))onSuccess
//                   onError:(void (^)(NSError *error))onError;

- (void)checkSyncStatusForAdd2Cart:(BOOL)isAdd2Cart
                         onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                         onError:(void (^)(NSError *error))onError;



- (void)updateStatusForAdditionalInfoOnSuccess:(void (^)(NSString *message))onSuccess
                                       onError:(void (^)(NSError *error))onError;


- (void)sendLogs:(NSArray *)logs
       onSuccess:(void (^)(NSString *message))onSuccess
        onError:(void (^)(NSError *error))onError;
//------------------------------------------------------------------------------------------
#pragma mark - IAQ
//------------------------------------------------------------------------------------------
-(void)getIAQProducts:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                   onError:(void (^)(NSError *error))onError;

-(void)emailIaqAuthorizeSale:(NSString *)authid
                       email:(NSString*)email
                   onSuccess:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                     onError:(void (^)(NSError *error))onError;
    
-(void)addIaqAuthorizeSale:(NSString *)products
                  customer:(NSString*)customer
                technician:(NSString*)technician
                     price:(CGFloat)price
                 signature:(NSString*)signature
                 onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                   onError:(void (^)(NSError *error))onError;

-(void)addIaqAuthorizeSaleUnapproved:(NSString *)products
                            customer:(NSString*)customer
                          technician:(NSString*)technician
                               price:(CGFloat)price
                           onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                             onError:(void (^)(NSError *error))onError;

-(void)getMainVideo: (void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
            onError:(void (^)(NSError *error))onError;
//------------------------------------------------------------------------------------------
#pragma mark - Timer
//------------------------------------------------------------------------------------------
-(void)startTimeWithJobId:(NSString *)jobId
                onSuccess:(void (^)(NSString *successMessage))onSuccess
                  onError:(void (^)(NSError *error))onError;
-(void)pauseTimeWithJobId:(NSString *)jobId
                onSuccess:(void (^)(NSString *successMessage))onSuccess
                  onError:(void (^)(NSError *error))onError;
@end
