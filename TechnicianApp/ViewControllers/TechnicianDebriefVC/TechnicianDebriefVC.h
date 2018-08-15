//
//  TechnicianDebriefVC.h
//  Signature
//
//  Created by Alexei on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"
typedef NS_ENUM (NSInteger, TDCellAlign){
    cLeft,
    cCenter,
    cRight
};

typedef NS_ENUM (NSInteger, CellType){
    ctCellDefault,
    ctCellTotalRevenue,
    ctCellAddOnSaleFuture,
    ctCellTotalRevenueGenerated
};


typedef NS_ENUM (NSInteger, TDCellAccType){
    lblCellAcc,
    drpDownCellAcc,
    txtViewCellAcc,
    txtFieldCellAcc,
    txtFieldNumericCellAcc,
    chkBoxCellAcc
};

@interface TechnicianDebriefVC : BaseVC

@end
