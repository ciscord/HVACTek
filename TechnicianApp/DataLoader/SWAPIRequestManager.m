//
//  SWAPILoader.m
//  Signature
//
//  Created by Iurie Manea on 2/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "SWAPIRequestManager.h"
#import <XMLDictionary/XMLDictionary.h>
#import "DataLoader.h"

@interface SWAPIRequestManager ()

@property (nonatomic, copy) NSString    *connectionID;
@property (nonatomic, copy) NSString    *sessionID;
@property (nonatomic, assign) NSInteger requestsInProgress;
@end

NSString *const CONNECT     = @"Connect";
NSString *const kResultCode = @"_ResultCode";
NSString *const kResultText = @"_ResultText";

NSString *const kResultStatusOK = @"000";


@implementation SWAPIRequestManager

+ (instancetype)sharedInstance {
    static SWAPIRequestManager *s_sm_instance;
    @synchronized(self){
        if (!s_sm_instance) {
            s_sm_instance = [[SWAPIRequestManager alloc] initWithBaseURL:[NSURL URLWithString:kSWAPI_BASE_URL]];
        }
    }
    return (s_sm_instance);
}

- (instancetype)initWithBaseURL:(NSURL *)url {

    self = [super initWithBaseURL:url];
    if (self) {

        self.securityPolicy.allowInvalidCertificates  = YES;
        self.securityPolicy.validatesDomainName       = NO;
        self.securityPolicy.validatesCertificateChain = NO;

        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return self;
}

- (AFHTTPRequestOperation *)requestOperationWithXMLString:(NSString *)XMLString
                                                  success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *result))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:kSWAPI_BASE_URL parameters:nil error:NULL];
    request.HTTPBody = [XMLString dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
                                                  NSDictionary *d = [NSDictionary dictionaryWithXMLParser:responseObject];
                                             if ([d[kResultCode] isEqualToString:kResultStatusOK]) {
                                                 if (success) {
                                                     success(operation, d);
                                                 }
                                             } else {
                                                 NSError *error = [[NSError alloc] initWithDomain:@"SWAPI Error"
                                                                                             code:[d[kResultCode] integerValue]
                                                                                         userInfo:@{ NSLocalizedDescriptionKey : d[kResultText]}];
                                                 if (failure) {
                                                     failure(operation, error);
                                                 }
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (failure) {
                                                 failure(operation, error);
                                             }
                                         }];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (void)connectOnSuccess:(void (^)(NSString *successMessage))onSuccess
                 onError:(void (^)(NSError *error))onError {

    __weak typeof(self) weakSelf = self;
    NSString *body = [NSString
                      stringWithFormat:
                      @"<Connect><AgentName>%@</AgentName><AgentPassword>%@</AgentPassword><MasterID>%@</MasterID>\
                      <Mode>%@</Mode></Connect>",
                      kSWAPIAgentName, kSWAPIAgentPassword, kSWAPIMasterID, kSWAPIMode];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         weakSelf.connectionID = result[@"ConnectionID"];

         [weakSelf beginSessionOnSuccess:^(NSString *successMessage) {
              if (onSuccess) {
                  onSuccess(successMessage);
              }
          } onError:^(NSError *error) {
              if (onError) {
                  onError(error);
              }
          }];
     }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (onError) {
             onError(error);
         }
     }];
}

- (void)beginSessionOnSuccess:(void (^)(NSString *successMessage))onSuccess
                      onError:(void (^)(NSError *error))onError {

    __weak typeof(self) weakSelf = self;

    NSString *body = [NSString stringWithFormat:
                      @"<ConnectionRequest ConnectionID=\"%@\"><BeginSession><ConnectionID>%@</ConnectionID><CompanyNo>%@</CompanyNo>\
                      <Username>%@</Username><UserPassword>%@</UserPassword><Terminal>%@</Terminal><RemoteTC>%@</RemoteTC></BeginSession></ConnectionRequest>",
                      self.connectionID, self.connectionID, kSWAPICompanyNo, self.SWAPIUsername, self.SWAPIUserPassword, kSWAPITerminal, kSWAPIRemoteTC];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         weakSelf.sessionID = result[@"SessionID"];
         if (onSuccess) {
             onSuccess(nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (onError) {
             onError(error);
         }
     }];
}
//*****************************************************************************
- (void)assignmentListQueryForEmployee:(NSString *)employeeCode
                             withJobID:(NSString *)JobID
                             onSuccess:(void (^)(NSString *successMessage))onSuccess
                               onError:(void (^)(NSError *error))onError {

    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;

    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *body = [NSString stringWithFormat:
                      @"<SessionRequest SessionID=\"%@\"> <JobQuery> <JobNo>%@</JobNo></JobQuery></SessionRequest>",
                      self.sessionID,JobID
                      ];
//    NSString *body = [NSString stringWithFormat:
//                      @"<SessionRequest SessionID=\"%@\"><AssignmentListQuery><SchedDate>%@</SchedDate><EmployeeCode>%@</EmployeeCode>\
//                      </AssignmentListQuery></SessionRequest>",
//                      self.sessionID,
//                     // [dateTimeFormatter stringFromDate:[NSDate date]],
//                          [dateTimeFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*-1]],
//                      employeeCode];


    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
         id list = result[@"JobQueryData"][@"JobQueryRecord"];
        
        if ([result[@"JobQueryData"][@"_ReturnedRows"] intValue ]==0) {
            NSError * error = [NSError errorWithDomain:@"API Error" code:12345 userInfo:@{NSLocalizedDescriptionKey : @"Job not find"}];
           onError(error);
        } else
        {

        
        
         if ([list isKindOfClass:[NSArray class]]) {
             weakSelf.currentJob = [User getNextJobFromList:list withJobID:JobID];

         } else {

             weakSelf.currentJob = list;
         }

         [weakSelf whoListQueryForJobOnSuccess:nil onError:nil];
         [weakSelf departmentListQueryForJobOnSuccess:nil onError:nil];
         [weakSelf equipmentListQueryForJobOnSuccess:nil onError:nil];
        
        
         [weakSelf GetdsAgreeListForJobWithLocationID:list[@"LocationID"] OnSuccess:^(NSString *successMessage) {
         [weakSelf GetdsHistoryForJobWithLocationID:list[@"LocationID"] OnSuccess:^(NSString *successMessage) {
         [weakSelf GetdsEquipForJobWithLocationID:list[@"LocationID"] OnSuccess:^(NSString *successMessage) {
             
             if (onSuccess) {
                        onSuccess(nil);
                    }
                } onError:^(NSError *error) {
                    onError(error);
                }];

            } onError:^(NSError *error) {
                onError(error);
            }];

        } onError:^(NSError *error) {
            onError(error);
        }];
       
        }
//         [weakSelf GetdsHistoryForJobWithLocationID:list[@"LocationID"] OnSuccess:nil onError:nil];
//        [weakSelf GetdsEquipForJobWithLocationID:list[@"LocationID"] OnSuccess:nil onError:nil];

//         if (onSuccess) {
//             onSuccess(nil);
//         }
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
         if (onError) {
             onError(error);
         }
     }];
}

- (void)GetdsAgreeListForJobWithLocationID:(NSString *)locationID
                                 OnSuccess:(void (^)(NSString *successMessage))onSuccess
                                  onError:(void (^)(NSError *error))onError{
    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;
    

    NSString *body = [NSString stringWithFormat:
                      @"<SessionRequest SessionID=\"%@\"> <AgreementListQuery> <LocationID>%@</LocationID></AgreementListQuery></SessionRequest>",
                      self.sessionID,locationID
                      ];
    
    
    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        if ([result[@"AgreementListQueryData"][@"_ReturnedRows"] intValue ]>0) {
            NSDictionary * list = result[@"AgreementListQueryData"][@"AgreementListQueryRecord"];
            [weakSelf.currentJob setObject:list forKey:@"dsAgreeList.dsAgree"];
        }
        
        
        if (onSuccess) {
            onSuccess(nil);
        }
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
        if (onError) {
            onError(error);
        }
    }];

    
}

- (void)GetdsHistoryForJobWithLocationID:(NSString *)locationID
                                 OnSuccess:(void (^)(NSString *successMessage))onSuccess
                                   onError:(void (^)(NSError *error))onError{
    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;
    
    
    NSString *body = [NSString stringWithFormat:
                      @"<SessionRequest SessionID=\"%@\"> <HistoryQuery> <LocationID>%@</LocationID></HistoryQuery></SessionRequest>",
                      self.sessionID,locationID
                      ];
    
    
    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        
        if ([result[@"HistoryQueryData"][@"_ReturnedRows"] intValue ]>0) {
          NSDictionary * list = result[@"HistoryQueryData"][@"HistoryQueryRecord"];
           [weakSelf.currentJob setObject:list forKey:@"dsHistoryList.dsHistory"];
        }
       
        if (onSuccess) {
            onSuccess(nil);
        }
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
        if (onError) {
            onError(error);
        }
    }];
    
    
}

- (void)GetdsEquipForJobWithLocationID:(NSString *)locationID
                               OnSuccess:(void (^)(NSString *successMessage))onSuccess
                                 onError:(void (^)(NSError *error))onError{
    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;
    
    
    NSString *body = [NSString stringWithFormat:
                      @"<SessionRequest SessionID=\"%@\"> <EquipmentListQuery> <LocationID>%@</LocationID></EquipmentListQuery></SessionRequest>",
                      self.sessionID,locationID
                      ];
    
    
    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        
        if ([result[@"EquipmentListQueryData"][@"_ReturnedRows"] intValue ]>0) {
            NSDictionary * list = result[@"EquipmentListQueryData"][@"EquipmentListQueryRecord"];
            [weakSelf.currentJob setObject:list forKey:@"dsEquipList.dsEquip"];
        }
        
        if (onSuccess) {
            onSuccess(nil);
        }
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.requestsInProgress--;
        [weakSelf checkAndCloseConnectionAndSession];
        if (onError) {
            onError(error);
        }
    }];
    
    
}


//*****************************************************************************
- (void)equipmentListQueryForJobOnSuccess:(void (^)(NSString *successMessage))onSuccess
                                  onError:(void (^)(NSError *error))onError {

    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;

    NSString *body = [NSString stringWithFormat:@"<SessionRequest "
                      @"SessionID=\"%@\"><EquipmentListQuery><LocationID>%@</"
                      @"LocationID></EquipmentListQuery></SessionRequest>",
                      self.sessionID, self.currentJob[@"LocationID"]];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         weakSelf.equipmentList = result[@"SessionID"];
         NSLog(@"equipmentListQueryForJobOnSuccess");
         if (onSuccess) {
             onSuccess(nil);
         }
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
         if (onError) {
             onError(error);
         }
     }];
}


- (void)departmentListQueryForJobOnSuccess:(void (^)(NSArray *list))onSuccess
                                   onError:(void (^)(NSError *error))onError {

    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;

    NSString *body = [NSString stringWithFormat:@"<SessionRequest SessionID=\"%@\"><DepartmentQuery/></SessionRequest>", self.sessionID];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         NSArray *deps = result[@"DepartmentQueryData"][@"DepartmentQueryRecord"];
         NSMutableArray *depsAndCodes = @[].mutableCopy;
         for (NSDictionary *d in deps) {
             [depsAndCodes addObject:[NSString stringWithFormat:@"%@ %@", d[@"Code"], d[@"Description"]]];
         }
         weakSelf.departmentList = [depsAndCodes sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {
                                        return [obj1 compare:obj2];
                                    }];
         NSLog(@"departmentListQueryForJobOnSuccess");
         if (onSuccess) {
             onSuccess(weakSelf.departmentList);
         }
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
         if (onError) {
             onError(error);
         }
     }];
}



- (void)whoListQueryForJobOnSuccess:(void (^)(NSArray *list))onSuccess
                            onError:(void (^)(NSError *error))onError {
    self.requestsInProgress++;
    __weak typeof(self) weakSelf = self;

    NSString *body = [NSString stringWithFormat:@"<SessionRequest SessionID=\"%@\"><EmployeeQuery/></SessionRequest>", self.sessionID];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         NSArray *list = result[@"EmployeeQueryData"][@"EmployeeQueryRecord"];

         weakSelf.whoList = list;
         NSLog(@"whoListQueryForJobOnSuccess");
         if (onSuccess) {
             onSuccess(weakSelf.whoList);
         }
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.requestsInProgress--;
         [weakSelf checkAndCloseConnectionAndSession];
         if (onError) {
             onError(error);
         }
     }];
}

- (void)checkAndCloseConnectionAndSession {
    if (self.requestsInProgress == 0) {

        __weak typeof(self) weakSelf = self;
        NSString *body = [NSString stringWithFormat:
                          @"<SessionRequest SessionID=\"%@\"><EndSession><SessionID>%@</SessionID></EndSession></SessionRequest>",
                          self.sessionID, self.sessionID];

        [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

             weakSelf.sessionID = nil;
             [weakSelf closeConnection];
             NSLog(@"EndSession result:%@", result);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"EndSession error:%@", error);
         }];
    }
}

- (void)closeConnection {
    __weak typeof(self) weakSelf = self;
    NSString *body = [NSString stringWithFormat:
                      @"<ConnectionRequest ConnectionID=\"%@\"><Disconnect><ConnectionID>%@</ConnectionID><Force>1</Force></Disconnect></ConnectionRequest>",
                      self.connectionID, self.connectionID];

    [self requestOperationWithXMLString:body success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {

         weakSelf.connectionID = nil;
         NSLog(@"closeConnection result:%@", result);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"closeConnection error:%@", error);
     }];
}

@end
