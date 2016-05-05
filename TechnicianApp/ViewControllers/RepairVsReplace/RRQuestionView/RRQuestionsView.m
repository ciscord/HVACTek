//
//  RRQuestionsView.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RRQuestionsView.h"
#import "DataLoader.h"
#import "NAPickerView.h"

@interface RRQuestionsView () <NAPickerViewDelegate>

@property (strong, nonatomic) NAPickerView *customPicker;

@end


@implementation RRQuestionsView


#pragma mark - Set Up
-(void)setup
{
    [super setup];
    [self configureColorScheme];
    
    pickerData = [[NSMutableArray alloc] init];
}


-(void)instantiatePicker {
    self.customPicker = [[NAPickerView alloc] initWithFrame:CGRectMake(0.f, 120.f, 368.f, 156.f)
                                                   andItems:pickerData
                                                andDelegate:self];
    self.customPicker.backgroundColor = [UIColor whiteColor];
    self.customPicker.showOverlay = YES;
    [self addSubview:self.customPicker];
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
}


-(void)setQuestionRR:(Question *)questionRR
{
    _questionRR = questionRR;
    self.questionTextView.text = questionRR.question;
    if ([questionRR.name isEqualToString:@"RR5"]) {
        NSString *yearString = questionRR.question;
        yearString = [yearString stringByReplacingOccurrencesOfString:@"5 Years"
                                             withString:self.systemLastPeriod];
        self.questionTextView.text = yearString;
    }
    
    
    
    if ([questionRR.fieldTypeId isEqualToString:@"1"]) {
        if (questionRR.answer) {
            self.answerTextField.text = questionRR.answer;
        }else{
            [self setDefaultAnswersforQuestion:questionRR];
        }
        self.answerTextField.hidden = questionRR.type.integerValue == kNoAnswerQuestion;
        self.answerTextField.hidden = !questionRR.haveNote;
    }else if ([questionRR.fieldTypeId isEqualToString:@"2"]) {
        [self setUpYesNoPicker];
        [self instantiatePicker];
        self.customPicker.hidden = NO;
        self.answerTextField.hidden = YES;
        if (questionRR.answer) {
            [self.customPicker setIndex:[pickerData indexOfObject:questionRR.answer]];
        }
    }else if ([questionRR.fieldTypeId isEqualToString:@"3"]) {
        [self setUpYearsPicker];
        [self instantiatePicker];
        self.customPicker.hidden = NO;
        self.answerTextField.hidden = YES;
        if (questionRR.answer) {
            [self.customPicker setIndex:[pickerData indexOfObject:questionRR.answer]];
        }
    }
}


- (void)setDefaultAnswersforQuestion:(Question *)question {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if ([question.name isEqualToString:@"RR5"]) {
        if (job.utilityOverpaymentHVAC) {
           // self.answerTextField.text = job.utilityOverpaymentHVAC;
            self.answerTextField.text = [self getValueOfUtilityOverpayment];  //multiplying by number of years
        }else{
            self.answerTextField.text = @"$0";
            job.utilityOverpaymentHVAC = self.answerTextField.text;
            [job.managedObjectContext save];
        }
    }else if ([question.name isEqualToString:@"RR6"]) {
        self.answerTextField.text = @"$250";
    }else if ([question.name isEqualToString:@"RR7"]) {
        self.answerTextField.text = @"$500";
    }else{
        self.answerTextField.text = @"$0";
    }
}


- (NSString *)getValueOfUtilityOverpayment {
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:NO];
    [paymentFormatter setMaximumFractionDigits:0];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    int uOverpayment = 0;
    NSNumber *number = [paymentFormatter numberFromString:job.utilityOverpaymentHVAC];
    uOverpayment = [number intValue] / 5  * self.systemLastPeriod.intValue;
    
    return [paymentFormatter stringFromNumber:[NSNumber numberWithInt:uOverpayment]];
}




#pragma mark - SetUp Picker
-(void)setUpYearsPicker {
    [pickerData removeAllObjects];
    for (int i = 1; i < 31; i++) {
        if (i == 30)
            [pickerData addObject:[NSString stringWithFormat:@"%d+ Years", i]];
        else{
            if (i == 1)
                [pickerData addObject:[NSString stringWithFormat:@"%d Year", i]];
            else
                [pickerData addObject:[NSString stringWithFormat:@"%d Years", i]];
        }
    }
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
        self.questionRR.answer = [pickerData objectAtIndex:[self.customPicker selectedIndex]];
    }
    
    [self.customPicker removeFromSuperview];
    self.customPicker.delegate = nil;
    self.customPicker = nil;
}






#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self isDefaultPriceAnswers]) {
        if (textField.text.length  == 0)
        {
            textField.text = @"$0";
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
        [paymentFormatter setGeneratesDecimalNumbers:NO];
        [paymentFormatter setMaximumFractionDigits:0];
        
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
        
//        NSDecimalNumber *paymentPence = [NSDecimalNumber decimalNumberWithString:penceString];
//        [textField setText:[paymentFormatter stringFromNumber:[paymentPence decimalNumberByMultiplyingByPowerOf10:-2]]];
        
        NSNumber *someAmount = [NSNumber numberWithDouble:[penceString doubleValue]];
        [textField setText:[paymentFormatter stringFromNumber:someAmount]];
        
        
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


#pragma mark - NAPicker Delegate
- (void)didSelectedAtIndexDel:(NSInteger)index
{
    //self.currentIndex = index;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
