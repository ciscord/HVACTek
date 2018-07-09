//
//  TechnicianHomeVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "TechnicianHomeVC.h"
#import "AppDelegate.h"
#import "CompanyAditionalInfo.h"
#import <MBProgressHUD.h>
#import <TWRDownloadManager/TWRDownloadManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DispatchVC.h"
#import "TechnicianDebriefVC.h"
#import "THProgressView.h"

static const CGSize progressViewSize = { 300.0f, 20.0f };

@interface TechnicianHomeVC ()
{
    int downloadedCount;
}
@property (weak, nonatomic) IBOutlet UIView *vwDebrief;
@property (strong, nonatomic) IBOutlet UITextField *edtJobId;
@property (weak, nonatomic) IBOutlet UILabel *selectTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishJobLabel;
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *debriefButton;
@property (weak, nonatomic) IBOutlet UIView *separator1View;
@property (weak, nonatomic) IBOutlet UIView *separator2View;
@property (weak, nonatomic) IBOutlet UIView *separator3View;

@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UILabel *lastSyncLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncProgressLabel;
@property (nonatomic) int numberOfHuds;

@property (nonatomic, strong) THProgressView *progressBar;
@end

@implementation TechnicianHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.homeController = self;
    [self initializeProgressBar];
    
    self.numberOfHuds = 0;
   /// [self performSegueWithIdentifier:@"showWorkVC" sender:self];
    [self configureColorScheme];
    [self checkSyncStatus];
    [self checkForLogs];

    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep >= TechnicianDebrief) {
        TechnicianDebriefVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TechnicianDebriefVC"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > TechnicianHome) {
        [DataLoader loadOptions];
        DispatchVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DispatchVC"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:TechnicianHome];
    }
    
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.layer1View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    self.separator1View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separator2View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separator3View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.goButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.debriefButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.selectTaskLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.jobIdLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.finishJobLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.edtJobId.layer.borderWidth = 1.0;
    self.edtJobId.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.edtJobId.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    
    self.syncButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.syncButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateNormal];
    self.syncProgressLabel.textColor = [UIColor blackColor];
    self.syncStatusLabel.textColor = [UIColor blackColor];
    self.lastSyncLabel.textColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveJobIDFromSWR:) name:@"NotifReciveJobIDFromSWR" object:nil];
}


#pragma mark - Check For Logs
- (void)checkForLogs {
    NSArray *allLogs = [Logs findAll];
    if (allLogs.count > 0) {
        NSMutableArray *logsArray = [[NSMutableArray alloc] init];
        for (Logs*log in allLogs) {
            NSDictionary * dict = @{@"user_id" : log.userID,
                                    @"date" : log.date.stringFromDate,
                                    @"module" : log.module,
                                    @"message" : log.message,
                                    @"request" : log.request,
                                    @"response" : log.response};
            [logsArray addObject:dict];
        }
        
        [[DataLoader sharedInstance] sendLogs:logsArray onSuccess:^(NSString *message) {
            for (Logs*log in allLogs) {
                [log.managedObjectContext deleteObject:log];
                [[log managedObjectContext] save];
            }
        } onError:^(NSError *error) {
            //
        }];
    }
}


#pragma mark - Check For Sync
- (void)checkSyncStatus {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.numberOfHuds++;
    [[DataLoader sharedInstance] checkSyncStatusForAdd2Cart:NO onSuccess:^(NSDictionary *infoDict) {
        BOOL syncStatus = [[infoDict objectForKey:@"sync"] boolValue];
        [self syncLabelStatus:syncStatus];
        [self syncDateLabel:[infoDict objectForKey:@"sync_date"]];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self checkNumberOfHuds:--self.numberOfHuds];
    }onError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowOkAlertWithTitle(error.localizedDescription, self);
    }];
}


#pragma mark -
-(void)syncLabelStatus:(BOOL)status {
    self.syncStatusLabel.hidden = !status;
}


-(void)syncDateLabel:(NSString *)sync_date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *syncDate = [dateFormatter dateFromString:sync_date];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *syncString = [dateFormatter stringFromDate:syncDate];
    
    NSString *lastSync = [NSString stringWithFormat:@"Last Sync Date: %@", syncString];
    self.lastSyncLabel.text = lastSync;
}


#pragma mark - Sync Action
- (IBAction)syncClicked:(id)sender {
    [self.syncButton setEnabled:NO];
    [self.syncButton setTitle:@"Sync Started" forState:UIControlStateNormal];
    [self syncLabelStatus:NO];
    self.progressBar.hidden = NO;
    self.syncProgressLabel.hidden = false;
    [self checkForDownloading];
}



#pragma mark - Downloading
- (void)checkForDownloading {
    
    downloadedCount = 0;
    [[TWRDownloadManager sharedManager] cancelAllDownloads];
    
    if ([[DataLoader sharedInstance] companyAdditionalInfo].count > 0) {
        [self downloadOnebyOne];
    }
    
    
}
- (void) downloadOnebyOne {
    
    NSUInteger totalCount = [[DataLoader sharedInstance] companyAdditionalInfo].count;
    
    if (downloadedCount < totalCount) {
        CompanyAditionalInfo *companyObject = [[[DataLoader sharedInstance] companyAdditionalInfo] objectAtIndex:downloadedCount];
        
        if (companyObject.isVideo) {
            if (![[TWRDownloadManager sharedManager] fileExistsForUrl:companyObject.info_url]) {
                [self startDownloadingVideo:companyObject];
            }else {
                downloadedCount++;
                
                [self downloadOnebyOne];
                return;
            }
        }else if (companyObject.isPicture) {
            [self downloadImageFromURL:companyObject.info_url];
        }else {
            downloadedCount++;
            [self downloadOnebyOne];
            return;
        }
    }
    
    [self updateProgress];
    if (totalCount == downloadedCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBar.hidden = true;
            self.syncProgressLabel.hidden = true;
            [self.progressBar setProgress:0];
            [self setDefaultSyncButton];
            [self modifySyncStatus];
        });
        
    }
    
}
- (void) updateProgress {
    
    float value = (float)downloadedCount / (float)[[DataLoader sharedInstance] companyAdditionalInfo].count;
    int percent = value * 100;
    NSString *str = [NSString stringWithFormat:@"Sync In Progress - %d%%", percent];
    
    [self.syncProgressLabel performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(updateProgressForValue:) withObject:[NSNumber numberWithFloat:value] waitUntilDone:YES];
    
}
-(int)numberOfVideoObjects {
    int x = 0;
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        if (companyObject.isVideo)
            x++;
    }
    return x;
}
 


-(void)downloadImageFromURL:(NSString *)imageURL {
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString: imageURL]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL];
                                   
                               }
                               downloadedCount++;
                               [self downloadOnebyOne];
                           }];
}



-(void)startDownloadingVideo:(CompanyAditionalInfo *)object {
    
    [[TWRDownloadManager sharedManager] downloadFileForURL:object.info_url progressBlock:^(CGFloat progress) {
        NSLog(@"progress %f video file:%@",progress, object.info_url);
        
    } completionBlock:^(BOOL completed) {
        NSLog(@"~~~completed downloading~~~");
        downloadedCount++;
        [self downloadOnebyOne];
    } enableBackgroundMode:YES];
}


- (void)setDefaultSyncButton {
    [self.syncButton setTitle:@"Sync Completed" forState:UIControlStateNormal];
    [self.syncButton setEnabled:YES];
    
}


- (void)modifySyncStatus {
    [[DataLoader sharedInstance] updateStatusForAdditionalInfoOnSuccess:^(NSString *message) {
        [self checkSyncStatus];
    } onError:^(NSError *error) {
        ShowOkAlertWithTitle(error.localizedDescription, self);
    }];
}


#pragma mark -
- (void)didReciveJobIDFromSWR:(NSNotification *)info {
    [self checkJobStatus];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self checkJobStatus];
}


- (void)getNextJob {
    
    if (!self.edtJobId.hasText) {
        ShowOkAlertWithTitle(@"Enter Job ID", self);
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.numberOfHuds++;
        __weak typeof (self) weakSelf = self;
        [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                               onSuccess:^(NSString *successMessage) {
                                                                   [DataLoader clearAllLocalData];
                                                                   [weakSelf checkJobStatus];
                                                                   [[TechDataModel sharedTechDataModel] saveEditJobID:self.edtJobId.text];
                                                                   //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   [self checkNumberOfHuds:--self.numberOfHuds];
                                                               } onError:^(NSError *error) {
                                                                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                               }];
    }
}


-(void)checkJobStatus {
    
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] != jstNeedDebrief) {
        self.vwDebrief.hidden = YES;
        if ([[[DataLoader sharedInstance] currentUser] activeJob]) {
            self.edtJobId.text =[[[DataLoader sharedInstance] currentUser] activeJob].jobID;
//            [[[DataLoader sharedInstance] currentUser] deleteActiveJob];
        }
        else
        {
            self.edtJobId.text = @"";
        }
    }else
    {
      self.vwDebrief.hidden = NO;
    }
    
    if ([[DataLoader sharedInstance] recivedSWRJobID].length > 0) {
        self.edtJobId.text = [[DataLoader sharedInstance] recivedSWRJobID];
        [DataLoader sharedInstance].recivedSWRJobID = @"";
        [self btnCutomerlookupTouch:self];
    }
}


#pragma mark - Number of HUDs
-(void)checkNumberOfHuds:(int)number {
    if (number == 0)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        self.numberOfHuds++;
        __weak typeof (self) weakSelf = self;
        [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                               onSuccess:^(NSString *successMessage) {
                                                                   //[weakSelf checkJobStatus];
                                                                   //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   [self checkNumberOfHuds:--self.numberOfHuds];
                                                                   [weakSelf custumerlookup];
                                                                   
                                                               } onError:^(NSError *error) {
                                                                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                               }];
    }
    
}


-(void)custumerlookup{
    if ([[[DataLoader sharedInstance] currentUser] activeJob])
    {
        [self performSegueWithIdentifier:@"dispatchSegue" sender:self];
    }
    else {
        ShowOkAlertWithTitle(@"There is no job assigned for you.", self);
    }
}


#pragma mark - ProgressBar
- (void)initializeProgressBar {
    self.progressBar = [[THProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - progressViewSize.width / 2.0f,
                                                                        CGRectGetMidY(self.view.frame) - progressViewSize.height / 2.0f + 184,
                                                                        progressViewSize.width,
                                                                        progressViewSize.height)];
    self.progressBar.borderTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.progressBar.progressTintColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.progressBar.progressBackgroundColor = [UIColor whiteColor];
    self.progressBar.hidden = YES;
    [self.view addSubview:self.progressBar];
}

- (void)updateProgressForValue:(NSNumber *)newValue
{
    [self.progressBar setProgress:[newValue floatValue] animated:YES];
}

@end
