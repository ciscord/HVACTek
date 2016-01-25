//
//  QuestionView.m
//  Signature
//
//  Created by Iurie Manea on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "QuestionView.h"

@interface QuestionView ()


@end


@implementation QuestionView

-(void)setup
{
    [super setup];
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.backgroundColor = [UIColor cs_getColorWithProperty:kColorSecondary10];
    
    pickerData = [[NSMutableArray alloc] init];
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
        [self setUpYesNoPicker];
        self.answerPickerView.hidden = NO;
        self.txtAnswer.hidden = YES;
        if (question.answer) {
            [self.answerPickerView selectRow:[pickerData indexOfObject:question.answer] inComponent:0 animated:YES];
        }
        [self.answerPickerView reloadAllComponents];
    }else if ([question.fieldTypeId isEqualToString:@"3"]) {
        [self setUpYearsPicker];
        self.answerPickerView.hidden = NO;
        self.txtAnswer.hidden = YES;
        if (question.answer) {
            [self.answerPickerView selectRow:[pickerData indexOfObject:question.answer] inComponent:0 animated:YES];
        }
    }
}



#pragma mark - SetUp Picker
-(void)setUpYearsPicker {
    [pickerData removeAllObjects];
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


- (void)setUpYesNoPicker {
    [pickerData removeAllObjects];
    [pickerData addObject:@"No"];
    [pickerData addObject:@"Yes"];
}



#pragma mark - Buttons Actions
- (IBAction)btnBackTouch:(id)sender
{
    [self setQuestionAnswer];
    if (self.OnBackButtonTouch)
    {
        self.OnBackButtonTouch(self);
    }
}

- (IBAction)btnNextTouch:(id)sender
{
    [self setQuestionAnswer];
    if (self.OnNextButtonTouch)
    {
        self.OnNextButtonTouch(self);
    }
}


- (void)setQuestionAnswer {
    if ([self.question.fieldTypeId isEqualToString:@"1"]) {
        self.question.answer = self.txtAnswer.text;
    }else if ([self.question.fieldTypeId isEqualToString:@"2"] || [self.question.fieldTypeId isEqualToString:@"3"]) {
        self.question.answer = [pickerData objectAtIndex:[self.answerPickerView selectedRowInComponent:0]];
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


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = pickerData[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor cs_getColorWithProperty:kColorPrimary]}];
    
    return attString;
    
}

@end