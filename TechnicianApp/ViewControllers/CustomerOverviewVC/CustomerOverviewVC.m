//
//  CustomerOverviewVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "CustomerOverviewVC.h"
#import "SystemInfoHeaderView.h"
//#import "QuestionsVC.h"
#import "ServiceHistoryTableViewCell.h"
#import "SServiceHistory.h"
#import "SettingAgendaVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#pragma mark - DataStructure

@interface SCustomerInfo : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *value;

@end

@implementation SCustomerInfo

@end


#pragma mark -

@interface SSystemInfo : NSObject

@property (nonatomic, strong) SystemInfoHeaderView *headerView;
@property (nonatomic) BOOL                         visible;
@property (nonatomic, strong) NSMutableArray       *properties;

@end

@implementation SSystemInfo

- (id)init {
    self = [super init];
    if (self) {
        self.properties = [NSMutableArray new];
    }
    return self;
}

@end

#pragma mark - CustomerInfoTableViewCell

@interface CustomerInfoTableViewCell : UITableViewCell

@end

@implementation CustomerInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {

        if (!s_CalibriLight13) {
            s_CalibriLight13 = [UIFont fontWithName:@"Calibri-Light" size:13];
        }

        if (!s_Calibri14) {
            s_Calibri14 = [UIFont fontWithName:@"Calibri" size:14];
        }

        self.textLabel.font      = s_CalibriLight13;
        self.textLabel.textColor = [UIColor blackColor];

        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.font          = s_Calibri14;
        self.detailTextLabel.textColor     = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.textLabel setFrame:CGRectMake(self.textLabel.frame.origin.x+5,
                                        self.textLabel.frame.origin.y,
                                        self.textLabel.frame.size.width,
                                        self.textLabel.frame.size.height)];
    [self.detailTextLabel sizeToFit];

    CGFloat detailWidth = self.detailTextLabel.frame.size.width;
    CGFloat maxWidth    = self.contentView.frame.size.width - self.textLabel.frame.origin.x + self.textLabel.frame.size.width-10;
    if (detailWidth > maxWidth) {
        detailWidth = maxWidth;
    }
    [self.detailTextLabel setFrame:CGRectMake(self.contentView.frame.size.width - detailWidth-10,
                                              self.detailTextLabel.frame.origin.y,
                                              detailWidth,
                                              self.detailTextLabel.frame.size.height)];
}

@end

#pragma mark - SystemInfoTableViewCell

@interface SystemInfoTableViewCell : UITableViewCell

@end

@implementation SystemInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!s_CalibriLight14) {
            s_CalibriLight14 = [UIFont fontWithName:@"Calibri-Light" size:14];
        }

        self.textLabel.font      = s_CalibriLight14;
        self.textLabel.textColor = [UIColor blackColor];

        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.font          = self.textLabel.font;
        self.detailTextLabel.textColor     = self.textLabel.textColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.x           = 22;
    self.detailTextLabel.right = self.width - 20;
}

@end


#pragma mark - CustomerOverviewVC

@interface CustomerOverviewVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnHeatingCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCoolingCall;

@property (weak, nonatomic) IBOutlet UIView      *vContainer;
@property (weak, nonatomic) IBOutlet UILabel     *lbCustomerInfoTitle;
@property (weak, nonatomic) IBOutlet UITableView *tvCustomerInfo;
@property (weak, nonatomic) IBOutlet UILabel     *lbServiceHistoryInfoTitle;
@property (weak, nonatomic) IBOutlet UITableView *tvServiceHistory;
@property (weak, nonatomic) IBOutlet UILabel     *lbSystemInfoTitle;
@property (weak, nonatomic) IBOutlet UITableView *tvSystemInfo;

@property (nonatomic, assign) QuestionType selectedType;

@property (nonatomic, strong) NSMutableArray *customerInfoList;
@property (nonatomic, strong) NSMutableArray *serviceHistoryList;
@property (nonatomic, strong) NSMutableArray *systemInfoList;

@property (nonatomic, strong) NSArray *questions;

@end

@implementation CustomerOverviewVC

static NSString *kCustomerInfoCellIdentifier   = @"kCustomerInfoCellIdentifier";
static NSString *kSystemInfoCellIdentifier     = @"kSystemInfoCellIdentifier";
static NSString *kServiceHistoryCellIdentifier = @"ServiceHistoryTableViewCell";
static NSString *kSystemInfoHeaderView         = @"SystemInfoHeaderView";


- (void)viewDidLoad {
    [super viewDidLoad];

    self.lbCustomerInfoTitle.font       = [UIFont fontWithName:@"Calibri" size:16];
    self.lbServiceHistoryInfoTitle.font = self.lbCustomerInfoTitle.font;
    self.lbSystemInfoTitle.font         = self.lbCustomerInfoTitle.font;

    self.isTitleViewHidden            = YES;
    self.view.backgroundColor         = [UIColor colorWithRed:0.622 green:0.807 blue:0.404 alpha:1.000];
    self.vContainer.layer.borderColor = [[UIColor colorWithRed:0.379 green:0.694 blue:0.227 alpha:1.000] CGColor];
    [self.tvCustomerInfo registerClass:[CustomerInfoTableViewCell class] forCellReuseIdentifier:kCustomerInfoCellIdentifier];

    [self.tvSystemInfo registerNib:[UINib nibWithNibName:kSystemInfoHeaderView bundle:nil] forHeaderFooterViewReuseIdentifier:kSystemInfoHeaderView];
    [self.tvSystemInfo registerClass:[SystemInfoTableViewCell class] forCellReuseIdentifier:kSystemInfoCellIdentifier];

    [self.tvServiceHistory registerNib:[UINib nibWithNibName:kServiceHistoryCellIdentifier bundle:nil] forCellReuseIdentifier:kServiceHistoryCellIdentifier];

    self.selectedType = qtHeating;
    [self performSelector:@selector(configureData) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)configureData {
    self.customerInfoList   = [NSMutableArray array];
    self.serviceHistoryList = [NSMutableArray array];
    self.systemInfoList     = [NSMutableArray array];

    
    Job          *job          = [[[DataLoader sharedInstance] currentUser] activeJob];
    NSDictionary *customerInfo = [job.swapiCustomerInfo objectForKey:@"dsLocationList.dsLocation"];
    //@"dsLocationList.dsLocation"
    // NSDictionary *jobInfo = job.swapiJobInfo;

    id historyInfo = [job.swapiCustomerInfo valueForKeyPath:@"dsHistoryList.dsHistory"];
    if ([historyInfo isKindOfClass:[NSDictionary class]]) {
        historyInfo = @[historyInfo];
    }

    id equipmentList = [job.swapiCustomerInfo valueForKeyPath:@"dsEquipList.dsEquip"];
    if ([equipmentList isKindOfClass:[NSDictionary class]]) {
        equipmentList = @[equipmentList];
    }


    SCustomerInfo *info1 = [SCustomerInfo new];
    info1.label = @"First Name";
    info1.value = customerInfo[@"FirstName"];
    [self.customerInfoList addObject:info1];

    SCustomerInfo *info2 = [SCustomerInfo new];
    info2.label = @"Last Name";
    info2.value = customerInfo[@"LastName"];
    [self.customerInfoList addObject:info2];

    SCustomerInfo *info3 = [SCustomerInfo new];
    info3.label = @"Address";
    info3.value = customerInfo[@"Address1"];
    [self.customerInfoList addObject:info3];

    SCustomerInfo *info4 = [SCustomerInfo new];
    info4.label = @"City";
    info4.value = customerInfo[@"City"];
    [self.customerInfoList addObject:info4];

    SCustomerInfo *info5 = [SCustomerInfo new];
    info5.label = @"State";
    info5.value = customerInfo[@"State"];
    [self.customerInfoList addObject:info5];

    SCustomerInfo *info6 = [SCustomerInfo new];
    info6.label = @"Zip";
    info6.value = customerInfo[@"Zip"];
    [self.customerInfoList addObject:info6];

    SCustomerInfo *info7 = [SCustomerInfo new];
    info7.label = @"Phone 1";
    info7.value = customerInfo[@"Phone1"];
    [self.customerInfoList addObject:info7];

    SCustomerInfo *info8 = [SCustomerInfo new];
    info8.label = @"Phone 2";
    info8.value = customerInfo[@"Phone2"];;
    [self.customerInfoList addObject:info8];

    SCustomerInfo *info9 = [SCustomerInfo new];
    info9.label = @"Phone 3";
    info9.value = customerInfo[@"Phone3"];
    [self.customerInfoList addObject:info9];

    SCustomerInfo *info10 = [SCustomerInfo new];
    info10.label = @"Email";
    info10.value = customerInfo[@"EmailAddress"];
    [self.customerInfoList addObject:info10];
    
    SCustomerInfo *info11 = [SCustomerInfo new];
    info11.label = @"ESA Agreement";
    
    id agreeList = [job.swapiCustomerInfo valueForKeyPath:@"dsAgreeList.dsAgree"];
    NSDictionary *agree = nil;
    if ([agreeList isKindOfClass:[NSArray class]]) {
        agree = [[agreeList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Status == 'active'"]] firstObject];
    }
    else {
        agree = agreeList;
    }
    info11.value = ([agree[@"Status"] isEqualToString:@"active"]) ? @"Yes" :@"No";
    [self.customerInfoList addObject:info11];
    
    
    NSDateFormatter *serviceDateTimeFormatter = [[NSDateFormatter alloc] init];
    [serviceDateTimeFormatter setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *localDateTimeFormatter = [[NSDateFormatter alloc] init];
    [localDateTimeFormatter setDateFormat:@"MM/dd/yyyy"];
    for (NSDictionary *history in historyInfo) {

        SServiceHistory *history1 = [SServiceHistory new];
        NSDate          *d        = [serviceDateTimeFormatter dateFromString:history[@"InvoiceDate"]];

        history1.date         = (d ? [localDateTimeFormatter stringFromDate : d] : @"-");
        history1.amount       = (history[@"TotalAmount"] ? history[@"TotalAmount"] : @"-");
        history1.instructions = (history[@"Instructions"] ? history[@"Instructions"] : @"");
        history1.workDone     = (history[@"WorkDone"] ? history[@"WorkDone"] : @"");
        history1.workSugested = (history[@"WorkSugested"] ? history[@"WorkSugested"] : @"");

        [self.serviceHistoryList addObject:history1];
    }

    for (NSDictionary *equipment in equipmentList) {
        SSystemInfo *sysinfo = [SSystemInfo new];
        sysinfo.visible = YES;

        id       war           = equipment[@"dsWarList"][@"dsWar"];
        NSString *warrantyType = @"";
        NSString *warrantyDate = @"";
        if (war) {
            if ([war isKindOfClass:[NSArray class]]) {
                war = [war firstObject];
            }
            warrantyType = war[@"WarrantyType"];
            NSDate *d = [serviceDateTimeFormatter dateFromString:war[@"LaborEndDate"]];
            warrantyDate = [localDateTimeFormatter stringFromDate:d];
        }
        NSMutableArray *properties = @[].mutableCopy;

        SCustomerInfo *info1 = [SCustomerInfo new];
        info1.label = @"Unit name:";
        info1.value = equipment[@"ManufacturerDesc"];
        [properties addObject:info1];

        SCustomerInfo *info2 = [SCustomerInfo new];
        info2.label = @"Unit type:";
        info2.value = equipment[@"UnitTypeDesc"];
        [properties addObject:info2];

        SCustomerInfo *info3 = [SCustomerInfo new];
        info3.label = @"Model No:";
        info3.value = equipment[@"ModelNo"];
        [properties addObject:info3];

        SCustomerInfo *info4 = [SCustomerInfo new];
        info4.label = @"Serial No:";
        info4.value = equipment[@"SerialNo"];
        [properties addObject:info4];

        SCustomerInfo *info5 = [SCustomerInfo new];
        info5.label = @"Install Date:";
        info5.value = equipment[@"YearInstalled"];
        [properties addObject:info5];

        SCustomerInfo *info6 = [SCustomerInfo new];
        info6.label = @"Warranty Type:";
        info6.value = warrantyType;
        [properties addObject:info6];

        SCustomerInfo *info7 = [SCustomerInfo new];
        info7.label = @"Labor Coverage end date:";
        info7.value = warrantyDate;
        [properties addObject:info7];

        sysinfo.properties = properties;
        [self.systemInfoList addObject:sysinfo];
    }

    [self.tvCustomerInfo reloadData];
    [self.tvServiceHistory reloadData];
    [self.tvSystemInfo reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"customerQuestionsSegue"]) {
//        QuestionsVC *vc = segue.destinationViewController;
//        vc.questionType = self.selectedType;
//    }
    
    if ([segue.identifier isEqualToString:@"goSettingAgenda"]) {
        SettingAgendaVC *vc = segue.destinationViewController;
        vc.choosenType = self.selectedType;
    }
    //returnVisit
    
    if ([segue.identifier isEqualToString:@"returnVisit"]) {
        SummaryOfFindingsOptionsVC *vc = segue.destinationViewController;
           vc.isiPadCommonRepairsOptions = YES;
    }
    
}

#pragma mark -

- (IBAction)callTypeTouchUp:(UIButton *)sender {

    self.btnHeatingCall.selected = (sender == self.btnHeatingCall);
    self.btnCoolingCall.selected = !self.btnHeatingCall.selected;
    self.selectedType            = (self.btnHeatingCall.selected ? qtHeating : qtCooling);
}

- (IBAction)btnReturnVisit:(id)sender {
    [self performSegueWithIdentifier:@"returnVisit" sender:self];
}


- (IBAction)beginAppointment:(id)sender {
    
    
    [self performSegueWithIdentifier:@"goSettingAgenda" sender:self];
    
/*
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (!job.startTime) {
        job.startTime = [NSDate date];
        [job.managedObjectContext save];
    }
//    if (!job.startTimeQuestions) {
//        job.startTimeQuestions = [NSDate date];
//        [job.managedObjectContext save];
//    }
    
    job.startTimeQuestions = [NSDate date];
    [job.managedObjectContext save];
    
    [self performSegueWithIdentifier:@"customerQuestionsSegue" sender:self];
    */
}

- (void)toggleSectionVisibility:(NSInteger)section {
//    [self.tvSystemInfo beginUpdates];

    SSystemInfo *systemInfo = self.systemInfoList[section];
    systemInfo.visible = !systemInfo.visible;

    [self.tvSystemInfo reloadSections:[NSIndexSet indexSetWithIndex:section]
                     withRowAnimation :UITableViewRowAnimationFade];

//    [self.tvSystemInfo endUpdates];
}

#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tvCustomerInfo) {
        return 1;
    } else if (tableView == self.tvServiceHistory) {
        return 1;
    } else if (tableView == self.tvSystemInfo) {
        return [self.systemInfoList count];
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];

    [cell setNeedsLayout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvCustomerInfo) {
        SCustomerInfo *info = self.customerInfoList[indexPath.row];

        CustomerInfoTableViewCell *cell = (CustomerInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCustomerInfoCellIdentifier];
        cell.textLabel.text       = info.label;
        cell.detailTextLabel.text = info.value;
        return cell;
    } else if (tableView == self.tvServiceHistory) {
        SServiceHistory *history = self.serviceHistoryList[indexPath.row];

        ServiceHistoryTableViewCell *cell = (ServiceHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kServiceHistoryCellIdentifier];
        [cell displayData:history];
        return cell;
    } else if (tableView == self.tvSystemInfo) {
        SSystemInfo             *systemInfo = self.systemInfoList[indexPath.section];
        SCustomerInfo           *info       = systemInfo.properties[indexPath.row+1];
        SystemInfoTableViewCell *cell       = (SystemInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kSystemInfoCellIdentifier];
        cell.textLabel.text       = info.label;
        cell.detailTextLabel.text = info.value;
//        cell.textLabel.text = systemInfo.properties[indexPath.row + 1];
        return cell;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tvCustomerInfo) {

    } else if (tableView == self.tvServiceHistory) {

    } else if (tableView == self.tvSystemInfo) {

        __weak CustomerOverviewVC *weakSelf   = self;
        SSystemInfo               *systemInfo = self.systemInfoList[section];
        if (!systemInfo.headerView) {
            systemInfo.headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSystemInfoHeaderView];
            [systemInfo.headerView setOnToggle:^(SystemInfoHeaderView *headerView){
                 [weakSelf toggleSectionVisibility:headerView.tag];
             }];
        }

        systemInfo.headerView.tag       = section;
        systemInfo.headerView.collapsed = !systemInfo.visible;

        if ([systemInfo.properties count] > 0) {
            SCustomerInfo *info = systemInfo.properties[0];
            systemInfo.headerView.lbTitle.text = info.label;
            systemInfo.headerView.lbName.text  = info.value;
        } else {
            systemInfo.headerView.lbTitle.text = @"";
            systemInfo.headerView.lbName.text  = @"";
        }
        return systemInfo.headerView;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tvCustomerInfo) {
        return [self.customerInfoList count];
    } else if (tableView == self.tvServiceHistory) {
        return [self.serviceHistoryList count];
    } else if (tableView == self.tvSystemInfo) {
        SSystemInfo *systemInfo = self.systemInfoList[section];
        if (systemInfo.visible) {
            NSInteger count = [systemInfo.properties count] - 1;
            if (count < 0) {
                count = 0;
            }
            return count;
        } else {
            return 0;
        }
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tvCustomerInfo) {
        return 33.0;
    } else if (tableView == self.tvServiceHistory) {
        return [ServiceHistoryTableViewCell heightForData:self.serviceHistoryList[indexPath.row] andMaxWidth:tableView.frame.size.width];
    } else if (tableView == self.tvSystemInfo) {
        return 28.0;
    }

    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tvCustomerInfo) {

    } else if (tableView == self.tvServiceHistory) {

    } else if (tableView == self.tvSystemInfo) {
        return 28.0;
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
