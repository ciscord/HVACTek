//
//  IAQDataModel.h
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"
#import "IAQProductModel+CoreDataProperties.h"
#import "StaticPressureModel.h"
typedef NS_ENUM(NSInteger, IAQCurrentView) {
    IAQNone = -1,
    IAQHealthyHomeSolution,
    IAQHealthyHomeSolutionSort,
    IAQCustomerChoice,
    IAQBreatheEasyHealtyHome,
    IAQVideoForCustomer,
    IAQIsYourHomeHealthy,
    IAQHereWhatWePropose,
    IAQSummaryOfFinding,
    IAQCustomerChoiceFinal,
    HealthyHomeSolutionsAgreement,
    IAQHealthyHomeProcess,
    IAQHeatingStaticPressure,
    IAQCoolingStaticPressure,
};
@interface IAQDataModel : NSObject

@property (nonatomic, strong) StaticPressureModel * heatingStaticPressure;
@property (nonatomic, strong) StaticPressureModel * coolingStaticPressure;
@property (nonatomic, strong) NSMutableArray*       iaqProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqSortedProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqBestProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqBetterProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqGoodProductsArray;

@property (nonatomic, strong) NSMutableArray*       iaqSortedProductsIdArray;
@property (nonatomic, strong) NSMutableArray*       iaqSortedProductsQuantityArray;

@property (nonatomic, strong) NSMutableArray*       iaqBestProductsIdArray;
@property (nonatomic, strong) NSMutableArray*       iaqBetterProductsIdArray;
@property (nonatomic, strong) NSMutableArray*       iaqGoodProductsIdArray;

@property (readwrite) int airPurification;
@property (readwrite) int humidification;
@property (readwrite) int airFiltration;
@property (readwrite) int dehumidification;
@property (readwrite) int calculatedScore;

@property (readwrite) int isfinal;
@property (readwrite) float bestTotalPrice;
@property (readwrite) float betterTotalPrice;
@property (readwrite) float goodTotalPrice;

@property (readwrite) float bestSubPrice;
@property (readwrite) float betterSubPrice;
@property (readwrite) float goodSubPrice;

@property (readwrite) IAQCurrentView currentStep;
+(IAQDataModel*) sharedIAQDataModel;

- (void) saveHeatingStaticPressure;

- (void) loadHeatingStaticPressure;

- (void) saveCoolingStaticPressure;

- (void) loadCoolingStaticPressure;

- (void) resetAllData;

@end
