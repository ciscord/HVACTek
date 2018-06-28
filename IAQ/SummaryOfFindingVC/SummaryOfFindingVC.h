//
//  PlatinumOptionsVC.h
//  Signature
//
//  Created by Iurie Manea on 17.03.2015.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface SummaryOfFindingVC : BaseVC

@property (nonatomic, strong) NSArray *priceBookAndServiceOptions;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bigButtonArray;
@end
