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

@interface TechnicianHomeVC ()
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

@end

@implementation TechnicianHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.homeController = self;
    
    self.numberOfHuds = 0;
   /// [self performSegueWithIdentifier:@"showWorkVC" sender:self];
    [self configureColorScheme];
    [self loadAdditionalInfo];
    [self checkSyncStatus];
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



#pragma mark - Load Aditional Info
- (void)loadAdditionalInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.numberOfHuds++;
    [[DataLoader sharedInstance] getAdditionalInfoOnSuccess:^(NSDictionary *infoDict) {
        if (infoDict.count)
            [DataLoader sharedInstance].companyAdditionalInfo = [self saveAdditionalInfoFromDict:infoDict];
        [self checkNumberOfHuds:--self.numberOfHuds];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    self.lastSyncLabel.text = @"Last Sync Date: Now";
    [self checkForDownloading];
}



#pragma mark - Downloading
- (void)checkForDownloading {
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        if (companyObject.isVideo) {
            if (![[TWRDownloadManager sharedManager] fileExistsForUrl:companyObject.info_url]) {
                [self startDownloadingVideo:companyObject];
            }else{
                if ([companyObject isEqual:[[DataLoader sharedInstance] companyAdditionalInfo].lastObject]) {
                    [self setDefaultSyncButton];
                    [self modifySyncStatus];
                }
            }
        }
    }
}



-(void)startDownloadingVideo:(CompanyAditionalInfo *)object {
    [[TWRDownloadManager sharedManager] downloadFileForURL:object.info_url progressBlock:^(CGFloat progress) {
       // NSLog(@"progress %f video file:%@",progress, object.info_url);
    } completionBlock:^(BOOL completed) {
        if ([object isEqual:[[DataLoader sharedInstance] companyAdditionalInfo].lastObject]) {
            [self modifySyncStatus];
            [self setDefaultSyncButton];
        }
    } enableBackgroundMode:YES];
}


- (void)setDefaultSyncButton {
    [self.syncButton setTitle:@"Sync" forState:UIControlStateNormal];
    [self.syncButton setEnabled:YES];
}


- (void)modifySyncStatus {
    [[DataLoader sharedInstance] updateStatusForAdditionalInfoOnSuccess:^(NSString *message) {
        //
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
                                                                   [weakSelf checkJobStatus];
                                                                   //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   [self checkNumberOfHuds:--self.numberOfHuds];
                                                               } onError:^(NSError *error) {
                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                                   ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                               }];
    }
}


-(void)checkJobStatus {
    [[[DataLoader sharedInstance] selectedRepairTemporarOptions] removeAllObjects];
    
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] != jstNeedDebrief) {
        self.vwDebrief.hidden = YES;
        if ([[[DataLoader sharedInstance] currentUser] activeJob]) {
            self.edtJobId.text =[[[DataLoader sharedInstance] currentUser] activeJob].jobID;
            [[[DataLoader sharedInstance] currentUser] deleteActiveJob];
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] == jstNeedDebrief) {
        [self custumerlookup];
    }else{
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
                                                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                                                       ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                                   }];
        }
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
