//
//  ExploreSummaryVC.h
//  Signature
//
//  Created by Iurie Manea on 1/9/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface ExploreSummaryVC : BaseVC

@property (nonatomic, assign) QuestionType  sectionTypeChoosed;
@property(strong, nonatomic) NSArray *questions;

@end
