//
//  PDFViewController.m
//  HvacTek
//
//  Created by Max on 11/23/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "PDFViewController1VC.h"
#import <WebKit/WebKit.h>
#import "BaseVC.h"
#import <TWRDownloadManager.h>
@interface PDFViewController1VC ()
@property (strong, nonatomic) WKWebView *wkwebview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation PDFViewController1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneButton.tintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    CGRect frame = self.view.frame;
    frame.origin.y = self.navBar.frame.size.height+20;
    frame.size.height -= frame.origin.y;
    self.wkwebview = [[WKWebView alloc] initWithFrame:frame];
    [self.view addSubview:self.wkwebview];
    NSURL* pdfUrl;
    if ([[TWRDownloadManager sharedManager] fileExistsForUrl:self.pdfUrl]) {//open pdf from local
        pdfUrl =  [NSURL fileURLWithPath:[[TWRDownloadManager sharedManager] localPathForFile:self.pdfUrl]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:pdfUrl];
        
        [self.wkwebview loadRequest:request];

    }else {
        if ([[[DataLoader sharedInstance] reachabilityManager] isReachable]) {//open pdf from url
            pdfUrl = [NSURL URLWithString:self.pdfUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:pdfUrl];
            
            [self.wkwebview loadRequest:request];
            
            //download pdf file
            [[TWRDownloadManager sharedManager] downloadFileForURL:self.pdfUrl progressBlock:^(CGFloat progress) {
                NSLog(@"progress %f pdf file:%@",progress, self.pdfUrl);
            } completionBlock:^(BOOL completed) {
                NSLog(@"~~~completed downloading~~~");
                
            } enableBackgroundMode:YES];
            
        }else{
            UIAlertController *alert= [UIAlertController alertControllerWithTitle: @"Oops! Something went wrong."
                                                                          message: @"PDF wasn't downloaded to the app and there isn't internet connection available right now."
                                                                   preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                       }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"is Not Reachable");
        }
    }
}
- (IBAction)doneClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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

@end
