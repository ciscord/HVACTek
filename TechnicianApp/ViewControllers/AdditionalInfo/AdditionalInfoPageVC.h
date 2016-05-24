//
//  AdditionalInfoPageVC.h
//  HvacTek
//
//  Created by Dorin on 5/19/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface AdditionalInfoPageVC : BaseVC

@property (strong, nonatomic) NSMutableArray *unselectedOptionsArray;
@property (nonatomic, strong) NSDictionary *selectedServiceOptionsDict;
@property (nonatomic, assign) BOOL isDiscounted;
@property (nonatomic, assign) BOOL isOnlyDiagnostic;
@property (nonatomic, strong) NSString *paymentValue;
@property (nonatomic, strong) NSString *initialTotal;

@end
