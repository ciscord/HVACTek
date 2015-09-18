//
//  QuestionView.m
//  Signature
//
//  Created by Iurie Manea on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

-(void)setup
{
    [super setup];
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithRed:239./255. green:246./255. blue:226./255. alpha:1.];
}

-(void)setQuestion:(Question *)question
{
    _question = question;
    self.txtQuestion.text = question.question;
    self.txtAnswer.text = question.answer;
    self.txtAnswer.hidden = question.type.integerValue == kNoAnswerQuestion;
    self.txtAnswer.hidden = !question.haveNote;
}

- (IBAction)btnBackTouch:(id)sender
{
    self.question.answer = self.txtAnswer.text;
    if (self.OnBackButtonTouch)
    {
        self.OnBackButtonTouch(self);
    }
}

- (IBAction)btnNextTouch:(id)sender
{
    self.question.answer = self.txtAnswer.text;
    if (self.OnNextButtonTouch)
    {
        self.OnNextButtonTouch(self);
    }
}

@end
