//
//  NewCustomerChoiceVC.h
//  Signature
//
//  Created by Dorin on 8/11/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface NewCustomerChoiceVC : BaseVC <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (strong, nonatomic) NSMutableArray *unselectedOptionsArray;
@property (nonatomic, strong) NSDictionary *fullServiceOptionsDict;
@property (nonatomic, strong) NSDictionary *selectedServiceOptionsDict;
@property (nonatomic, assign) BOOL isDiscounted;
@property (nonatomic, assign) BOOL isOnlyDiagnostic;



@end
