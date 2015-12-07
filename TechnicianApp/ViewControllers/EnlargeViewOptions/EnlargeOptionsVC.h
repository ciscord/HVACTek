//
//  EnlargeOptionsVC.h
//  Signature
//
//  Created by Dorin on 8/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface EnlargeOptionsVC : BaseVC <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    
}

@property (nonatomic, strong) NSArray *enlargeOptionsArray;
@property (nonatomic, strong) NSArray *enlargeFullOptionsArray;
@property (nonatomic, strong) NSString *enlargeOptionName;
@property (nonatomic, strong) NSString *enlargeTotalPrice;
@property (nonatomic, strong) NSString *enlargeESAPrice;
@property (nonatomic, strong) NSString *enlargeMonthlyPrice;
@property (nonatomic, strong) NSString *enlargeSavings;


@end
