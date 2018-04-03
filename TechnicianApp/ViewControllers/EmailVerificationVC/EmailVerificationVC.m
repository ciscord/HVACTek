//
//  EmailVerificationVC.m
//  HvacTek
//
//  Created by Dorin on 5/20/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "EmailVerificationVC.h"
#import "StringBetweenStrings.h"

@interface EmailVerificationVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet RoundCornerView *roundedView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *sentButton;

@end

@implementation EmailVerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self configureColorScheme];
    [self configureVC];
    [[TechDataModel sharedTechDataModel] saveCurrentStep:EmailVerification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    self.roundedView.layer.borderWidth   = 3.0;
    self.roundedView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
    self.emailTextField.layer.borderWidth   = .5;
    self.emailTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.emailTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.emailTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



- (void)configureVC {
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    NSDictionary *jobInfo = job.swapiJobInfo;
    self.emailTextField.text = jobInfo[@"Email"];
}


#pragma mark - Button Actions
- (IBAction)editClicked:(id)sender {
    [self startEditingEmail:YES];
}


- (IBAction)sentClicked:(id)sender {
    if ([self validateEmailWithString:self.emailTextField.text]) {
        Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
        NSDictionary *jobInfo = job.swapiJobInfo;
        if ([self.emailTextField.text isEqualToString:jobInfo[@"Email"]]) {
            [self performSegueWithIdentifier:@"unwindToNewCustumerChoicePageFromEmailVerification" sender:self];
        }else{
            [self updateUserAccountInfo];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please provide a valid email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self startEditingEmail:YES];
    }
}


- (IBAction)saveClicked:(id)sender {
    if ([self validateEmailWithString:self.emailTextField.text]) {
        [self startEditingEmail:NO];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please provide a valid email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - Editing Email
- (void)startEditingEmail:(BOOL)editing {
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonsView.alpha = !editing;
        self.saveButton.alpha = editing;
    } completion:^(BOOL finished) {
        self.buttonsView.hidden = editing;
        self.saveButton.hidden = !editing;
        self.emailTextField.enabled = editing;
    }];
}



- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Upate User SWAPI Info
- (void)updateUserAccountInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    NSDictionary *jobInfo = job.swapiJobInfo;
    
    [[[DataLoader sharedInstance] SWAPIManager] connectOnSuccess:^(NSString *successMessage) {
        [[[DataLoader sharedInstance] SWAPIManager] getUserLocationInfoQueryWithLocationID:jobInfo[@"LocationID"] OnSuccess:^(NSString *account) {
            [[[DataLoader sharedInstance] SWAPIManager] userLocationInfoUpdateWithData:account andNewEmail:self.emailTextField.text OnSuccess:^(NSString *message) {
                
                [self updateJobInfoWithDictionary:jobInfo andJob:job];
                [self succesfullAlert];
                
            } onError:^(NSError *error) {
                [self showFailedAlert];
            }];
        } onError:^(NSError *error) {
            [self showFailedAlert];
        }];
    } onError:^(NSError *error) {
        [self showFailedAlert];
    }];
}



#pragma mark - Update Local Job Info
- (void)updateJobInfoWithDictionary:(NSDictionary *)dict andJob:(Job *)jobObj{
    NSMutableDictionary *testDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//    if ([dict[@"Email"] isEqualToString:dict[@"AccountEmail"]]) {
//        [testDict setObject:self.emailTextField.text forKey:@"AccountEmail"];
//    }
    [testDict setObject:self.emailTextField.text forKey:@"Email"];
    [testDict setObject:self.emailTextField.text forKey:@"EmailAddress"];
    jobObj.swapiJobInfo = testDict;
    [jobObj.managedObjectContext save];
}


#pragma mark - Show Alerts
- (void)succesfullAlert {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *alert= [UIAlertController alertControllerWithTitle: @""
                                                                  message: @"Email address was successfully changed"
                                                           preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   [self performSegueWithIdentifier:@"unwindToNewCustumerChoicePageFromEmailVerification" sender:self];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showFailedAlert {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *alert= [UIAlertController alertControllerWithTitle: @""
                                                                  message: @"Oops. Something went wrong. Please try again later."
                                                           preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
