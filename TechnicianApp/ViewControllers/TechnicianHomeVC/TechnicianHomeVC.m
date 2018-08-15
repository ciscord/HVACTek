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

@property (nonatomic, strong) Job                                 *jobToDebrief;
@property (nonatomic, strong) NSArray                             *whoList;
@property (nonatomic, strong) NSArray                             *whoListCodes;
@property (nonatomic, strong) NSString                            *whoCurrent;

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

- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = TechnicianHome;
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

- (void)debriefCurrentJob {
    
    self.jobToDebrief.jobStatus = @(jstDone);
    [self.jobToDebrief.managedObjectContext save];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.numberOfHuds++;
    __weak typeof (self) weakSelf = self;
    [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                           onSuccess:^(NSString *successMessage) {
                                                               [self checkNumberOfHuds:--self.numberOfHuds];
                                                               [weakSelf custumerlookup];
                                                               
                                                           } onError:^(NSError *error) {
                                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                               ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                                           }];
    
    
}
- (NSDictionary *)dictionaryWithvaluesForAPI {
    
    NSMutableDictionary *result = @{}.mutableCopy;
    
    self.jobToDebrief = [[[DataLoader sharedInstance] currentUser] activeJob];
    /////

    NSArray* defaultArray = [self defaultCellsArray];

    for (NSInteger i = 0; i < defaultArray.count; i++) {
        
        [result addEntriesFromDictionary:[self valueForApi:[defaultArray objectAtIndex:i]]];
        
    }
    
    [result addEntriesFromDictionary:@{@"user_id" : [[[DataLoader sharedInstance] currentUser] userID]}];
    [result addEntriesFromDictionary:@{@"status" : @(0)}];
    
    NSTimeInterval distanceBetweenQuestions = [self.jobToDebrief.startTimeQuestions timeIntervalSinceDate:self.jobToDebrief.endTimeQuestions];
    double         secondsInAnHour          = 60;
    double         totalMinutes             = ABS(distanceBetweenQuestions / secondsInAnHour);
    
    [result addEntriesFromDictionary:@{@"time_of_questions" : [NSString stringWithFormat:@"%.2f", totalMinutes]}];
    
    return result;
}

- (NSDictionary *)valueForApi:(NSDictionary*) _cellData {
    
    NSArray  *possValsTemp = _cellData[@"possVals"];
    NSArray  *apiValsTemp  = _cellData[@"APIValues"];
    NSString *value        = _cellData[@"accVal"];
    
    TDCellAccType _cellType = [_cellData[@"accType"] integerValue];
    
    switch (_cellType) {
        case lblCellAcc:
        {
            value = apiValsTemp.firstObject;
            break;
        }
        case drpDownCellAcc:
        {
            value = @"0";
            if (possValsTemp.count > 0 && possValsTemp.count == apiValsTemp.count) {
                
                NSInteger index = [possValsTemp indexOfObject:value];
                if (index != NSNotFound && index < apiValsTemp.count) {
                    value = apiValsTemp[index];
                }
            }
            break;
        }
        case txtViewCellAcc:
        {
            value = @"";
            break;
        }
        case txtFieldCellAcc:
        case txtFieldNumericCellAcc:
        {
            value = @"";
            break;
        }
        case chkBoxCellAcc:
        {
            value = apiValsTemp[0];
            break;
        }
            
        default:
            break;
    }
    
    return @{_cellData[@"APIField"] : value};
}

-(void)checkJobStatus {
    
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] jobStatus] integerValue] != jstNeedDebrief) {
        self.vwDebrief.hidden = YES;
        if ([[[DataLoader sharedInstance] currentUser] activeJob]) {
            self.edtJobId.text =[[[DataLoader sharedInstance] currentUser] activeJob].jobID;
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

- (IBAction)btnCutomerlookupTouch:(id)sender
{
    
    if (!self.edtJobId.hasText) {
        ShowOkAlertWithTitle(@"Enter Job ID", self);
        return;
        
    }
    
    if (![[[[DataLoader sharedInstance] currentUser] activeJob].jobID isEqualToString:self.edtJobId.text] && [[[[DataLoader sharedInstance] currentUser] activeJob].jobStatus integerValue]== jstNeedDebrief) {
        __weak typeof (self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *params = [self dictionaryWithvaluesForAPI];
        
        [[DataLoader sharedInstance] debriefJobWithInfo:params
                                              onSuccess:^(NSString *message) {
                                                  
                                                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                  [weakSelf debriefCurrentJob];
                                                  
                                              } onError:^(NSError *error) {
                                                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                  ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
                                              }];
        
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.numberOfHuds++;
        __weak typeof (self) weakSelf = self;
        [[DataLoader sharedInstance] getAssignmentListFromSWAPIWithJobID:self.edtJobId.text
                                                               onSuccess:^(NSString *successMessage) {
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



- (NSArray *)defaultCellsArray {
    
    
    NSDictionary *customerInfo = self.jobToDebrief.swapiCustomerInfo;
    NSDictionary *jobInfo      = self.jobToDebrief.swapiJobInfo;
    
    NSDateFormatter *dateTimeFormatterToDisplay = [[NSDateFormatter alloc] init];
    [dateTimeFormatterToDisplay setDateFormat:@"HH:mm a"];
    
    NSDateFormatter *dateTimeFormatterToAPI = [[NSDateFormatter alloc] init];
    [dateTimeFormatterToAPI setDateFormat:@"HH:mm:ss"];
    
    NSTimeInterval distanceBetweenDates = [self.jobToDebrief.startTime timeIntervalSinceDate:self.jobToDebrief.completionTime];
    double         secondsInAnHour      = 3600;
    double         totalHoursValue      = ABS(distanceBetweenDates / secondsInAnHour);
    
    NSString *jobNameValue = [NSString stringWithFormat:@"%@ %@", customerInfo[@"FirstName"], customerInfo[@"LastName"]];
    
    
    NSArray        *list            = [self.jobToDebrief.swapiJobInfo objectForKey:@"whoList"];//[[[DataLoader sharedInstance] SWAPIManager] whoList];
    NSMutableArray *resultList      = @[].mutableCopy;
    NSMutableArray *resultListCodes = @[].mutableCopy;
    for (NSDictionary *employee in list) {
        
        [resultList addObject:[NSString stringWithFormat:@"%@ %@", employee[@"FirstName"], employee[@"LastName"]]];
        [resultListCodes addObject:employee[@"EmployeeCode"]];
        if ([employee[@"EmployeeCode"] isEqualToString:[[[DataLoader sharedInstance] currentUser] userCode]]) {
            self.whoCurrent = resultList.lastObject;
        }
    }
    
    self.whoList      = resultList;
    self.whoListCodes = resultListCodes;
    
    //// section 0 = 13
    
    
    NSMutableDictionary *jobName                 = [self itemDicWith:@"Job Name" accType:lblCellAcc accVal:jobNameValue possVals:@[] align:cCenter APIField:@"job_name" APIValues:@[jobNameValue]];
    NSMutableDictionary *jobNumber               = [self itemDicWith:@"Job Number" accType:lblCellAcc accVal:self.jobToDebrief.swapiJobInfo[@"JobNo"] possVals:@[] align:cCenter APIField:@"job_number" APIValues:@[self.jobToDebrief.swapiJobInfo[@"JobNo"]]];
    NSMutableDictionary *dispathTime             = [self itemDicWith:@"Dispath Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.dispatchTime] possVals:@[] align:cCenter APIField:@"dispatch_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.dispatchTime]]];
    
    NSMutableDictionary *startTime               = [self itemDicWith:@"Start Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.startTime] possVals:@[] align:cCenter APIField:@"start_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.startTime]]];
    NSMutableDictionary *completionTime          = [self itemDicWith:@"Completion Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.completionTime] possVals:@[] align:cCenter APIField:@"completion_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.completionTime]]];
    NSMutableDictionary *totalHours              = [self itemDicWith:@"Total Hours" accType:lblCellAcc accVal:[NSString stringWithFormat:@"%.2f", totalHoursValue] possVals:@[] align:cCenter APIField:@"total_hours" APIValues:@[[NSString stringWithFormat:@"%.2f", totalHoursValue]]];
    NSMutableDictionary *ageOfSystem             = [self itemDicWith:@"Age Of System" accType:txtFieldNumericCellAcc accVal:jobInfo[@"UnitAge"] possVals:@[] align:cCenter APIField:@"age_of_system" APIValues:@[]];
    NSMutableDictionary *replacementLeadSheduled = [self itemDicWith:@"Replacement Lead Sheduled" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"replacement_lead_scheduled" APIValues:@[@1, @0]];
    NSMutableDictionary *agreementOpportunity = [self itemDicWith:@"Agreement Opportunity" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"agreement_opportunity" APIValues:@[@1, @0]];
    NSMutableDictionary *agreementSold = [self itemDicWith:@"Agreement Sold" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"agreement_sold" APIValues:@[@1, @0]];
    NSMutableDictionary *totalRevenue            = [self itemDicWith:@"Total Revenue On This Ticket" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"total_revenue" APIValues:@[] cellValueType:ctCellTotalRevenue];
    
    NSMutableDictionary *paymentCollected                   = [self itemDicWith:@"Payment Collected" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"payment_collected" APIValues:@[@1, @0]];
    NSMutableDictionary *paymentMethod                      = [self itemDicWith:@"Payment Method" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"payment_method" APIValues:@[]];
    
    //// section 1 = 1/2
    
    NSMutableDictionary *callBack                           = [self itemDicWith:@"Call Back" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"callback" APIValues:@[@1, @0]];
    NSMutableDictionary *who                                = [self itemDicWith:@"Who" accType:drpDownCellAcc accVal:self.whoCurrent possVals:self.whoList align:cRight APIField:@"who" APIValues:self.whoListCodes];
    
    //// section 2 = 1/12
    
    NSMutableDictionary *repairScheduled                    = [self itemDicWith:@"Repair Scheduled" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"repair_scheduled" APIValues:@[@1, @0]];
    NSMutableDictionary *priceQuoted                        = [self itemDicWith:@"Price Quoted" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"price_quoted" APIValues:@[]];
    NSMutableDictionary *priceApproved                      = [self itemDicWith:@"Price Approved" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cRight APIField:@"price_approved" APIValues:@[@1, @0]];
    NSMutableDictionary *ammountof50PercentDepositCollected = [self itemDicWith:@"Amount Of 50% Deposit Collected" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"deposit_collected" APIValues:@[]];
    NSMutableDictionary *partsOrderedBy                     = [self itemDicWith:@"Parts Ordered By" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"parts_ordered_by" APIValues:@[]];
    NSMutableDictionary *supplerPartsOrderedFrom            = [self itemDicWith:@"Supplier Parts Ordered From" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"supplier_parts_ordered_form" APIValues:@[]];
    NSMutableDictionary *timeNeededForRepair                = [self itemDicWith:@"Time Needed For Repair" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"time_needed_for_repair" APIValues:@[]];
    NSMutableDictionary *whenIsTheRepairScheduled           = [self itemDicWith:@"When Is The Repair Scheduled" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"when_repair_scheduled" APIValues:@[]];
    NSMutableDictionary *modelOfSystemNeedingRepair         = [self itemDicWith:@"Model Of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"model_system_needing_required" APIValues:@[]];
    NSMutableDictionary *serialNumberOfSystemNeedingRepair  = [self itemDicWith:@"Serial Number Of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"serial_number_system_needing_repair" APIValues:@[]];
    NSMutableDictionary *locationOfSystemNeedingRepair      = [self itemDicWith:@"Location of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"location_system_needing_repair" APIValues:@[]];
    NSMutableDictionary *specialInstructionsOrToolsRequired = [self itemDicWith:@"Special Instructions Or Tools Required" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"special_instructions_or_tools_required" APIValues:@[]];
    
    
    
    //// section 3 = 7
    
    
    NSMutableDictionary *installAndSignAllStickers          = [self itemDicWith:@"Install & Sign All Stickers" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"sign_all_stickers" APIValues:@[@1, @0]];
    NSMutableDictionary *equipmentSwRemote          = [self itemDicWith:@"Equipment Entered In SW Remote" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"equipment_sw_remote" APIValues:@[@1, @0]];
    NSMutableDictionary *verifiedEmail          = [self itemDicWith:@"Verified Email Address" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"verified_email" APIValues:@[@1, @0]];
    NSMutableDictionary *sentAnglesListReviewLink           = [self itemDicWith:@"Sent Angie's List Review Link" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"list_review_link" APIValues:@[@1, @0]];
    
    NSMutableDictionary *sentReviewBuzzLink                 = [self itemDicWith:@"Sent Review Buzz Link" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"buzz_link" APIValues:@[@1, @0]];
    NSMutableDictionary *attachAllPartsUsedToTicked         = [self itemDicWith:@"Johnstone App Parts Ordered" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"attach_all_parts_used_to_tiket" APIValues:@[@1, @0]];
    NSMutableDictionary *thermostatSetAndSystemRunning      = [self itemDicWith:@"Thermostat Set & System Running" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"system_running" APIValues:@[@1, @0]];
    
    
    
    /////  section 4 = 1/2
    NSMutableDictionary *followUpRequired         = [self itemDicWith:@"Follow Up Required" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"follow_up_required" APIValues:@[@1, @0]];
    
    
    NSMutableDictionary *notesSwRemote        = [self itemDicWith:@"Work Performed Notes Entered in SWR" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"notes_entered_sw_remote5" APIValues:@[@1, @0]];
    NSMutableDictionary *suggestedNotesSwRemote        = [self itemDicWith:@"Work Suggested Notes Entered In SWR" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"notes_suggested_sw_remote" APIValues:@[@1, @0]];
    
    return @[jobName,
             jobNumber,
             dispathTime,
             startTime,
             completionTime,
             totalHours,
             ageOfSystem,
             replacementLeadSheduled,
             agreementOpportunity,
             agreementSold,
             totalRevenue,
             paymentCollected,
             paymentMethod,
             callBack,
             who,
             repairScheduled,
             priceQuoted,
             priceApproved,
             ammountof50PercentDepositCollected,
             partsOrderedBy,
             supplerPartsOrderedFrom,
             timeNeededForRepair,
             whenIsTheRepairScheduled,
             modelOfSystemNeedingRepair,
             serialNumberOfSystemNeedingRepair,
             locationOfSystemNeedingRepair,
             specialInstructionsOrToolsRequired,
             installAndSignAllStickers,
             equipmentSwRemote,
             verifiedEmail,
             sentAnglesListReviewLink,
             sentReviewBuzzLink,
             attachAllPartsUsedToTicked,
             thermostatSetAndSystemRunning,
             followUpRequired,
             notesSwRemote,
             suggestedNotesSwRemote];
}

- (NSMutableDictionary *)itemDicWith:(NSString *)title
                             accType:(TDCellAccType)accessoryType
                              accVal:(id)accVal
                            possVals:(NSArray *)possVals
                               align:(TDCellAlign)align
                            APIField:(NSString *)APIField
                           APIValues:(NSArray *)APIValues
                       cellValueType:(CellType)cellType {
    
    NSString *accValTemp   = accVal ? accVal : @"";
    NSArray  *possValsTemp = possVals ? possVals : @[];
    
    NSString *apiFieldTemp = APIField ? APIField : @"APIField";
    NSArray  *apiValsTemp  = APIValues ? APIValues : @[];
    
    NSMutableDictionary *aDic = @{@"title":title, @"accType":@(accessoryType), @"accVal":accValTemp, @"possVals":possValsTemp, @"align":@(align),
                                  @"APIField" : apiFieldTemp, @"APIValues" : apiValsTemp, @"cellType" : @(cellType)}.mutableCopy;
    
    return aDic;
}

- (NSMutableDictionary *)itemDicWith:(NSString *)title
                             accType:(TDCellAccType)accessoryType
                              accVal:(id)accVal
                            possVals:(NSArray *)possVals
                               align:(TDCellAlign)align
                            APIField:(NSString *)APIField
                           APIValues:(NSArray *)APIValues {
    
    NSMutableDictionary *aDic = [self itemDicWith:title accType:accessoryType accVal:accVal possVals:possVals align:align APIField:APIField APIValues:APIValues cellValueType:ctCellDefault];
    
    return aDic;
}

@end
