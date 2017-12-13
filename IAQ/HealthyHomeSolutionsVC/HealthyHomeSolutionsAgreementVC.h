//
//  HealthyHomeSolutionsAgreementVC.h
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "BaseVC.h"
#import "IAQCustomerChoiceVC.h"
@interface HealthyHomeSolutionsAgreementVC : BaseVC
@property (readwrite) IAQTYPE iaqType;
@property (readwrite) COSTTYPE costType;
@property (readwrite) Boolean fromAddCart2;
@end
