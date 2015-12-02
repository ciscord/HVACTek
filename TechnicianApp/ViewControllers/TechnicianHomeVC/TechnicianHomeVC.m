//
//  TechnicianHomeVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "TechnicianHomeVC.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface TechnicianHomeVC ()
@property (weak, nonatomic) IBOutlet UIView *vwDebrief;
@property (strong, nonatomic) IBOutlet UITextField *edtJobId;

@end

@implementation TechnicianHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.homeController = self;
    
    
   /// [self performSegueWithIdentifier:@"showWorkVC" sender:self];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self checkJobStatus];
    
    self.edtJobId.layer.borderWidth = 0.5;
    self.edtJobId.layer.borderColor = [[UIColor colorWithRed:118./255 green:189./255 blue:29./255 alpha:1.] CGColor];

}

- (void)getNextJob {
    
    if (!self.edtJobId.hasText) {
        ShowOkAlertWithTitle(@"Enter Job ID", self);
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof (self) weakSelf = self;
        [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                               onSuccess:^(NSString *successMessage) {
                                                                   [weakSelf checkJobStatus];
                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                               } onError:^(NSError *error) {
                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                               }];
    }
}

-(void)checkJobStatus {
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] != jstNeedDebrief) {
        self.vwDebrief.hidden = YES;
        if ([[[DataLoader sharedInstance] currentUser] activeJob]) {
            self.edtJobId.text =[[[DataLoader sharedInstance] currentUser] activeJob].jobID;
        }
    }else
    {
      self.vwDebrief.hidden = NO;
    }
    
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCutomerlookupTouch:(id)sender
{
   
    if (!self.edtJobId.hasText) {
        ShowOkAlertWithTitle(@"Enter Job ID", self);
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof (self) weakSelf = self;
        [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                               onSuccess:^(NSString *successMessage) {
                                                                   [weakSelf checkJobStatus];
                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                                   [weakSelf custumerlookup];
                                                               } onError:^(NSError *error) {
                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                               }];

    
  }
}

-(void)custumerlookup{
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] == jstNeedDebrief)
    {
        [self performSegueWithIdentifier:@"debriefRminderSegue" sender:self];
    }
    else if ([[[DataLoader sharedInstance] currentUser] activeJob])
    {
        [self performSegueWithIdentifier:@"dispatchSegue" sender:self];
    }
    else {
        ShowOkAlertWithTitle(@"There is no job assigned for you.", self);
    }
}
@end
