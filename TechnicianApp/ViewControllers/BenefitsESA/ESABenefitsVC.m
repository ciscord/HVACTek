//
//  ESABenefitsVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ESABenefitsVC.h"
#import "QuestionsVC.h"
#import "UtilityOverpaymentVC.h"
#import "MediaLibraryVC.h"
@interface ESABenefitsVC ()

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *esaLabel;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@end

@implementation ESABenefitsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Maintenance Agreement", nil);
    
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
    
    self.discountLabel.numberOfLines = 0;
    self.discountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.discountView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self configureColorScheme];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > ESABenefits) {
        QuestionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC1"];
        currentViewController.questionType = qtTechnician;
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:ESABenefits];
    }
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = ESABenefits;
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.libraryButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label0.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label2.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label3.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
   // self.label.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (IBAction)continueButtonClicked:(id)sender {
    if ([[DataLoader sharedInstance] currentJobCallType] == qtPlumbing)
        [self performSegueWithIdentifier:@"showPlumbingUtilityOverpayment" sender:self];
    else
        [self performSegueWithIdentifier:@"showTechnicianQuestionsSection" sender:self];
    
}
- (IBAction)libraryButtonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    
    MediaLibraryVC* mediaLibraryVC = [storyboard instantiateViewControllerWithIdentifier:@"MediaLibraryVC"];
    [self.navigationController pushViewController:mediaLibraryVC animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[QuestionsVC class]]) {
        QuestionsVC *currentViewController = segue.destinationViewController;
        currentViewController.questionType = qtTechnician;
        [DataLoader saveQuestionType:qtTechnician];
    }
    
}

@end
