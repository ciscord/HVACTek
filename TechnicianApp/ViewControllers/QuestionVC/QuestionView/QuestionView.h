//
//  QuestionView.h
//  Signature
//
//  Created by Iurie Manea on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "RoundCornerView.h"
#import "Question.h"

@interface QuestionView : RoundCornerView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *pickerData;
}

@property (weak, nonatomic) IBOutlet UITextView *txtQuestion;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswer;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIPickerView *answerPickerView;
@property (weak, nonatomic) Question *question;
@property (weak, nonatomic) IBOutlet UIView *separator1;
@property (weak, nonatomic) IBOutlet UIView *separator2;



@property (copy, nonatomic) void (^OnBackButtonTouch)(QuestionView *sender);
@property (copy, nonatomic) void (^OnNextButtonTouch)(QuestionView *sender);

@end
