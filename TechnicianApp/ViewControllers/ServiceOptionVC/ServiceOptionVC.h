//
//  ServiceOptionVC.h
//  Signature
//
//  Created by Andrei Zaharia on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM (NSInteger, OptionsDisplayType){
    odtEditing,
    odtNoValues,
    odtReadonlyWithPrice,
    odtCustomerFinalChoice
};

@interface ServiceOptionVC : BaseVC <UIAlertViewDelegate>

@property (nonatomic, assign) OptionsDisplayType optionsDisplayType;
@property (nonatomic, strong) NSArray *priceBookAndServiceOptions;

@end
