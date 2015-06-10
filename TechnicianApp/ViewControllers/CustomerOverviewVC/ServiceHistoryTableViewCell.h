//
//  ServiceHistoryTableViewCell.h
//  Signature
//
//  Created by Iurie Manea on 3/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SServiceHistory;

@interface ServiceHistoryTableViewCell : UITableViewCell

+(CGFloat)heightForData:(SServiceHistory*)data andMaxWidth:(CGFloat)maxWidth;
-(void)displayData:(SServiceHistory*)data;

@end
