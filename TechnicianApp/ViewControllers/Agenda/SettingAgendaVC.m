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
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > SettingAgenda) {
        AgendaPictureVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AgendaPictureVC"];

        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:SettingAgenda];
    }
    
    
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
    
    NSString *infoString = @"Introduce Yourself: My Name Is ... From ... \n \nThank You: Thank You For Choosing ... To Service You Today \n \nParked OK: Am I OK Where I Am Parked? \n \nOk To Come In: Is It OK To Come In? \n \nShoe Covers: Let Me Put My Shoe Covers On \n \nConfirm Why You're There: I Understand I Am Here Today For ...\nCan You Tell Me A Little Bit More About What's Going On \n \nSet Expectations For Today's Call: I Would Like To Share With You What You Can Expect From Today's Call \n \nAsk & Answer Questions: First I'm Going To Ask You A Few Questions To Help Me Do My Job Better & Then I Will Answer Any Questions You Have \n \nThorough Evaluation Of Entire System: Next I'm Going To Do A Thorough Evaluation Of Your Entire System \n \nObservations That Need Attention: If I Notice Anything That May Be A Safety, Health Or Mechanical Concern, Is It OK If I Bring It To Your Attention? \n \nNo Work w/o Your Approval: Rest Assured I Will Not Do Any Work Without Your Approval \n \nComplete Work Today: If There Are Any Issues That Do Need Attention\nI Will Do Everything I Can To Take Care Of Them For You Today ... Fair Enough? \n \nTime Frame: It Will Take Me About ... (Minutes / Hours)\nTo Provide You With A Great Service Experience Today...Are We OK On Time? \n \nKitchen Table: Is There Somewhere We Can Sit Down For A Few Minutes \nSo We Can Start With My Questions?";
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:infoString];
    
    UIFont *font_bold=[UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Introduce Yourself:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Thank You:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Parked OK:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Ok To Come In:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Shoe Covers:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Confirm Why You're There:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Set Expectations For Today's Call:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Ask & Answer Questions:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Thorough Evaluation Of Entire System:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Observations That Need Attention:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"No Work w/o Your Approval:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Complete Work Today:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Time Frame:"]];
    [attString addAttribute:NSFontAttributeName value:font_bold range:[infoString rangeOfString:@"Kitchen Table:"]];
    
    //add color
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor cs_getColorWithProperty:kColorPrimary] range:NSMakeRange(0, infoString.length)];

    [self.presentationLbl setAttributedText:attString];
    
    
    self.presentationLbl.editable = false;
    self.presentationLbl.selectable = false;
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
