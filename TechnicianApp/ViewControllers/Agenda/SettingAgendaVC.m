//
//  SettingAgendaVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "SettingAgendaVC.h"
#import "AgendaPictureVC.h"

@interface SettingAgendaVC ()

@property (weak, nonatomic) IBOutlet UITextView *presentationLbl;
@property (nonatomic, strong) NSString *techName;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *costumerName;

@property (weak, nonatomic) IBOutlet UIButton *continuBtn;


@end

@implementation SettingAgendaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureColorScheme];
    
    self.title = NSLocalizedString(@"Setting The Agenda", nil);
    
    [self configureVC];
    self.choosenType = [DataLoader loadQuestionType];
    [[TechDataModel sharedTechDataModel] saveCurrentStep:SettingAgenda];
}



#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continuBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.presentationLbl.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ConfigureVC
- (void)configureVC {
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    NSDictionary *jobInfo = job.swapiJobInfo;
    NSArray *list = [jobInfo objectForKey:@"whoList"];
    
    for (NSDictionary *employee in list) {
        if ([employee[@"EmployeeCode"] isEqualToString:[[[DataLoader sharedInstance] currentUser] userCode]]) {
            self.techName = [NSString stringWithFormat:@"%@ %@", employee[@"FirstName"], employee[@"LastName"]];
        }
    }
    
    self.costumerName = [NSString stringWithFormat:@"%@ %@", [jobInfo objectForKey:@"FirstName"], [jobInfo objectForKey:@"LastName"]];
    self.companyName = [[[DataLoader sharedInstance] currentCompany] business_name];
    
    [self setLabelsTexts];
    
}

- (void)setLabelsTexts {
    self.presentationLbl.text = [NSString stringWithFormat:@"My Name Is %@ From %@ \n \nThank You For Choosing %@ To Service You Today \n \nAm I OK Where I Am Parked? \n \n Is It OK To Come In? \n \nLet Me Put My Shoe Covers On \n \n I Understand I Am Here Today For %@\nCan You Tell Me A Little Bit More About What's Going On \n \nI Would Like To Share With You What You Can Expect From Today's Call \n \n First I'm Going To Ask You A Few Questions To Help Me Do My Job Better & Then I Will Answer Any Questions You Have \n \n Next I'm Going To Do A Thorough Evaluation Of Your Entire System \n \n If I Notice Anything That May Be A Safety, Health Or Mechanical Concern, Is It OK If I Bring It To Your Attention? \n \nRest Assured I Will Not Do Any Work Without Your Approval \n \nIf There Are Any Issues That Do Need Attention\nI Will Do Everything I Can To Take Care Of Them For You Today %@ Fair Enough? \n \n It Will Take Me About ... (Minutes / Hours)\nTo Provide You With A Great Service Experience Today...Are We OK On Time? \n \n Is There Somewhere We Can Sit Down For A Few Minutes \nSo We Can Start With My Questions?", self.techName, self.companyName, self.companyName, @"You", @""];
    
}


- (IBAction)choiseBtnClicked:(id)sender {
    UIButton *button = sender;
    
    if (!button.selected)
        button.selected = YES;
    else
        button.selected = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
