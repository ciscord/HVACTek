//
//  LoginVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isTitleViewHidden = YES;
    self.mainContentView.layer.borderWidth = 1;
    self.mainContentView.layer.borderColor = [[UIColor colorWithRed:143./255 green:200./255 blue:73./255 alpha:0.8] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnContinueTouch:(id)sender
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [[DataLoader sharedInstance] loginWithUsername:self.txtUser.text
                                       andPassword:self.txtPassword.text
                                         onSuccess:^(NSString *successMessage) {
                                             
                                             [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                             [weakSelf performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
                                         }
                                           onError:^(NSError *error) {
                                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                               ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                           }];
    
}

@end
