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
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    self.discountLabel.numberOfLines = 0;
    self.discountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.discountView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self configureColorScheme];
    
    [[TechDataModel sharedTechDataModel] saveCurrentStep:ESABenefits];
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
        
        [DataLoader saveQuestionType:qtTechnician];
    }
    
}

@end
