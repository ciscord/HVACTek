//
//  RRQuestionsView.h
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RoundCornerView.h"
#import "Question.h"

@interface RRQuestionsView : RoundCornerView <UITextFieldDelegate>
{
    NSMutableArray *pickerData;
}

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) Question *questionRR;
@property (weak, nonatomic) IBOutlet UIView *sep1;
@property (weak, nonatomic) IBOutlet UIView *sep2;


@property (copy, nonatomic) void (^OnBackButtonTouch)(RRQuestionsView *sender);
@property (copy, nonatomic) void (^OnNextButtonTouch)(RRQuestionsView *sender);



@end
