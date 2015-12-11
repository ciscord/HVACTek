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
    
    
    pickerData = [[NSMutableArray alloc] init];
}


-(void)getYearsForPicker {
    for (int i = 1; i < 31; i++) {
        if (i == 30)
            [pickerData addObject:[NSString stringWithFormat:@"%d+  years", i]];
        else{
            if (i == 1)
                [pickerData addObject:[NSString stringWithFormat:@"%d  year", i]];
            else
                [pickerData addObject:[NSString stringWithFormat:@"%d  years", i]];
        }
    }
    [self.answerPickerView reloadAllComponents];
}



-(void)setQuestion:(Question *)question
{
    _question = question;
    self.txtQuestion.text = question.question;
    
    if ([question.fieldTypeId isEqualToString:@"1"]) {
        self.txtAnswer.text = question.answer;
        self.txtAnswer.hidden = question.type.integerValue == kNoAnswerQuestion;
        self.txtAnswer.hidden = !question.haveNote;
        self.answerPickerView.hidden = YES;
    }else if ([question.fieldTypeId isEqualToString:@"2"]) {
        self.answerPickerView.hidden = NO;
        self.txtAnswer.hidden = YES;
        [pickerData addObject:@"No"];
        [pickerData addObject:@"Yes"];
        [self.answerPickerView reloadAllComponents];
    }else if ([question.fieldTypeId isEqualToString:@"3"]) {
        [self getYearsForPicker];
        self.answerPickerView.hidden = NO;
        self.txtAnswer.hidden = YES;
    }
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
    if ([self.question.fieldTypeId isEqualToString:@"1"]) {
        self.question.answer = self.txtAnswer.text;
    }else if ([self.question.fieldTypeId isEqualToString:@"2"]) {
        
    }else if ([self.question.fieldTypeId isEqualToString:@"3"]) {
        self.question.answer = [pickerData objectAtIndex:[self.answerPickerView selectedRowInComponent:0]];
    }
    
    
    if (self.OnNextButtonTouch)
    {
        self.OnNextButtonTouch(self);
    }
}


#pragma mark - Picker DataSource & Delegate
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

@end
