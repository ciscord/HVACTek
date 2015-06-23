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

-(void)login;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isTitleViewHidden = YES;
    self.mainContentView.layer.borderWidth = 1;
    self.mainContentView.layer.borderColor = [[UIColor colorWithRed:143./255 green:200./255 blue:73./255 alpha:0.8] CGColor];
    
    NSUserDefaults * userPassword = [NSUserDefaults standardUserDefaults];
    if ([userPassword valueForKey:@"us"]&&[userPassword valueForKey:@"pw"]) {
        self.txtUser.text = [userPassword valueForKey:@"us"];
        self.txtPassword.text = [userPassword valueForKey:@"pw"];
        [self performSelector:@selector(login) withObject:self afterDelay:0.2];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
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
    [self login];
}

-(void)login{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [[DataLoader sharedInstance] loginWithUsername:self.txtUser.text
                                       andPassword:self.txtPassword.text
                                         onSuccess:^(NSString *successMessage) {
                                               NSUserDefaults * userPassword = [NSUserDefaults standardUserDefaults];
                                             [userPassword setObject:weakSelf.txtUser.text forKey:@"us"];
                                             [userPassword setObject:weakSelf.txtPassword.text forKey:@"pw"];
                                             [userPassword synchronize];
                                             
                                             [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                             [weakSelf performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
                                         }
                                           onError:^(NSError *error) {
                                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                               ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                           }];
  
}
@end
