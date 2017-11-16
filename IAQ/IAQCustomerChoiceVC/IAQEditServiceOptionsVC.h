//
//  IAQEditServiceOptionsVC.h
//  HvacTek
//
//  Created by Max on 11/16/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVC.h"
@interface IAQEditServiceOptionsVC : BaseVC <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray *servicesArray;
@property (strong, nonatomic) NSMutableArray *changedServicesArray;
@property (nonatomic) NSInteger selectedIndex;

@end

