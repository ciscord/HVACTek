//
//  ServiceOptionsVC.h
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface SummaryOfFindingsOptionsVC : BaseVC <UITextFieldDelegate>

@property(nonatomic, assign) BOOL isiPadCommonRepairsOptions;
@property (nonatomic, strong) NSString *calculatedCustomRepairPrice;

@end
