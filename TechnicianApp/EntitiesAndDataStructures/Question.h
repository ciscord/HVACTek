//
//  Question.h
//  Signature
//
//  Created by Iurie Manea on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseEntity.h"

#define  kNoAnswerQuestion -1

#define  kQuestionIDKey         @"id"
#define  kQuestionNameKey       @"question_name"
#define  kQuestionTypeKey       @"type"
#define  kQuestionGroupKey      @"group"
#define  kQuestionOrdKey        @"ord"
#define  kQuestionQuestionKey   @"question"
#define  kQuestionAnswerKey     @"answer"
#define  kQuestionRequiredKey   @"required"
#define  kQuestionNote          @"note"

@interface Question : BaseEntity

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *group;
@property(nonatomic, strong) NSNumber *ord;
@property(nonatomic, strong) NSString *question;
@property(nonatomic, strong) NSString *answer;
@property(nonatomic, assign) BOOL haveNote;
@property(nonatomic, assign) BOOL required;

@end
