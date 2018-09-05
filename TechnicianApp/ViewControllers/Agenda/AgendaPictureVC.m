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

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIView *agendaView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label;

@property (weak, nonatomic) IBOutlet UIView *view1;


@end

@implementation AgendaPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureColorScheme];
    
    self.title = NSLocalizedString(@"Expectations", nil);
    
    UIColor* titleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 45,25)];
    [someButton setTitle:@" IAQ " forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(tapIAQButton)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    someButton.layer.borderWidth = 1;
    someButton.layer.borderColor = titleColor.CGColor;
    [someButton setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *iaqButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > AgendaPicture) {
        QuestionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC"];
        currentViewController.questionType = [DataLoader loadQuestionType];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:AgendaPicture];
    }
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = AgendaPicture;
}
#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.agendaView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.view1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    for (UILabel* labelItem in self.label) {
        labelItem.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        
    }
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
    
    
    job.startTimeQuestions = [NSDate date];
    [job.managedObjectContext save];
    
    [self performSegueWithIdentifier:@"customerQuestionsSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"customerQuestionsSegue"]) {
        QuestionsVC *vc = segue.destinationViewController;
        vc.questionType = [DataLoader loadQuestionType];
    }

    
}


@end
