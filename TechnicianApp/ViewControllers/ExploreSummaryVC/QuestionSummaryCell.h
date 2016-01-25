//
//  QuestionSummaryCell.h
//  Signature
//
//  Created by Iurie Manea on 1/9/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HvakTekColorScheme.h"

@interface QuestionSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *lbQuestion;
@property (weak, nonatomic) IBOutlet UITextView *lbAnswer;
@end
