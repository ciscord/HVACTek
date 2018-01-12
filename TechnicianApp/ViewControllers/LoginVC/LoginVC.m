//
//  LoginVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "LoginVC.h"
#import "CompanyAditionalInfo.h"


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtAPI;

-(void)login;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isTitleViewHidden = YES;
    self.mainContentView.layer.borderWidth = 1;
    self.mainContentView.layer.borderColor = [[UIColor colorWithRed:44./255 green:121./255 blue:185./255 alpha:1.0] CGColor];

    NSUserDefaults * userPassword = [NSUserDefaults standardUserDefaults];
    if ([userPassword valueForKey:@"us"]&&[userPassword valueForKey:@"pw"] && [userPassword valueForKey:@"companyAPI"]) {
        self.txtUser.text = [userPassword valueForKey:@"us"];
        self.txtPassword.text = [userPassword valueForKey:@"pw"];
        self.txtAPI.text = [userPassword valueForKey:@"companyAPI"];
        [self performSelector:@selector(login) withObject:self afterDelay:1];
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
- (IBAction)btnContinueTouch:(id)sender {
    [self login];
}

-(void)login{    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [[DataLoader sharedInstance] loginWithUsername:self.txtUser.text
                                          password:self.txtPassword.text
                                         onSuccess:^(NSString *successMessage) {
                                               NSUserDefaults * userPassword = [NSUserDefaults standardUserDefaults];
                                             [userPassword setObject:weakSelf.txtUser.text forKey:@"us"];
                                             [userPassword setObject:weakSelf.txtPassword.text forKey:@"pw"];
                                             [userPassword setObject:weakSelf.txtAPI.text forKey:@"companyAPI"];
                                             [userPassword synchronize];
                                             
                                             //[MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                             
                                             [weakSelf performSelectorOnMainThread:@selector(loadAdditionalInfo) withObject:nil waitUntilDone:NO];
                                             //[weakSelf performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
                                         }
                                           onError:^(NSError *error) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               if (error.code != 404) {
                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                               }
                                               
                                           }];
  
}

#pragma mark - Load Aditional Info
- (void)loadAdditionalInfo {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataLoader sharedInstance] getAdditionalInfoOnSuccess:^(NSDictionary *infoDict) {
        if (infoDict.count)
            [DataLoader sharedInstance].companyAdditionalInfo = [self saveAdditionalInfoFromDict:infoDict];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
    }onError:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        ShowOkAlertWithTitle(error.localizedDescription, self);
    }];
}


- (NSArray *)saveAdditionalInfoFromDict:(NSDictionary *)dict {
    
    NSMutableArray *additionalObjects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *docDict in dict[@"1"][@"rows"]) {
        CompanyAditionalInfo *info = [CompanyAditionalInfo companyAdditionalInfoWithID:docDict[@"id"]
                                                                      info_description:docDict[@"description"]
                                                                            info_title:docDict[@"title"]
                                                                              info_url:docDict[@"url"]
                                                                               isVideo:NO
                                                                             isPicture:NO];
        [additionalObjects addObject:info];
    }
    
    for (NSDictionary *videoDict in dict[@"2"][@"rows"]) {
        CompanyAditionalInfo *info = [CompanyAditionalInfo companyAdditionalInfoWithID:videoDict[@"id"]
                                                                      info_description:videoDict[@"description"]
                                                                            info_title:videoDict[@"title"]
                                                                              info_url:videoDict[@"url"]
                                                                               isVideo:YES
                                                                             isPicture:NO];
        [additionalObjects addObject:info];
    }
    
    for (NSDictionary *imageDict in dict[@"3"][@"rows"]) {
        CompanyAditionalInfo *info = [CompanyAditionalInfo companyAdditionalInfoWithID:imageDict[@"id"]
                                                                      info_description:imageDict[@"description"]
                                                                            info_title:imageDict[@"title"]
                                                                              info_url:imageDict[@"url"]
                                                                               isVideo:NO
                                                                             isPicture:YES];
        [additionalObjects addObject:info];
    }
    
    return additionalObjects;
}

@end
