//
//  IAQDataModel.h
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAQProductModel.h"
#import "StaticPressureModel.h"
@interface IAQDataModel : NSObject
@property (nonatomic, strong) StaticPressureModel * heatingStaticPressure;
@property (nonatomic, strong) StaticPressureModel * coolingStaticPressure;
@property (nonatomic, strong) NSMutableArray*       iaqProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqSortedProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqBestProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqBetterProductsArray;
@property (nonatomic, strong) NSMutableArray*       iaqGoodProductsArray;

@property (readwrite) int airPurification;
@property (readwrite) int humidification;
@property (readwrite) int airFiltration;
@property (readwrite) int dehumidification;
@property (readwrite) int calculatedScore;

@property (readwrite) int isfinal;
@property (readwrite) float bestTotalPrice;
@property (readwrite) float betterTotalPrice;
@property (readwrite) float goodTotalPrice;

+(IAQDataModel*) sharedIAQDataModel;
@end
