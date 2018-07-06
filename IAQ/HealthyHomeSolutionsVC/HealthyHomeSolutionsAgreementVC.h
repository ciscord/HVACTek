//
//  HealthyHomeSolutionsAgreementVC.h
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "BaseVC.h"
#import "IAQCustomerChoiceVC.h"
@interface HealthyHomeSolutionsAgreementVC : BaseVC<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (readwrite) IAQTYPE iaqType;
@property (readwrite) COSTTYPE costType;
@property (readwrite) Boolean fromAddCart2;

@property (nonatomic, strong) NSString *enlargeOptionName;
@property (nonatomic, strong) NSString *enlargeTotalPrice;
@property (nonatomic, strong) NSString *enlargeESAPrice;
@property (nonatomic, strong) NSString *firstLabelString;
@property (nonatomic, strong) NSString *secondLabelString;
@property (nonatomic, strong) NSString *thirdLabelString;

@end
