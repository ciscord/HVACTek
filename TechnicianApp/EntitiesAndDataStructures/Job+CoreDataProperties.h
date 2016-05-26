//
//  Job+CoreDataProperties.h
//  HvacTek
//
//  Created by Dorin on 5/26/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface Job (CoreDataProperties)

@property (nullable, nonatomic, retain) id addedCustomRepairsOptions;
@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *completionTime;
@property (nullable, nonatomic, retain) id custumerQuestions;
@property (nullable, nonatomic, retain) NSDate *dispatchTime;
@property (nullable, nonatomic, retain) NSDate *endTimeQuestions;
@property (nullable, nonatomic, retain) NSString *initialCostumerRR;
@property (nullable, nonatomic, retain) NSString *initialTechRR;
@property (nullable, nonatomic, retain) NSString *jobID;
@property (nullable, nonatomic, retain) NSNumber *jobStatus;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) id rrQuestions;
@property (nullable, nonatomic, retain) id selectedServiceOptions;
@property (nullable, nonatomic, retain) NSNumber *serviceLevel;
@property (nullable, nonatomic, retain) NSData *signatureFile;
@property (nullable, nonatomic, retain) NSDate *startTime;
@property (nullable, nonatomic, retain) NSDate *startTimeQuestions;
@property (nullable, nonatomic, retain) id swapiJobInfo;
@property (nullable, nonatomic, retain) id techObservations;
@property (nullable, nonatomic, retain) NSString *totalInvestmentsRR;
@property (nullable, nonatomic, retain) id unselectedServiceOptiunons;
@property (nullable, nonatomic, retain) NSString *utilityOverpaymentHVAC;
@property (nullable, nonatomic, retain) id additionalInfoData;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
