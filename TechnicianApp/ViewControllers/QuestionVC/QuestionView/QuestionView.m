//
//  QuestionView.m
//  Signature
//
//  Created by Iurie Manea on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "QuestionView.h"
#import "NAPickerView.h"

@interface QuestionView ()  <NAPickerViewDelegate>

@property (strong, nonatomic) NAPickerView *customPicker;
@property (nonatomic) NSInteger currentIndex;

@end


@implementation QuestionView

-(void)setup
{
    [super setup];
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    
    pickerData = [[NSMutableArray alloc] init];

    self.currentIndex = 0;
}


-(void)instantiatePicker {
    self.customPicker = [[NAPickerView alloc] initWithFrame:CGRectMake(0.f, 135.f, 368.f, 132.f)
                                                   andItems:pickerData
                                                andDelegate:self];
    self.customPicker.backgroundColor = [UIColor whiteColor];
    self.customPicker.showOverlay = YES;
    [self addSubview:self.customPicker];
}


-(void)setQuestion:(Question *)question
{
    _question = question;
    self.txtQuestion.text = question.question;
    
    if ([question.fieldTypeId isEqualToString:@"1"]) {
        self.txtAnswer.text = question.answer;
        self.txtAnswer.hidden = question.type.integerValue == kNoAnswerQuestion;
        self.txtAnswer.hidden = !question.haveNote;
        self.customPicker.hidden = YES;
    }else if ([question.fieldTypeId isEqualToString:@"2"]) {
        [self setUpYesNoPicker];
        [self instantiatePicker];
        self.customPicker.hidden = NO;
        self.txtAnswer.hidden = YES;
        if (question.answer) {
            [self.customPicker setIndex:[pickerData indexOfObject:question.answer]];
        }
    }else if ([question.fieldTypeId isEqualToString:@"3"]) {
        [self setUpYearsPicker];
        [self instantiatePicker];
        self.customPicker.hidden = NO;
        self.txtAnswer.hidden = YES;
        if (question.answer) {
            [self.customPicker setIndex:[pickerData indexOfObject:question.answer]];
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
        self.question.answer = [pickerData objectAtIndex:self.customPicker.selectedIndex];
    }
    
    [self.customPicker removeFromSuperview];
    self.customPicker.delegate = nil;
    self.customPicker = nil;
}



#pragma mark - NAPicker Delegate
- (void)didSelectedAtIndexDel:(NSInteger)index
{
    self.currentIndex = index;
}



@end