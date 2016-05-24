//
//  SWAPILoader.h
//  Signature
//
//  Created by Iurie Manea on 2/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface SWAPIRequestManager : AFHTTPRequestOperationManager

@property(nonatomic, copy)   NSString     *SWAPIUserCode;
@property(nonatomic, copy)   NSString     *SWAPIUsername;
@property(nonatomic, copy)   NSString     *SWAPIUserPassword;

@property(nonatomic, strong) NSMutableDictionary *currentJob;
@property(nonatomic, strong) NSArray      *equipmentList;
@property(nonatomic, strong) NSArray      *departmentList;
@property(nonatomic, strong) NSArray      *whoList;

@property(nonatomic, copy)   NSString     *companyName;


+ (instancetype)sharedInstance;

- (AFHTTPRequestOperation *)requestOperationWithXMLString:(NSString *)XMLString
                                                  success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *result))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failre;

- (AFHTTPRequestOperation *)xmlRequestOperationWithXMLString:(NSString *)XMLString
                                                  success:(void (^)(AFHTTPRequestOperation *operation, NSString *result))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failre;

- (void)connectOnSuccess:(void (^)(NSString *successMessage))onSuccess
                 onError:(void (^)(NSError *error))onError;

- (void)beginSessionOnSuccess:(void (^)(NSString *successMessage))onSuccess
                      onError:(void (^)(NSError *error))onError;

- (void)assignmentListQueryForEmployee:(NSString *)employeeCode
                             withJobID:(NSString *)JobID
                             onSuccess:(void (^)(NSString *successMessage))onSuccess
                               onError:(void (^)(NSError *error))onError ;

///// account info
//- (void)getUserAccountInfoWithLocationID:(NSString *)location
//                            andBillingID:(NSString *)billing
//                               OnSuccess:(void (^)(NSString *account))onSuccess
//                            onError:(void (^)(NSError *error))onError;
//
//- (void)userAccountInfoUpdateWithData:(NSString *)data
//                          andNewEmail:(NSString *)email
//                            OnSuccess:(void (^)(BOOL changed))onSuccess
//                              onError:(void (^)(NSError *error))onError;

- (void)getUserLocationInfoQueryWithLocationID:(NSString *)location
                               OnSuccess:(void (^)(NSString *account))onSuccess
                                 onError:(void (^)(NSError *error))onError;


- (void)userLocationInfoUpdateWithData:(NSString *)data
                           andNewEmail:(NSString *)email
                               OnSuccess:(void (^)(NSString *message))onSuccess
                                 onError:(void (^)(NSError *error))onError;




@end


