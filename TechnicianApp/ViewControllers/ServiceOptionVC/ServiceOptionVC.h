//
//  ServiceOptionVC.h
//  Signature
//
//  Created by Andrei Zaharia on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface ServiceOptionVC : BaseVC <UIAlertViewDelegate>

@property (nonatomic, assign) OptionsDisplayType optionsDisplayType;
@property (nonatomic, strong) NSArray *priceBookAndServiceOptions;

@end
