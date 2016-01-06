//
//  QuestionVC.h
//  Signature
//
//  Created by Iurie Manea on 10.12.2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface QuestionsVC : BaseVC

@property (nonatomic, assign) QuestionType  questionType;
@property(nonatomic, strong) NSArray *questions;

@end
