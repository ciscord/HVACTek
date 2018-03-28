//
//  InvoicePreviewVC.m
//  HvacTek
//
//  Created by Dorin on 5/18/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "InvoicePreviewVC.h"

@interface InvoicePreviewVC ()

@property (weak, nonatomic) IBOutlet UIWebView *invoiceWebView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation InvoicePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureColorScheme];
    [self.invoiceWebView loadHTMLString:self.previewHtmlString baseURL:nil];
    
    [[TechDataModel sharedTechDataModel] saveCurrentStep:InvoicePreview];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.cancelButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.sendButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

#pragma mark - Button Actions
- (IBAction)sendClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    job.jobStatus = @(jstNeedDebrief);
    [job.managedObjectContext save];
    
    [[DataLoader sharedInstance] postInvoice:self.invoiceDictionary requestingPreview:0 onSuccess:^(NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self trySendingLogWithMessage:@"Success" andResponse:message.description];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.homeController) {
            [self.navigationController popToViewController:appDelegate.homeController animated:YES];
        }else {
            UIViewController* homeViewController = [self.navigationController.viewControllers objectAtIndex:1];
            [self.navigationController popToViewController:homeViewController animated:true];
        }
        
        
    } onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self trySendingLogWithMessage:@"Error" andResponse:error.localizedDescription];
    }];
}


-(void)trySendingLogWithMessage:(NSString *)message andResponse:(NSString *)response {
    NSDate *date = [NSDate new];
    NSString *userID = [[[[DataLoader sharedInstance] currentUser] userID] stringValue];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.invoiceDictionary options:0 error:&err];
    NSString * requestString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    
    NSDictionary * dict = @{@"user_id" : userID,
                            @"date" : date.stringFromDate,
                            @"module" : @"Invoice",
                            @"message" : message,
                            @"request" : requestString,
                            @"response" : response};
    
    NSArray *logArray = [[NSArray alloc] initWithObjects:dict, nil];
    
    [[DataLoader sharedInstance] sendLogs:logArray onSuccess:^(NSString *message) {
        NSLog(@"success log");
    } onError:^(NSError *error) {
        Logs *log = [Logs initLogWithUserID:userID
                                       date:date
                                    message:message
                                     module:@"Invoice"
                                    request:requestString
                                andResponse:response];
        [log.managedObjectContext save];
    }];
}


- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        NSURL *url = request.URL;
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        return NO;
    }
    
    return YES;
}


#pragma mark -
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

@end
