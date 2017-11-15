//
//  HeatingStaticPressureModel.h
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticPressureModel : NSObject
@property (nonatomic, strong) NSString* customerName;
@property (nonatomic, strong) NSString* todayDate;
@property (nonatomic, strong) NSString* filterSize;
@property (nonatomic, strong) NSString* filterMervRating;
@property (nonatomic, strong) NSString* systemType;
@property (nonatomic, strong) NSString* heatingA;
@property (nonatomic, strong) NSString* heatingB;
@property (nonatomic, strong) NSString* heatingC;
@property (nonatomic, strong) NSString* heatingD;

@end
