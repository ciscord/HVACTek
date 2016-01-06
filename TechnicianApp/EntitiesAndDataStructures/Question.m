//
//  Question.m
//  Signature
//
//  Created by Iurie Manea on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithDictionary:(NSDictionary*)dictionaryInfo
{
    self = [super initWithDictionary:dictionaryInfo];
    if (self)
    {
        self.ID = @([dictionaryInfo[kQuestionIDKey] integerValue]);
        self.name = dictionaryInfo[kQuestionNameKey];
        self.type = @([dictionaryInfo[kQuestionTypeKey] integerValue]);
        self.group = @([dictionaryInfo[kQuestionGroupKey] integerValue]);
        self.ord = @([dictionaryInfo[kQuestionOrdKey] integerValue]);
        self.question = dictionaryInfo[kQuestionQuestionKey];
        self.answer = dictionaryInfo[kQuestionAnswerKey];
        self.required = [dictionaryInfo[kQuestionRequiredKey] boolValue];
        self.haveNote  = [dictionaryInfo[kQuestionNote] isEqualToString:@"0"];
        self.fieldTypeId = dictionaryInfo[kQuestionFieldTypeId];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.ID = [aDecoder decodeObjectForKey:kQuestionIDKey];
        self.name = [aDecoder decodeObjectForKey:kQuestionNameKey];
        self.type = [aDecoder decodeObjectForKey:kQuestionTypeKey];
        self.group = [aDecoder decodeObjectForKey:kQuestionGroupKey];
        self.ord = [aDecoder decodeObjectForKey:kQuestionOrdKey];
        self.question = [aDecoder decodeObjectForKey:kQuestionQuestionKey];
        self.answer = [aDecoder decodeObjectForKey:kQuestionAnswerKey];
        self.required = [aDecoder decodeBoolForKey:kQuestionRequiredKey];
         self.haveNote  = [aDecoder decodeBoolForKey:kQuestionNote];
        self.fieldTypeId = [aDecoder decodeObjectForKey:kQuestionFieldTypeId];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // Override in descending classes

    [aCoder encodeObject:self.ID forKey:kQuestionIDKey];
    [aCoder encodeObject:self.name forKey:kQuestionNameKey];
    [aCoder encodeObject:self.type forKey:kQuestionTypeKey];
    [aCoder encodeObject:self.group forKey:kQuestionGroupKey];
    [aCoder encodeObject:self.ord forKey:kQuestionOrdKey];
    [aCoder encodeObject:self.question forKey:kQuestionQuestionKey];
    [aCoder encodeObject:self.answer forKey:kQuestionAnswerKey];
    [aCoder encodeBool:self.required forKey:kQuestionRequiredKey];
    [aCoder encodeBool:self.haveNote forKey:kQuestionNote];
    [aCoder encodeObject:self.fieldTypeId forKey:kQuestionFieldTypeId];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"{\n   id:%@;\n   name:%@;\n   type:%@;\n   group:%@;\n   ord:%@;\n   question:%@;\n   answer:%@\n   required:%@\n}", _ID, _name, _type, _group, _ord, _question, _answer, @(_required)];
}

@end
