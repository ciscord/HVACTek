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
+(IAQDataModel*) sharedIAQDataModel;
@end
