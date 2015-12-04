//
//  EditServiceOptionsVC.h
//  Signature
//
//  Created by Dorin on 12/3/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface EditServiceOptionsVC : BaseVC <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray *servicesArray;
@property (strong, nonatomic) NSMutableArray *changedServicesArray;
@property (nonatomic) NSInteger selectedIndex;

@end
