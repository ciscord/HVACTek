//
//  CustomerChoiceVC.h
//  Signature
//
//  Created by Andrei Zaharia on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface CustomerChoiceVC : BaseVC <UITextFieldDelegate> {
    
}

@property (nonatomic, strong) NSDictionary *fullServiceOptions;
@property (nonatomic, strong) NSDictionary *selectedServiceOptions;
@property (nonatomic, assign) BOOL isDiscounted;
@property (nonatomic, assign) BOOL isOnlyDiagnostic;

@end
