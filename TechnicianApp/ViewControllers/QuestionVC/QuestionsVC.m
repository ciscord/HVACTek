//
//  QuestionVC.m
//  Signature
//
//  Created by Iurie Manea on 10.12.2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "QuestionsVC.h"
#import "QuestionView.h"
#import "ExploreSummaryVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import <BCGenieEffect/UIView+Genie.h>

@interface QuestionsVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *vwContent;
@property(nonatomic, assign) NSInteger currentQuestionIndex;
@property(nonatomic, strong) QuestionView *currentQuestionView;
@property(nonatomic, strong) QuestionView *nextQuestionView;

@end

@implementation QuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = (self.questionType == qtTechnician ? @"Tech Observations" : @"Explore Summary");
    
    __weak typeof(self) weakSelf = self;
    [[DataLoader sharedInstance] getQuestionsOfType:self.questionType
                                          onSuccess:^(NSArray *resultQuestions) {
                                              
                                              weakSelf.questions = resultQuestions;
                                              [weakSelf prepareQuestionToDisplay];
                                          } onError:^(NSError *error) {
                                              
                                          }];
}

-(void)prepareQuestionToDisplay
{
    __weak typeof(self) weakSelf = self;
    
    void (^onBackButtonTouch)(QuestionView *sender) = ^(QuestionView *view) {
        weakSelf.currentQuestionIndex--;
        if (weakSelf.currentQuestionIndex>=0)
        {
            [weakSelf showNextQuestionView:view moveFromRightToLeft:NO];
        }
        else
        {
            weakSelf.currentQuestionIndex = 0;
        }
    };
    
    void (^onNextButtonTouch)(QuestionView *sender) = ^(QuestionView *view) {
        
        if (view.question.required && view.question.answer.length == 0) {
            
            ShowOkAlertWithTitle(@"This question is required", weakSelf);
        }
        else {
            weakSelf.currentQuestionIndex++;
            if (weakSelf.currentQuestionIndex<=weakSelf.questions.count)
            {
                [weakSelf showNextQuestionView:view  moveFromRightToLeft:YES];
            }
            else
            {
                weakSelf.currentQuestionIndex = weakSelf.questions.count-1;
            }
        }
    };
    
    self.currentQuestionView = [[[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:self options:nil] firstObject];
    self.currentQuestionView.center = CGPointMake(self.vwContent.middlePoint.x, self.questionY);
    self.currentQuestionView.question = _questions.firstObject;
    [self.currentQuestionView setOnBackButtonTouch:onBackButtonTouch];
    [self.currentQuestionView setOnNextButtonTouch:onNextButtonTouch];
    
    
    self.nextQuestionView = [[[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:self options:nil] firstObject];
    self.nextQuestionView.center = CGPointMake(self.vwContent.middlePoint.x, self.questionY);
    [self.nextQuestionView setOnBackButtonTouch:onBackButtonTouch];
    [self.nextQuestionView setOnNextButtonTouch:onNextButtonTouch];
    
    [self.vwContent addSubview:self.nextQuestionView];
    [self.vwContent addSubview:self.currentQuestionView];
    
    self.nextQuestionView.hidden = YES;
    CGRect endRect = CGRectMake(0, self.questionY, -50, 60);
    [self.nextQuestionView genieInTransitionWithDuration:0.05
                                         destinationRect:endRect
                                         destinationEdge:BCRectEdgeRight
                                              completion:^{
                                                  weakSelf.nextQuestionView.hidden = NO;
                                              }];
}

-(CGFloat)questionY
{
    return self.vwContent.middleY - (self.view.middleY - self.vwContent.middleY) + 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setQuestions:(NSArray *)questions
{
    //disable questions
//    NSMutableArray *arr = questions.mutableCopy;
//    if (self.questionType != qtTechnician)
//    {
//        [arr addObject:[[Question alloc] initWithDictionary:@{kQuestionIDKey : @(0), kQuestionTypeKey : @(kNoAnswerQuestion),
//                                                              kQuestionQuestionKey : @"Thank you\nYou have completed the questions.\nPlease return the device to your technician."}]];
//    }
    
    //activate questions
    _questions = questions;
}

-(void)showNextQuestionView:(QuestionView*)currentView moveFromRightToLeft:(BOOL)moveFromRightToLeft
{
    QuestionView *nextView = (currentView == self.currentQuestionView ? self.nextQuestionView : self.currentQuestionView);
    if (self.currentQuestionIndex>=0 && self.currentQuestionIndex<self.questions.count)
    {
        __weak typeof(self) weakSelf = self;
        nextView.question = weakSelf.questions[weakSelf.currentQuestionIndex];
        if (moveFromRightToLeft)
        {
            CGRect endRect = CGRectMake(0, weakSelf.questionY, -50, 60);
            [currentView genieInTransitionWithDuration:0.4
                                       destinationRect:endRect
                                       destinationEdge:BCRectEdgeRight
                                            completion:^{
                                                
                                                CGRect startRect = CGRectMake(weakSelf.vwContent.width, weakSelf.questionY, 50, 60);
                                                [nextView genieOutTransitionWithDuration:0.4
                                                                               startRect:startRect
                                                                               startEdge:BCRectEdgeLeft
                                                                              completion:nil];
                                            }];
        }
        else
        {
            CGRect endRect = CGRectMake(weakSelf.view.width, weakSelf.questionY, 50, 60);
            [currentView genieInTransitionWithDuration:0.4
                                       destinationRect:endRect
                                       destinationEdge:BCRectEdgeLeft
                                            completion:^{
                                                
                                                CGRect startRect = CGRectMake(0, weakSelf.questionY, -50, 60);
                                                [nextView genieOutTransitionWithDuration:0.4
                                                                               startRect:startRect
                                                                               startEdge:BCRectEdgeRight
                                                                              completion:nil];
                                            }];
        }
        [nextView.txtAnswer becomeFirstResponder];
    }
    else
    {
        /* Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
         if (!job.startTime) {
         job.startTime = [NSDate date];
         [job.managedObjectContext save];
         }*/
        self.currentQuestionIndex--;
        Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
        if (self.questionType!=qtTechnician) {
            
            if (!job.endTimeQuestions) {
                job.endTimeQuestions = [NSDate date];
                [job.managedObjectContext save];
            }
        }
        
       
        if (self.questionType == qtTechnician) {
            job.techObservations = self.questions;
            [job.managedObjectContext save];
            //[self performSegueWithIdentifier:@"selectOptionsIpadRepairsSegue" sender:self];
            [self performSegueWithIdentifier:@"showUtilityOverpayment" sender:self];
        } else
        {
            job.custumerQuestions = self.questions;
            [job.managedObjectContext save];
            [self performSegueWithIdentifier:@"exploreSummarySegue" sender:self];
        }
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[ExploreSummaryVC class]])
    {
        ExploreSummaryVC *vc = (ExploreSummaryVC*)segue.destinationViewController;
        NSMutableArray *arr = _questions.mutableCopy;
        [arr removeLastObject];
        vc.questions = arr;
    }
//    else if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsOptionsVC class]])
//    {
//        SummaryOfFindingsOptionsVC *vc = (SummaryOfFindingsOptionsVC*)segue.destinationViewController;
//        vc.isiPadCommonRepairsOptions = YES;
//    }
}


@end
