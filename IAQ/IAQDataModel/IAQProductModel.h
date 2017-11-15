//
//  IAQProductsModel.h
//  HvacTek
//
//  Created by Max on 11/15/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"
#import "StaticPressureModel.h"
@interface IAQProductModel : NSObject
@property (nonatomic, strong) NSString* businessId;
@property (nonatomic, strong) NSString* createdAt;
@property (nonatomic, strong) NSString* createdBy;
@property (nonatomic, strong) NSString* productId; //id
@property (nonatomic, strong) NSString* ord;
@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSMutableArray* files;
@property (nonatomic, strong) NSString* quantity;
@end
