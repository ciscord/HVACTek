//
//  DataLoader.m
//  Signature
//
//  Created by Iurie Manea on  11/7/14.
//  Copyright (c) 2014 EBS. All rights reserved.
//

#import "DataLoader.h"
#import <CommonCrypto/CommonHMAC.h>
#import <MD5Digest/NSString+MD5.h>
#import "Question.h"
#import <XMLDictionary/XMLDictionary.h>

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))



#define DEVELOPMENT

#ifdef DEVELOPMENT // development
//  @"http://www.hvactek.com/api/"
#define BASE_URL                    @"http://staging.unifeyed.com/hvactek/api/"//@"http://hvactek.devebs.net/api/"
NSString *const API_KEY             = @"12b5401c039fe55e8df6304d8fcc121e";
NSString *const API_SECRET_KEY      = @"Fab5F6286sig754133874o";

NSString *kSWAPI_BASE_URL     = @"https://swapidev.successware21.com:2143";
NSString *kSWAPIAgentName     = @"SIG01";
NSString *kSWAPIAgentPassword = @"Signature01";
NSString *kSWAPIMasterID      = @"02364";
NSString *kSWAPIMode          = @"tutorial";
NSString *kSWAPICompanyNo     = @"1001";
NSString *kPricebookGroup     = @"SERVICE APP";
//    NSString *const kSWAPIUsername      = @"agt_SIG01";
//    NSString *const kSWAPIUserPassword  = @"Signature01";
NSString *const kSWAPITerminal      = @"0";
NSString *const kSWAPIRemoteTC      = @"0";

#else // production

#define BASE_URL                    @"http://www.hvactek.com/api/"
NSString *const API_KEY             = @"12b5401c039fe55e8df6304d8fcc121e";
NSString *const API_SECRET_KEY      = @"Fab5F6286sig754133874o";

NSString *kSWAPI_BASE_URL     = @"https://swapidev.successware21.com:2143";
NSString *kSWAPIAgentName     = @"SIG01";
NSString *kSWAPIAgentPassword = @"Signature01";
NSString *kSWAPIMasterID      = @"02364";
NSString *kSWAPIMode          = @"live";
NSString *kSWAPICompanyNo     = @"1001";
NSString *kPricebookGroup     = @"SERVICE APP";
//    NSString *const kSWAPIUsername      = @"agt_SIG01";
//    NSString *const kSWAPIUserPassword  = @"Signature01";
NSString *const kSWAPITerminal      = @"0";
NSString *const kSWAPIRemoteTC      = @"0";

#endif


NSString *const USER_LOGIN       = @"auth";
NSString *const INSPIRATION      = @"inspiration";
NSString *const QUESTIONS        = @"questions";
NSString *const PRICEBOOK        = @"pricebook";
NSString *const DEBRIEF          = @"addDebrief";
NSString *const SURVEY           = @"saveSurvey";
NSString *const INVOICE          = @"emailInvoice";
NSString *const ADD_REBATES      = @"addRebate";
NSString *const DELETE_REBATES   = @"deleteRebate";
NSString *const UPDATE_REBATES   = @"updateRebate";
NSString *const ADD2CART_ITEMS   = @"add2cart";
NSString *const ADDITIONAL_INFO  = @"getAdditionalInfo";
NSString *const SYNC_STATUS      = @"add2cart_sync_status";
NSString *const SYNC_STATUS2     = @"add2cart_sync_status/2";
NSString *const SYNC_MODIFY      = @"do_add2cart_sync/2";
NSString *const LOGS             = @"addError";
NSString *const IAQPRODUCTS      = @"iaqProducts";
NSString *const GETMAINVIDEO      = @"getMainVideo";
NSString *const ADDIAQAUTHORIZESALE                 = @"addIaqAuthorizeSale";
NSString *const ADDIAQAUTHORIZESALEUNAPPROVED       = @"addIaqAuthorizeSaleUnapproved";
NSString *const EMAILIAQAUTHORIZESALE               = @"emailIaqAuthorizeSale";
NSString *const ADD2CARTFINANCIALS                  = @"add2cartFinancials";
#define kStatusOK 1



@interface DataLoader ()

@property (nonatomic, copy) NSDictionary    *userInfo;
@property (nonatomic, copy) NSDictionary    *inspirationInfo;
@property (nonatomic, strong) NSMutableArray *iPadCommonRepairsOptionsLocal;
@property (nonatomic, strong) NSMutableArray *otherOptionsLocal;
@property (nonatomic, strong) PricebookItem *diagnosticOnlyOption;
@property (nonatomic, strong) CompanyItem   *currentCompany;
@property (readwrite) BOOL hasInternet;
@end

@implementation DataLoader

+ (DataLoader *)sharedInstance {
    static DataLoader *s_dl_instance;
    @synchronized(self){
        if (!s_dl_instance) {
            s_dl_instance = [[DataLoader alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        }
    }
    return(s_dl_instance);
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.hasInternet = (status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown);
            
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [self.requestSerializer setValue:API_KEY forHTTPHeaderField:@"API-KEY"];
        
    }
    return self;
}

+ (NSData *)hmacForKey:(NSString *)key andData:(NSString *)data {
    const char    *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char    *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

+ (void) clearAllLocalData {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"selectedOptions"];
    [defaults removeObjectForKey:@"selectedFindingOptions"];
    [defaults removeObjectForKey:@"priceBookAndServiceOptions"];
    [defaults removeObjectForKey:@"FinalOptions"];
    [defaults removeObjectForKey:@"CustomerChoiceData"];
    [defaults removeObjectForKey:@"AdditionalInfo"];
    [defaults removeObjectForKey:@"NewCustomerChoice"];
    [defaults synchronize];
    
    [[[DataLoader sharedInstance] currentUser] deleteActiveJob];
    
}
+ (void)saveOptionsLocal:(NSMutableArray*)selectedOptions {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedOptions];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"selectedOptions"];
    [defaults synchronize];
    
}

+ (void) saveOptionsDisplayType : (OptionsDisplayType) currentType {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:currentType] forKey:@"OptionsDisplayType"];
 
    [defaults synchronize];
}

+ (OptionsDisplayType) loadOptionsDisplayType {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"OptionsDisplayType"]) {
        return [[defaults objectForKey:@"OptionsDisplayType"] integerValue];
    }else
        return odtEditing;
    
}

+ (void) saveQuestionType : (QuestionType) currentType {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:currentType] forKey:@"QuestionType"];
    
    [defaults synchronize];
}

+ (QuestionType) loadQuestionType {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"QuestionType"]) {
        return [[defaults objectForKey:@"QuestionType"] integerValue];
    }else
        return qtHeating;
    
}

+ (NSMutableArray*)loadLocalSavedOptions {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedOptions"];
    NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    NSMutableArray *selectedOptions = [NSMutableArray arrayWithArray:notes];
    return selectedOptions;
}

+ (void)saveFindingOptionsLocal:(NSMutableArray*)selectedOptions {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedOptions];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"selectedFindingOptions"];
    [defaults synchronize];
    
}

+ (NSMutableArray*)loadLocalSavedFindingOptions {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedFindingOptions"];
    NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    NSMutableArray *selectedOptions = [NSMutableArray arrayWithArray:notes];
    return selectedOptions;
}

+ (void)savePriceBookAndServiceOptionsLocal:(NSMutableArray*)selectedOptions {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedOptions];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"priceBookAndServiceOptions"];
    [defaults synchronize];
    
}

+(NSMutableArray*)loadLocalPriceBookAndServiceOptions {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"priceBookAndServiceOptions"];
    NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    NSMutableArray *selectedOptions = [NSMutableArray arrayWithArray:notes];
    return selectedOptions;
}
+ (void)saveFinalOptionsLocal:(NSMutableArray*)selectedOptions {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedOptions];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"FinalOptions"];
    [defaults synchronize];
    
}

+(NSMutableArray*)loadLocalFinalOptions {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FinalOptions"];
    NSArray *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    NSMutableArray *selectedOptions = [NSMutableArray arrayWithArray:notes];
    return selectedOptions;
}

+ (void) saveCustomerChoiceData:customerChoiceData {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:customerChoiceData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"CustomerChoiceData"];
    [defaults synchronize];
}

+(NSDictionary*)loadLocalCustomerChoiceData {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomerChoiceData"];
    NSDictionary *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    return notes;
}

+ (void) saveAdditionalInfo:customerChoiceData {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:customerChoiceData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"AdditionalInfo"];
    [defaults synchronize];
}

+(NSDictionary*)loadLocalAdditionalInfo {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AdditionalInfo"];
    NSDictionary *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    return notes;
}

+ (void) saveNewCustomerChoice:customerChoiceData {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:customerChoiceData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"NewCustomerChoice"];
    [defaults synchronize];
}

+(NSDictionary*)loadLocalNewCustomerChoice {
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewCustomerChoice"];
    NSDictionary *notes = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    return notes;
}



- (void)showErrorMessage:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//------------------------------------------------------------------------------------------
#pragma mark - HTTP Get/Post methods
//------------------------------------------------------------------------------------------

- (NSError *)noInternetConnectionError {
    static NSError *s_error;
    @synchronized(self){
        if (!s_error) {
            s_error = [[NSError alloc] initWithDomain:@"No Internet Connection" code:404 userInfo:@{ NSLocalizedDescriptionKey : @"Please check your internet connection or try again later." }];
        }
    }
    
    return s_error;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (self.hasInternet) {
        return [super GET:URLString parameters:parameters success:success failure:failure];
    } else {
        [self showErrorMessage:[self noInternetConnectionError]];
        if (failure) {
            failure(nil, [self noInternetConnectionError]);
        }
    }
    return nil;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (self.hasInternet) {
        
        return [super POST:URLString parameters:parameters success:success failure:failure];
    } else {
        [self showErrorMessage:[self noInternetConnectionError]];
        if (failure) {
            failure(nil, [self noInternetConnectionError]);
        }
    }
    return nil;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  //  NSLog(@"%@", error)
    if (self.hasInternet) {
        return [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
    } else {
        [self showErrorMessage:[self noInternetConnectionError]];
        if (failure) {
            failure(nil, [self noInternetConnectionError]);
        }
    }
    return nil;
}

//------------------------------------------------------------------------------------------
#pragma mark - User info wrappers
//------------------------------------------------------------------------------------------

- (NSString *)userEmail {
    return self.userInfo[@"email"];
}

- (NSString *)username {
    return self.userInfo[@"username"];
}

- (NSString *)userID {
    return self.userInfo[@"id"];
}

- (NSString *)token {
    return self.userInfo[@"token"];
}

//------------------------------------------------------------------------------------------
#pragma mark - Inspiration info wrappers
//------------------------------------------------------------------------------------------

- (NSString *)inspirationImagePath {
    return self.inspirationInfo[@"filename"];
}

- (NSString *)inspirationSentence {
    return self.inspirationInfo[@"sentence"];
}

//------------------------------------------------------------------------------------------
#pragma mark - Account swapi connect
//------------------------------------------------------------------------------------------
//- (void)connectToSWAPIonSucces:(void (^)(NSString *message))onSuccess
//                       onError:(void (^)(NSError *error))onError{
//    
//    __weak typeof(self) weakSelf = self;
//    weakSelf.SWAPIManager = [SWAPIRequestManager sharedInstance];
//    weakSelf.SWAPIManager.SWAPIUserCode = weakSelf.currentUser.userCode;
//    weakSelf.SWAPIManager.SWAPIUsername = weakSelf.currentUser.userName;
//    weakSelf.SWAPIManager.SWAPIUserPassword = weakSelf.currentUser.password;
//    weakSelf.SWAPIManager.SWAPIUserPassword = weakSelf.currentUser.password;
//    
//    [weakSelf.SWAPIManager connectOnSuccess:^(NSString *successMessage) {
//        onSuccess(@"OK");
//    } onError:^(NSError *error) {
//        onError(error);
//    }];
//    
//};

//------------------------------------------------------------------------------------------
#pragma mark - Account API methods(Create, Login, GetUserInfo, Logout...)
//------------------------------------------------------------------------------------------

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                onSuccess:(void (^)(NSString *successMessage))onSuccess
                  onError:(void (^)(NSError *error))onError {
    
    NSString        *md5String         = [[username stringByAppendingString:password] MD5Digest];
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH"];
    dateTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    md5String                  = [md5String stringByAppendingString:[dateTimeFormatter stringFromDate:[NSDate date]]];
    NSData   *hmacData  = [DataLoader hmacForKey:API_SECRET_KEY andData:md5String];
    NSString *signature = [hmacData base64EncodedStringWithOptions:0];     //[[NSString alloc] initWithData:hmacData encoding:NSASCIIStringEncoding];
    
    __weak typeof(self) weakSelf = self;
      NSLog(@"%@",signature);
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    //self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [self POST:USER_LOGIN
    parameters:@{ @"email":username, @"password":password, @"signature":signature }
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               weakSelf.userInfo = responseObject[@"results"];
               
               NSLog(@"weakSelf.userInfo: %@",weakSelf.userInfo);
               NSDictionary *companyDict = [weakSelf.userInfo objectForKey:@"business"];
               
               NSDictionary *swapiDict = weakSelf.userInfo[@"swapi"];
               
               self.currentCompany = [CompanyItem companyItemWithID:companyDict[@"id"]
                                                           address1:companyDict[@"address1"]
                                                           address2:companyDict[@"address2"]
                                                           admin_id:companyDict[@"admin_id"]
                                                      business_name:companyDict[@"business_name"]
                                                               city:companyDict[@"city"]
                                                     contact_f_name:companyDict[@"contact_f_name"]
                                                     contact_l_name:companyDict[@"contact_l_name"]
                                                      contact_phone:companyDict[@"contact_phone"]
                                                            deleted:companyDict[@"deleted"]
                                                               logo:companyDict[@"logo"]
                                                      primary_color:companyDict[@"primary_color"]                           //companyDict[@"primary_color"]   @"#4690CD"
                                                    secondary_color:companyDict[@"secondary_color"]                           //companyDict[@"secondary_color"]  @"#EE4236"
                                                              state:companyDict[@"state"]
                                                           swapi_id:companyDict[@"swapi_id"]
                                                                zip:companyDict[@"zip"]
                                                  plumbing_category:swapiDict[@"plumbing_category"]
                                                     plumbing_group:swapiDict[@"plumbing_group"]
                                                         isPlumbing:[companyDict[@"plumbing"] boolValue]];

               
               weakSelf.currentUser = [User userWithName:[swapiDict objectForKey:@"username"] userID:@([weakSelf.userInfo[@"id"] integerValue]) andCode:weakSelf.userInfo[@"code"]];
               weakSelf.currentUser.add2cart =[NSNumber numberWithBool:([weakSelf.userInfo[@"add2cart"] intValue]==1)] ;
               weakSelf.currentUser.tech = [NSNumber numberWithBool:([weakSelf.userInfo[@"tech"] intValue]==1)];
               weakSelf.currentUser.password = swapiDict[@"password"];
               weakSelf.currentUser.firstName = weakSelf.userInfo[@"firstname"];
               weakSelf.currentUser.lastName = weakSelf.userInfo[@"lastname"];
               [weakSelf.currentUser.managedObjectContext save];
               
               [weakSelf.requestSerializer setValue:weakSelf.userInfo[@"token"] forHTTPHeaderField:@"TOKEN"];
               
               NSString *port = [swapiDict objectForKey:@"port"];
               NSString *urlString = [swapiDict objectForKey:@"url"];
               NSString *baseString =  [NSString stringWithFormat:@"%@:%@",urlString, port];
               
               kSWAPI_BASE_URL     = baseString;
               kSWAPIAgentName     = [swapiDict objectForKey:@"agent_name"];
               kSWAPIAgentPassword = [swapiDict objectForKey:@"agent_password"];
               kSWAPIMasterID      = [swapiDict objectForKey:@"masterID"];
               kSWAPICompanyNo     = [swapiDict objectForKey:@"company_number"];
               kPricebookGroup     = [swapiDict objectForKey:@"pricebook_group"];
               
               self.SWAPIManager = [SWAPIRequestManager sharedInstance];
               
               onSuccess(@"OK");
               
               // [weakSelf getAssignmentListFromSWAPIonSuccess:onSuccess onError:onError];
               
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
                NSLog(@"%@",responseObject);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@",error);
           if (onError) {
               onError(error);
           }
       }];
}

-(void)getAssignmentListFromSWAPIWithJobID:(NSString*)JobID
                                 onSuccess:(void (^)(NSString *successMessage))onSuccess
                                   onError:(void (^)(NSError *error))onError {

    self.SWAPIManager.SWAPIUserCode = self.currentUser.userCode;
    self.SWAPIManager.SWAPIUsername = self.currentUser.userName;
    self.SWAPIManager.SWAPIUserPassword = self.currentUser.password;
    [self.SWAPIManager connectOnSuccess:^(NSString *successMessage) {
        [self.SWAPIManager assignmentListQueryForEmployee:self.SWAPIManager.SWAPIUserCode
                                                withJobID:JobID
                                                    onSuccess:^(NSString *successMessage) {
                                                        
//                                                        if (self.SWAPIManager.currentJob && !self.currentUser.activeJob) {
//                                                            [Job jobWithDictionnary:self.SWAPIManager.currentJob forUser:self.currentUser];
//                                                        }
                                                        
                                                        [Job jobWithDictionnary:self.SWAPIManager.currentJob forUser:self.currentUser];

                                                        
                                                        [self getInspirationInfoOnSuccess:^(NSString *successMessage) {
                                                        } onError:^(NSError *error) {
                                                            if (onError) {
                                                                onError(error);
                                                            }
                                                        }];
                                                        
                                                        
                                                        [self getPricebookOptionsOnSuccess:^(NSArray *iPadCommonRepairsOptions, NSArray *otherOptions, PricebookItem *diagnosticOnlyOption) {
                                                            
                                                            if (onSuccess) {
                                                                onSuccess(@"OK");
                                                            }
                                                        } onError:^(NSError *error) {
                                                            if (onError) {
                                                                onError(error);
                                                            }
                                                        }];
                                                        
                                                    } onError:^(NSError *error) {
                                                        if (onError) {
                                                            onError(error);
                                                        }
                                                    }];
    } onError:^(NSError *error) {
        if (onError) {
            onError(error);
        }
    }];
}


- (void)getInspirationInfoOnSuccess:(void (^)(NSString *successMessage))onSuccess
                            onError:(void (^)(NSError *error))onError {
    //    id={inspiration_id}&page=0&limit=20&order=title,asc&api¬_key={api_key}
    __weak typeof(self) weakSelf = self;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [self GET:INSPIRATION
   parameters:@{ @"api_key" : API_KEY }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSMutableDictionary *info = [[responseObject[@"results"] objectAtIndex:(RAND_FROM_TO(0, [responseObject[@"results"] count]-1))] mutableCopy];
              if ([info[@"filename"] length]) {
                  //                 info[@"filename"] = [UPLOADS_BASE_URL stringByAppendingString:info[@"filename"]];
                  UIImageView *img = [[UIImageView alloc] init];
                  [img setImageWithURL:[NSURL URLWithString:info[@"filename"]]];
              }
            
            NSLog(@"getInspirationInfoOnSuccess: %@",info.description);
            
              weakSelf.inspirationInfo = info;
              [[[UIImageView alloc] init] setImageWithURL:[NSURL URLWithString:[weakSelf inspirationImagePath]] placeholderImage:nil];
              if (onSuccess) {
                  onSuccess(responseObject[@"message"]);
              }
          }
          else if (onError)
          {
              NSError *error = [NSError errorWithDomain:@"API Error" code:12345 userInfo:@{NSLocalizedDescriptionKey : responseObject[@"message"]}];
              [self showErrorMessage:error];
              onError(error);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
          if (onError) {
              onError(error);
          }
      }];
}

- (void)getQuestionsOfType:(QuestionType)questionType
                 onSuccess:(void (^)(NSArray *resultQuestions))onSuccess
                   onError:(void (^)(NSError *error))onError {
    //    type={type_id}&group={group_id}&api¬_key={api_key}
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [self GET:QUESTIONS
   parameters:@{ @"type" : @(questionType), @"api_key" : API_KEY }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSArray *questionsInfo = responseObject[@"results"];
              NSMutableArray *resultQuestions = @[].mutableCopy;
              for (NSDictionary *questionInfo in questionsInfo) {
                  Question *q = [[Question alloc] initWithDictionary:questionInfo];
                  [resultQuestions addObject:q];
              }
              
              if (onSuccess) {
                  onSuccess(resultQuestions);
              }
          }
          else if (onError)
          {
              NSError *error = [NSError errorWithDomain:@"API Error" code:12345 userInfo:@{NSLocalizedDescriptionKey : responseObject[@"message"]}];
              [self showErrorMessage:error];
              onError(error);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
          if (onError) {
              onError(error);
          }
      }];
}
//ItemGroup = "SERVICE APP

/*
 "plumbing_category" = "SCHNELLER PLBG";
 "plumbing_group" = "";
 
 "pricebook_category" = "SCHNELLER HVAC";
 "pricebook_group" = "SERVICE APP";
 */

- (NSNumber *)roundNumber:(NSNumber *)number {
    NSNumber *roundedNumber = [NSNumber numberWithFloat: ceilf(number.floatValue)];
    return roundedNumber;
}

#pragma mark - Get PriceBook
- (void)getPricebookOptionsOnSuccess:(void (^)(NSArray *iPadCommonRepairsOptions, NSArray *otherOptions, PricebookItem *diagnosticOnlyOption))onSuccess
                             onError:(void (^)(NSError *error))onError {
    //    type={type_id}&group={group_id}&api¬_key={api_key}
    __weak typeof (self) weakSelf = self;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    [self GET:PRICEBOOK
   parameters:@{ @"api_key" : API_KEY }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSDictionary *d = [NSDictionary dictionaryWithXMLData:responseObject];
          NSArray *pricebook = d[@"PricebookTaskQueryData"][@"PricebookTaskQueryRecord"];
          NSMutableArray *iPadCommonRepairsOptions = @[].mutableCopy;
          NSMutableArray *otherOptions = @[].mutableCopy;
          NSMutableArray *plumbingCommonRepairsOptions  = @[].mutableCopy;
          NSMutableArray *plumbingOtherOptions  = @[].mutableCopy;
          
          
          for (NSDictionary *pricebookInfo in pricebook) {
              PricebookItem *p = [PricebookItem pricebookWithID:pricebookInfo[@"ItemID"]
                                                     itemNumber:pricebookInfo[@"ItemNumber"]
                                                      itemGroup:pricebookInfo[@"ItemGroup"]
                                                   itemCategory:pricebookInfo[@"ItemCategory"]
                                                           name:pricebookInfo[@"Description"]
                                                       quantity:@""
                                                         amount:[self roundNumber:@([pricebookInfo[@"TaskTotalPrice"] floatValue] * 0.85)]
                                                   andAmountESA:[self roundNumber:@([pricebookInfo[@"TaskTotalPrice"] floatValue])]];
              
              
//              if ([p.itemGroup isEqualToString:kPricebookGroup]) {
//                  if (self.currentCompany.isPlumbing) {
//                      if ([p.itemCategory isEqualToString:self.currentCompany.plumbing_category])
//                          [plumbingCommonRepairsOptions addObject:p];
//                      else
//                          [iPadCommonRepairsOptions addObject:p];
//                  }else{
//                      [iPadCommonRepairsOptions addObject:p];
//                  }
//              }
//              else {
//                  if (self.currentCompany.isPlumbing) {
//                      if ([p.itemCategory isEqualToString:self.currentCompany.plumbing_category])
//                          [plumbingOtherOptions addObject:p];
//                      else
//                          [otherOptions addObject:p];
//                  }else{
//                      [otherOptions addObject:p];
//                  }
//              }
              
              
    /////////////////////////////////
              if (self.currentCompany.isPlumbing) {
                  if ([p.itemGroup isEqualToString:kPricebookGroup])
                      [iPadCommonRepairsOptions addObject:p];
                  else
                      [otherOptions addObject:p];
                  
                  if ([p.itemGroup isEqualToString:self.currentCompany.plumbing_group])
                      [plumbingCommonRepairsOptions addObject:p];
                  else
                      [plumbingOtherOptions addObject:p];
              }else{
                  if ([p.itemGroup isEqualToString:kPricebookGroup])
                      [iPadCommonRepairsOptions addObject:p];
                  else
                      [otherOptions addObject:p];
              }
              
              // Diagnostic Only item
              if ([p.itemNumber isEqualToString:@"1003001"]) {
                  weakSelf.diagnosticOnlyOption = p;
              }
          }
          weakSelf.iPadCommonRepairsOptions = iPadCommonRepairsOptions;
          weakSelf.otherOptions = otherOptions;
          weakSelf.plumbingCommonRepairsOptions = plumbingCommonRepairsOptions;
          weakSelf.plumbingOtherOptions = plumbingOtherOptions;
          
          if (onSuccess) {
              onSuccess(weakSelf.iPadCommonRepairsOptions, weakSelf.otherOptions, weakSelf.diagnosticOnlyOption);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
          if (onError) {
              onError(error);
          }
      }];
}

#pragma mark - Debrief Job
- (void)debriefJobWithInfo:(NSDictionary*)debriefInfo
                 onSuccess:(void (^)(NSString *message))onSuccess
                   onError:(void (^)(NSError *error))onError {
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    
    NSArray * questions = self.currentUser.activeJob.custumerQuestions;
    NSMutableArray * custumerQuestions = [[NSMutableArray alloc]init];
    for (Question *q in questions) {
        [custumerQuestions addObject:@{[NSString stringWithFormat:@"%i",[q.ID intValue]]   : q.answer}];
    }
    
    questions = self.currentUser.activeJob.techObservations;
    NSMutableArray * techObservations = [[NSMutableArray alloc]init];
    for (Question *q in questions) {
        [techObservations addObject:@{[NSString stringWithFormat:@"%i",[q.ID intValue]]: q.answer}];
    }
  
    questions = self.currentUser.activeJob.rrQuestions;
    NSMutableArray * rrObservations = [[NSMutableArray alloc]init];
    for (Question *q in questions) {
        [rrObservations addObject:@{[NSString stringWithFormat:@"%i",[q.ID intValue]]: q.answer}];
    }
    
    [temp setObject:@{@"1" : custumerQuestions, @"2" : techObservations, @"3" : rrObservations} forKey:@"questions"];
  
    NSArray * options = self.currentUser.activeJob.selectedServiceOptions;
    NSMutableArray * selectedServiceOptions = [[NSMutableArray alloc]init];
    for (PricebookItem *q in options) {
        if (q.itemID && q.name) {
        [selectedServiceOptions addObject:@{q.itemID: q.name}];
        }
    }
    
    options = self.currentUser.activeJob.unselectedServiceOptiunons;
    NSMutableArray * unselectedServiceOptiunons = [[NSMutableArray alloc]init];
    for (PricebookItem *q in options) {
        [unselectedServiceOptiunons addObject:@{q.itemID: q.name}];
    }
    
    [temp setObject:selectedServiceOptions forKey:@"selected"];
    [temp setObject:unselectedServiceOptiunons forKey:@"not_selected"];
   
    ////
    
    if (self.currentUser.activeJob.initialCostumerRR == nil)
        self.currentUser.activeJob.initialCostumerRR = @"";
    
    if (self.currentUser.activeJob.initialTechRR == nil)
        self.currentUser.activeJob.initialTechRR = @"";
    
    if (self.currentUser.activeJob.totalInvestmentsRR == nil)
        self.currentUser.activeJob.totalInvestmentsRR = @"";
    
    [temp setObject:self.currentUser.activeJob.initialCostumerRR forKey:@"customerInitial"];
    [temp setObject:self.currentUser.activeJob.initialTechRR forKey:@"technicianInitial"];
    [temp setObject:self.currentUser.activeJob.totalInvestmentsRR forKey:@"totalRR"];
    
    
    UIImage *image = [UIImage imageWithData:self.currentUser.activeJob.signatureFile];
    NSString *signature = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (signature == nil)  //signature was removed
        signature = @"";
    [temp setObject:signature forKey:@"signature"];
    
    [temp setObject:[NSString stringWithFormat:@"%i",[self.currentUser.activeJob.serviceLevel intValue]] forKey:@"service_level"];
    [temp setObject:self.currentUser.activeJob.price forKey:@"price"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:debriefInfo];
    [params setObject:temp forKey:@"survey"];
  
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    

      self.responseSerializer = [AFJSONResponseSerializer serializer];
      [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    //[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
    [self POST:DEBRIEF
    parameters:@{ @"debrief" : myString }
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"responseObject %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               if (onSuccess) {
                   onSuccess(nil);
               }
           }
           else if (onError)
           {
               NSError *error = [NSError errorWithDomain:@"API Error" code:12345 userInfo:@{NSLocalizedDescriptionKey : responseObject[@"message"]}];
           //    [self showErrorMessage:error];
               onError(error);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
           if (onError) {
               onError(error);
           }
       }];
}

- (void)postInvoice:(NSMutableDictionary*)InvoiceInfo requestingPreview:(int)previewInt
          onSuccess:(void (^)(NSString *message))onSuccess
            onError:(void (^)(NSError *error))onError{
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
 
  //  NSDictionary * params = [[NSDictionary alloc]initWithDictionary:InvoiceInfo];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:InvoiceInfo options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSNumber *statusInt = [NSNumber numberWithInt:previewInt];
    
    [self POST:INVOICE
    parameters:@{ @"invoice" : myString, @"preview" : statusInt }
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               if (onSuccess) {
                   
                   NSString *htmlString;
                   if (previewInt == 1)
                       htmlString = responseObject[@"data"];
                   else if (previewInt == 0)
                       htmlString = (NSString *)responseObject;
                   
                   onSuccess(htmlString);
               }
           }
           else if (onError)
           {
               NSError *error = [NSError errorWithDomain:@"API Error" code:12345 userInfo:@{NSLocalizedDescriptionKey : responseObject[@"message"]}];
               //    [self showErrorMessage:error];
               NSLog(@"%@",error);
               onError(error);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
           if (onError) {
               onError(error);
           }
       }];
}

#pragma mark - Add2Cart Products
-(void)getAdd2CartProducts:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                   onError:(void (^)(NSError *error))onError {
  
  self.responseSerializer = [AFJSONResponseSerializer serializer];
  [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
  
  [self GET:ADD2CART_ITEMS
 parameters:@{}
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
      if ([responseObject[@"status"] integerValue] == kStatusOK) {
        NSDictionary *dict = responseObject[@"results"];
        onSuccess(@"OK", dict);
      }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      if (onError) {
        onError(error);
      }
    }];
}

#pragma mark - IQA Products
-(void)getIAQProducts: (void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                   onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self GET:IAQPRODUCTS
   parameters:@{}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSDictionary *dict = responseObject[@"results"];
              onSuccess(@"OK", dict);
          }else {
              NSError *error = [NSError errorWithDomain:@""
                                                   code:1001
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey:responseObject[@"message"]
                                                          }];
              onError(error);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (onError) {
              onError(error);
          }
      }];
}
#pragma mark - IQA Get Main Video
-(void)getMainVideo: (void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
              onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self GET:GETMAINVIDEO
   parameters:@{}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSDictionary *dict = responseObject[@"results"];
              onSuccess(@"OK", dict);
          }else {
              NSError *error = [NSError errorWithDomain:@""
                                                   code:1001
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey:responseObject[@"message"]
                                                          }];
              onError(error);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (onError) {
              onError(error);
          }
      }];
}
#pragma mark - emailIaqAuthorizeSale
-(void)emailIaqAuthorizeSale:(NSString *)authid
                   email:(NSString*)email
                   onSuccess:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
                     onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self POST:EMAILIAQAUTHORIZESALE
    parameters:@{@"id":authid, @"email": email}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dict = responseObject[@"results"];
          onSuccess(@"OK", dict);
      
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (onError) {
              onError(error);
          }
      }];
    
}
#pragma mark - addIaqAuthorizeSale
-(void)addIaqAuthorizeSale:(NSString *)products
                  customer:(NSString*)customer
                technician:(NSString*)technician
                     price:(CGFloat)price
                 signature:(NSString*)signature
                 onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                   onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString* dateString = [df stringFromDate:today];
    

    [self POST:ADDIAQAUTHORIZESALE
    parameters:@{@"date" : dateString , @"products": products, @"customer":customer, @"technician": technician, @"price":[NSNumber numberWithFloat:price], @"signature":signature}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               NSDictionary *dict = responseObject[@"result"];
               onSuccess(dict);
           }else{
               NSError *error = [NSError errorWithDomain:@""
                                                    code:1001
                                                userInfo:@{
                                                           NSLocalizedDescriptionKey:responseObject[@"message"]
                                                           }];
               onError(error);
           }
           
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];


    
    
}
#pragma mark - addIaqAuthorizeSaleUnapproved
-(void)addIaqAuthorizeSaleUnapproved:(NSString *)products
                  customer:(NSString*)customer
                technician:(NSString*)technician
                     price:(CGFloat)price
                 onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                   onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString* dateString = [df stringFromDate:today];
   
    [self POST:ADDIAQAUTHORIZESALEUNAPPROVED
    parameters:@{@"date" : dateString , @"products": products, @"customer":customer, @"technician": technician, @"price":[NSNumber numberWithFloat:price]}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               NSDictionary *dict = responseObject[@"result"];
               onSuccess(dict);
           }else{
               NSError *error = [NSError errorWithDomain:@""
                                                  code:1001
                                              userInfo:@{
                                                         NSLocalizedDescriptionKey:responseObject[@"message"]
                                                         }];
               onError(error);
           }
           
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];

    
}

#pragma mark - ADD2CART add2cartFinancials
-(void)add2cartFinancials:(NSDictionary *) parameters
            onSuccess:(void (^)(NSString *successMessage, NSDictionary *reciveData))onSuccess
              onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self GET:ADD2CARTFINANCIALS
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSDictionary *dict = responseObject[@"results"];
              onSuccess(@"OK", dict);
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (onError) {
              onError(error);
          }
      }];
}

#pragma mark - AdditionalInfo Requests

- (void)getAdditionalInfoOnSuccess:(void (^)(NSDictionary *infoDict))onSuccess
                           onError:(void (^)(NSError *error))onError {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self GET:ADDITIONAL_INFO parameters:@{}
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //if ([responseObject[@"status"] integerValue] == kStatusOK) {
              NSDictionary *dict = responseObject[@"results"];
              onSuccess(dict);
          //}
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (onError) {
              onError(error);
          }
      }];
}

#pragma mark - Sync Status
- (void)checkSyncStatusForAdd2Cart:(BOOL)isAdd2Cart
                         onSuccess:(void (^)(NSDictionary *dataDictionary))onSuccess
                           onError:(void (^)(NSError *error))onError {

    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    ////add2cart_sync/2 cand termin syncronizarea(downloadarea)....2 folosesc pentru additional info
    NSString *apiString;
    if (isAdd2Cart)
        apiString = SYNC_STATUS;
    else
        apiString = SYNC_STATUS2;
    
    [self POST:apiString
    parameters:@{}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSLog(@"responseObject check: %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               NSDictionary *dict = responseObject[@"results"];
               onSuccess(dict);
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
    
}

- (void)updateStatusForAdditionalInfoOnSuccess:(void (^)(NSString *message))onSuccess
                                       onError:(void (^)(NSError *error))onError {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self POST:SYNC_MODIFY
    parameters:@{}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSLog(@"responseObject modify sync: %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               
               onSuccess(@"asd");
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
}

#pragma mark - Send Logs
- (void)sendLogs:(NSArray *)logs
       onSuccess:(void (^)(NSString *message))onSuccess
         onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:logs options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    [self POST:LOGS
    parameters:@{@"errors" : myString}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               onSuccess(@"succes");
           } else if (onError) {
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
}

#pragma mark - Rebates Requests
-(void)addRebatesToPortal:(NSString *)title
                   amount:(CGFloat)amount
                 included:(NSString *)included
                onSuccess:(void (^)(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd))onSuccess
                  onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self POST:ADD_REBATES
    parameters:@{ @"title":title, @"amount":[NSNumber numberWithFloat:amount], @"included":included }
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSLog(@"responseObject: %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               
               NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
               f.numberStyle = NSNumberFormatterNoStyle;
               NSNumber *idNumb = [f numberFromString:[responseObject[@"results"] objectForKey:@"id"]];
               NSNumber *ordNumb = [f numberFromString:[responseObject[@"results"] objectForKey:@"ord"]];
               
               onSuccess(@"OK", idNumb, ordNumb);
               
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
    
}

-(void)updateRebatesToPortal:(NSString *)title
                      amount:(CGFloat)amount
                    included:(NSString *)included
                   rebate_id:(NSString *)rebate_id
                   onSuccess:(void (^)(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd))onSuccess
                     onError:(void (^)(NSError *error))onError {
    
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [self POST:UPDATE_REBATES
    parameters:@{ @"title":title, @"amount":[NSNumber numberWithFloat:amount], @"included":included, @"id":rebate_id }
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSLog(@"responseObject: %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               
               NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
               f.numberStyle = NSNumberFormatterNoStyle;
               NSNumber *idNumb = [f numberFromString:[responseObject[@"results"] objectForKey:@"id"]];
               NSNumber *ordNumb = [f numberFromString:[responseObject[@"results"] objectForKey:@"ord"]];
               
               onSuccess(@"OK", idNumb, ordNumb);
               
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
    
}



-(void)deleteRebatesFromPortalWithId:(NSString *)rebate_id
                     onSuccess:(void (^)(NSString *successMessage))onSuccess
                       onError:(void (^)(NSError *error))onError {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *myNumber = [f numberFromString:rebate_id];
    
    [self POST:DELETE_REBATES
    parameters:@{ @"id":myNumber}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSLog(@"responseObject: %@",responseObject);
           
           if ([responseObject[@"status"] integerValue] == kStatusOK) {
               
               onSuccess(@"OK");
               
           } else if (onError) {
               NSLog(@"%@", responseObject[@"message"]);
               onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
           }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           if (onError) {
               onError(error);
           }
       }];
}

/*
 -(void)addRebatesToPortal:(NSString *)title
 amount:(CGFloat)amount
 included:(NSString *)included
 onSuccess:(void (^)(NSString *successMessage))onSuccess
 onError:(void (^)(NSError *error))onError {
 
 self.responseSerializer = [AFJSONResponseSerializer serializer];
 [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
 
 [self POST:ADD_REBATES
 parameters:@{ @"title":title, @"amount":[NSNumber numberWithFloat:amount], @"included":included }
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 NSLog(@"responseObject: %@",responseObject);
 
 if ([responseObject[@"status"] integerValue] == kStatusOK) {
 //[weakSelf.requestSerializer setValue:weakSelf.userInfo[@"token"] forHTTPHeaderField:@"TOKEN"];
 onSuccess(@"OK");
 
 } else if (onError) {
 NSLog(@"%@", responseObject[@"message"]);
 onError([NSError errorWithDomain:@"API Error" code:12345 userInfo:@{ NSLocalizedDescriptionKey : responseObject[@"message"] }]);
 }
 }
 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if (onError) {
 onError(error);
 }
 }];
 
 
 
 }
*/

- (NSString*) convertDictionaryToString:(NSMutableDictionary*) dict
{
    NSError* error;
    NSDictionary* tempDict = [dict copy]; // get Dictionary from mutable Dictionary
    //giving error as it takes dic, array,etc only. not custom object.
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tempDict
                                                       options:0 error:&error];
    NSString* nsJson=  [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    return nsJson;
}

@end

void ShowOkAlertWithTitle(NSString *title, UIViewController *parentViewController)
{
    if ([UIAlertController class]) {
        // use UIAlertController
        UIAlertController *alert= [UIAlertController alertControllerWithTitle: title
                                                                      message: nil
                                                               preferredStyle: UIAlertControllerStyleAlert];
        
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cancel];
        
        if (!parentViewController) {
            parentViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        }
        
        [parentViewController presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
