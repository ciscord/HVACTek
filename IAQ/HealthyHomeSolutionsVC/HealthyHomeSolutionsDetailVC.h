//
//  EnlargeOptionsVC.h
//  Signature
//
//  Created by Dorin on 8/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"
#import "IAQCustomerChoiceVC.h"
@interface HealthyHomeSolutionsDetailVC : BaseVC <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    
}
@property (readwrite) IAQTYPE iaqType;
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (nonatomic, strong) NSString *enlargeOptionName;
@property (nonatomic, strong) NSString *enlargeTotalPrice;
@property (nonatomic, strong) NSString *enlargeESAPrice;
@property (nonatomic, strong) NSString *firstLabelString;
@property (nonatomic, strong) NSString *secondLabelString;
@property (nonatomic, strong) NSString *thirdLabelString;
@property (weak, nonatomic) UIViewController *parentVC;
@end
