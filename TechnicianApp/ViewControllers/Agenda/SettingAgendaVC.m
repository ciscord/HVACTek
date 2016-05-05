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

@property (weak, nonatomic) IBOutlet UILabel *presentationLbl;
@property (weak, nonatomic) IBOutlet UILabel *thankLbl;
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (nonatomic, strong) NSString *techName;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *costumerName;

@property (weak, nonatomic) IBOutlet UIButton *continuBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;


@end

@implementation SettingAgendaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureColorScheme];
    
    self.title = NSLocalizedString(@"Setting The Agenda", nil);
    
    [self configureVC];
    
    
    
    //[[[DataLoader sharedInstance] SWAPIManager] whoList]
}



#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continuBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label2.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label3.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label4.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label5.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label6.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label7.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label8.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.presentationLbl.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.thankLbl.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.introduceLbl.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ConfigureVC
- (void)configureVC {
    
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
    self.presentationLbl.text = [NSString stringWithFormat:@"Hello, My name is %@ from %@.", self.techName, self.companyName];
    self.thankLbl.text = [NSString stringWithFormat:@"I want to thank you for choosing %@ to service you today.", self.companyName];
    self.introduceLbl.text = [NSString stringWithFormat:@"I understand I am here today for (........................), is that correct?  Before I get started today I would like to let you know what you can expect from today's call."];   //self.costumerName
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
    
    if ([segue.identifier isEqualToString:@"goPictureAgenda"]) {
        AgendaPictureVC *vc = segue.destinationViewController;
        vc.choosedType = self.choosenType;
    }
}


@end
