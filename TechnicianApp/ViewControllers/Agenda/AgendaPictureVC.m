//
//  AgendaPictureVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "AgendaPictureVC.h"
#import "QuestionsVC.h"

@interface AgendaPictureVC ()


@end

@implementation AgendaPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Agenda Picture", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueBtnClicked:(UIButton *)sender {

    
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (!job.startTime) {
        job.startTime = [NSDate date];
        [job.managedObjectContext save];
    }
    //    if (!job.startTimeQuestions) {
    //        job.startTimeQuestions = [NSDate date];
    //        [job.managedObjectContext save];
    //    }
    
    job.startTimeQuestions = [NSDate date];
    [job.managedObjectContext save];
    
    [self performSegueWithIdentifier:@"customerQuestionsSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"customerQuestionsSegue"]) {
        QuestionsVC *vc = segue.destinationViewController;
        vc.questionType = self.choosedType;
    }
    
}


@end
