//
//  RRQuestionsView.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RRQuestionsView.h"
#import "DataLoader.h"

@implementation RRQuestionsView


#pragma mark - Set Up
-(void)setup
{
    [super setup];
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithRed:239./255. green:246./255. blue:226./255. alpha:1.];
    
    pickerData = [[NSMutableArray alloc] init];
}



-(void)setQuestionRR:(Question *)questionRR
{
    _questionRR = questionRR;
    self.questionTextView.text = questionRR.question;
    
    if ([questionRR.fieldTypeId isEqualToString:@"1"]) {
        if (questionRR.answer) {
            self.answerTextField.text = questionRR.answer;
        }else{
            [self setDefaultAnswersforQuestion:questionRR];
        }
        self.answerTextField.hidden = questionRR.type.integerValue == kNoAnswerQuestion;
        self.answerTextField.hidden = !questionRR.haveNote;
        self.answerPickerView.hidden = YES;
    }else if ([questionRR.fieldTypeId isEqualToString:@"2"]) {
        [self setUpYesNoPicker];
        self.answerPickerView.hidden = NO;
        self.answerTextField.hidden = YES;
        if (questionRR.answer) {
           [self.answerPickerView selectRow:[pickerData indexOfObject:questionRR.answer] inComponent:0 animated:YES];
        }
        [self.answerPickerView reloadAllComponents];
    }else if ([questionRR.fieldTypeId isEqualToString:@"3"]) {
        [self setUpYearsPicker];
        self.answerPickerView.hidden = NO;
        self.answerTextField.hidden = YES;
        if (questionRR.answer) {
            [self.answerPickerView selectRow:[pickerData indexOfObject:questionRR.answer] inComponent:0 animated:YES];
        }
    }
}


- (void)setDefaultAnswersforQuestion:(Question *)question {
    if ([question.name isEqualToString:@"RR5"]) {
        if ([[DataLoader sharedInstance] utilityOverpaymentHVAC]) {
            self.answerTextField.text = [[DataLoader sharedInstance] utilityOverpaymentHVAC];
        }else{
            self.answerTextField.text = @"$0.00";
            [DataLoader sharedInstance].utilityOverpaymentHVAC = self.answerTextField.text;
        }
    }else if ([question.name isEqualToString:@"RR6"]) {
        self.answerTextField.text = @"$250.00";
    }else if ([question.name isEqualToString:@"RR7"]) {
        self.answerTextField.text = @"$500.00";
    }else{
        self.answerTextField.text = @"$0.00";
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
- (IBAction)backBtnClicked:(UIButton *)sender {
    [self setQuestionAnswer];
    if (self.OnBackButtonTouch)
    {
        self.OnBackButtonTouch(self);
    }
}


- (IBAction)nextBtnClicked:(UIButton *)sender {
    
    [self setQuestionAnswer];
    if (self.OnNextButtonTouch)
    {
        self.OnNextButtonTouch(self);
    }
}



- (void)setQuestionAnswer {
    if ([self.questionRR.fieldTypeId isEqualToString:@"1"]) {
        self.questionRR.answer = self.answerTextField.text;
    }else if ([self.questionRR.fieldTypeId isEqualToString:@"2"] || [self.questionRR.fieldTypeId isEqualToString:@"3"]) {
        self.questionRR.answer = [pickerData objectAtIndex:[self.answerPickerView selectedRowInComponent:0]];
    }
}






#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self isDefaultPriceAnswers]) {
        if (textField.text.length  == 0)
        {
            textField.text = @"$0.00";
        }
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self isDefaultPriceAnswers]) {
        NSMutableString *mutableString = [[textField text] mutableCopy];
        
        NSLocale *local = [NSLocale currentLocale];
        NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
        [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [paymentFormatter setLocale:local];
        [paymentFormatter setGeneratesDecimalNumbers:YES];
        
        if ([mutableString length] == 0) {
            [mutableString setString:[local objectForKey:NSLocaleCurrencySymbol]];
            [mutableString appendString:string];
        } else {
            if ([string length] > 0) {
                [mutableString insertString:string atIndex:range.location];
            } else {
                [mutableString deleteCharactersInRange:range];
            }
        }
        
        NSString *penceString = [[[mutableString stringByReplacingOccurrencesOfString:
                                   [local objectForKey:NSLocaleDecimalSeparator] withString:@""]
                                  stringByReplacingOccurrencesOfString:
                                  [local objectForKey:NSLocaleCurrencySymbol] withString:@""]
                                 stringByReplacingOccurrencesOfString:
                                 [local objectForKey:NSLocaleGroupingSeparator] withString:@""];
        
        NSDecimalNumber *paymentPence = [NSDecimalNumber decimalNumberWithString:penceString];
        
        [textField setText:[paymentFormatter stringFromNumber:[paymentPence decimalNumberByMultiplyingByPowerOf10:-2]]];
        
        return NO;
    }else{
        return YES;
    }
}


- (BOOL)isDefaultPriceAnswers {
    if ([_questionRR.name isEqualToString:@"RR1"] || [_questionRR.name isEqualToString:@"RR2"])
        return NO;
    else
        return YES;
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
