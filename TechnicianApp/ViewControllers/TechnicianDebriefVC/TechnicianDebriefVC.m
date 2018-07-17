//
//  TechnicianDebriefVC.m
//  Signature
//
//  Created by Alexei on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//
typedef NS_ENUM (NSInteger, TDCellAlign){
    cLeft,
    cCenter,
    cRight
};

typedef NS_ENUM (NSInteger, CellType){
    ctCellDefault,
    ctCellTotalRevenue,
    ctCellAddOnSaleFuture,
    ctCellTotalRevenueGenerated
};


typedef NS_ENUM (NSInteger, TDCellAccType){
    lblCellAcc,
    drpDownCellAcc,
    txtViewCellAcc,
    txtFieldCellAcc,
    txtFieldNumericCellAcc,
    chkBoxCellAcc
};

#import "TechnicianDebriefVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CHDropDownTextField.h"
#import "AppDelegate.h"

#pragma mark - DebriefCell

@interface DebriefCell : UITableViewCell< UITextFieldDelegate,CHDropDownTextFieldDelegate>
@property (nonatomic, assign) TDCellAccType                cellType;
@property (nonatomic, strong) IBOutlet UILabel             *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel             *lblSubtitle;
@property (nonatomic, strong) IBOutlet CHDropDownTextField *txtField;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) IBOutlet UITextView          *txtView;
@property (nonatomic, strong) IBOutlet UIButton            *btnChkBox;
@property (nonatomic, strong) IBOutlet UILabel             *lblTitlePlaceHolder;
@property (nonatomic, strong) IBOutlet UILabel             *lblTextFieldPlaceHolder;
@property (nonatomic, strong) IBOutlet UIView              *separatorView;
@property (nonatomic, strong) IBOutlet UIView              *paddingView;
@property (nonatomic, strong) UIButton                     *btnRightTextFiled;
@property (nonatomic, copy) void (^onDropDown)(DebriefCell *cell);
@property (nonatomic, copy) void (^onDropDownValueChange)(DebriefCell *cell);
@property (nonatomic, copy) void (^onTextChange)(DebriefCell *cell, NSString *str);
@property (nonatomic, strong) NSMutableDictionary *cellData;
@property (nonatomic, readonly) NSDictionary      *valueForApi;
@property (weak, nonatomic) IBOutlet UIButton *finalizeButton;

@end

@implementation DebriefCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorView.y = self.frame.size.height-1;

}

- (void)setCellData:(NSMutableDictionary *)cellData {
    _cellData               = cellData;
    self.lblSubtitle.hidden = YES;
    self.txtField.hidden    = YES;
    self.btnChkBox.hidden = YES;
    self.textField.hidden = YES;
    self.cellType = [_cellData[@"accType"] integerValue];

    self.lblTitle.text = _cellData[@"title"];

    switch (self.cellType) {
    case lblCellAcc:
    {
        self.lblSubtitle.hidden = NO;
        self.lblSubtitle.text   = cellData[@"accVal"];
        break;
    }
    case drpDownCellAcc:
    {
        self.txtField.text = cellData[@"accVal"];

        if ([cellData[@"align"] integerValue] == cRight) {
            self.txtField.frame = self.lblTextFieldPlaceHolder.frame;
            self.lblTitle.frame = self.lblTitlePlaceHolder.frame;

        }
        if (!self.btnRightTextFiled) {
            self.btnRightTextFiled       = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnRightTextFiled.frame = CGRectMake(0, 0, self.txtField.frame.size.width-5, self.txtField.frame.size.width);
            [self.btnRightTextFiled setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
            self.btnRightTextFiled.imageEdgeInsets = UIEdgeInsetsMake(0, self.txtField.frame.size.width-25, 0.0f, 0.0f);
            self.btnRightTextFiled.titleEdgeInsets = UIEdgeInsetsMake(0, 0.0f, 0, 20);
            [self.btnRightTextFiled setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [self.btnRightTextFiled setTitle:self.txtField.text forState:UIControlStateNormal];
            [self.btnRightTextFiled.titleLabel setFont:self.txtField.font];
            [self.btnRightTextFiled setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
            [self.btnRightTextFiled addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.txtField.rightView     = self.btnRightTextFiled;
        self.txtField.rightViewMode = UITextFieldViewModeAlways;
        
        if (!self.paddingView) {
            self.paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        }
        self.txtField.leftView                     = self.paddingView;
        self.txtField.leftViewMode                 = UITextFieldViewModeAlways;
        self.txtField.layer.borderWidth            = 1;
        self.txtField.layer.borderColor            = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        self.txtField.hidden                       = NO;
        self.txtField.dropDownTableVisibleRowCount = MIN(6, [(NSArray *)cellData[@"possVals"] count]);
        self.txtField.dropDownTableTitlesArray     = cellData[@"possVals"];
        self.txtField.dropDownDelegate                     = self;
        break;
    }
    case txtViewCellAcc:
    {
        self.txtView.text              = cellData[@"accVal"];
        self.txtView.hidden            = NO;
        self.txtView.layer.borderWidth = 1;
        self.txtView.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        break;
    }
    case txtFieldCellAcc:
    case txtFieldNumericCellAcc:
    {
        
        self.textField.text = cellData[@"accVal"];

        if ([cellData[@"align"] integerValue] == cRight) {
            self.textField.frame = self.lblTextFieldPlaceHolder.frame;
            self.lblTitle.frame = self.lblTitlePlaceHolder.frame;

        }
        if (!self.paddingView) {
            self.paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        }
        self.textField.leftView          = self.paddingView;
        self.textField.leftViewMode      = UITextFieldViewModeAlways;
        self.textField.layer.borderWidth = 1;
        self.textField.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        self.textField.hidden            = NO;
        if (self.cellType == txtFieldNumericCellAcc) {
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        self.textField.delegate = self;
        self.textField.enabled = true;
        self.textField.userInteractionEnabled = true;
        break;
    }
    case chkBoxCellAcc:
    {
        self.btnChkBox.hidden = NO;
        [self.btnChkBox addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        break;
    }
    default:
        break;
    }
}

- (NSDictionary *)valueForApi {

    NSArray  *possValsTemp = _cellData[@"possVals"];
    NSArray  *apiValsTemp  = _cellData[@"APIValues"];
    NSString *value        = _cellData[@"accVal"];

    switch (_cellType) {
    case lblCellAcc:
    {
        value = apiValsTemp.firstObject;
        break;
    }
    case drpDownCellAcc:
    {
        value = self.txtField.text;
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
        value = self.txtView.text;
        break;
    }
    case txtFieldCellAcc:
    case txtFieldNumericCellAcc:
    {
        value = self.textField.text;
        break;
    }
    case chkBoxCellAcc:
    {
        value = apiValsTemp[self.btnChkBox.selected];
        break;
    }

    default:
        break;
    }

    return @{_cellData[@"APIField"] : value};
}

- (void)dropDownTextField:(CHDropDownTextField *)dropDownTextField didChooseDropDownOptionAtIndex:(NSUInteger)index {
    self.txtField.text = self.txtField.dropDownTableTitlesArray[index];
    [dropDownTextField hideDropDown];
    if (self.onDropDownValueChange) {
        self.onDropDownValueChange(self);
    }
}

- (void)dropDown:(id)sender {

    if (self.onDropDown) {
        self.onDropDown(self);
    }
}

- (void)select:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (self.cellType == drpDownCellAcc) {
        return NO;
    }
    if (self.onTextChange) {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.onTextChange(self, str);
    }
    return YES;
}

@end


@interface TechnicianDebriefVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary                 *itemDic;
@property (nonatomic, strong) NSArray                             *cellsArray;
@property (nonatomic, weak) IBOutlet UITableView                  *tableView;
@property (nonatomic, strong) NSArray                             *elementsToShow;
@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *keyboardAvoiding;
@property (nonatomic, strong) Job                                 *jobToDebrief;
@property (nonatomic, strong) NSArray                             *departments;
@property (nonatomic, strong) NSArray                             *whoList;
@property (nonatomic, strong) NSArray                             *whoListCodes;
@property (nonatomic, strong) NSString                            *whoCurrent;

@property (nonatomic, strong) DebriefCell *totalRevenuCell;
@property (nonatomic, strong) DebriefCell *addOnFutureRevenuCell;
@property (nonatomic, strong) DebriefCell *totalRevenuGeneratedCell;



@property (nonatomic, strong) NSMutableArray * scheduledDependecesCells;
@property (nonatomic, strong) NSMutableArray * scheduledDependecesCellsTitles;

@property (nonatomic, strong) NSMutableArray * allCellsArray;
@property (nonatomic, strong) NSNumber * getcArray;

@property (nonatomic, strong) NSNumber* hideSection1;
@property (nonatomic, strong) NSNumber* hideSection2;
@property (nonatomic, strong) NSNumber* hideSection3;

@property (nonatomic, strong) NSNumber* defaulthideSection1;
@property (nonatomic, strong) NSNumber* defaulthideSection2;
@property (nonatomic, strong) NSNumber* defaulthideSection3;

@property (nonatomic, strong) NSNumber* loadet;
@property (weak, nonatomic) IBOutlet UIButton *finalizeBtn;
@end

@implementation TechnicianDebriefVC

static NSString *kDebriefCellIdentifier = @"debriefCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    self.loadet = [NSNumber numberWithBool:NO];
    self.hideSection1 = [NSNumber numberWithBool:NO];
    self.hideSection2 = [NSNumber numberWithBool:NO];
    self.hideSection3 = [NSNumber numberWithBool:NO];
    
    self.title = @"Technical Debrief";
    [self configureColorScheme];
 

    self.keyboardAvoiding.contentSize = self.tableView.frame.size;

    self.jobToDebrief = [[[DataLoader sharedInstance] currentUser] activeJob];
    [self.jobToDebrief.managedObjectContext save];

    self.departments = [self.jobToDebrief.swapiJobInfo objectForKey:@"departmentList"];  //[[[DataLoader sharedInstance] SWAPIManager] departmentList];
   
    
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
    
    self.allCellsArray = [[NSMutableArray alloc]init];
    self.getcArray = [NSNumber numberWithBool:YES];
    
    [self reloadData];
   
     self.getcArray = [NSNumber numberWithBool:NO];
   
    [[TechDataModel sharedTechDataModel] saveCurrentStep:TechnicianDebrief];
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = TechnicianDebrief;
}
#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.finalizeBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {

    self.elementsToShow = [self defaultCellsArray];

    [self.tableView reloadData];
    
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

- (NSDictionary *)dictionaryWithvaluesForAPI {

    NSMutableDictionary *result = @{}.mutableCopy;
    
    
    /////
    
    NSInteger sect = [self.tableView numberOfSections];
    
    for (NSInteger i = 0; i < sect - 1; i++) {
        NSInteger rows = [self.tableView numberOfRowsInSection:i];
        for (NSInteger j = 0; j < rows; j++) {
            DebriefCell *cell = (DebriefCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [result addEntriesFromDictionary:cell.valueForApi];
        }
    }
    
    [result addEntriesFromDictionary:@{@"user_id" : [[[DataLoader sharedInstance] currentUser] userID]}];
    [result addEntriesFromDictionary:@{@"status" : @(0)}];

    NSTimeInterval distanceBetweenQuestions = [self.jobToDebrief.startTimeQuestions timeIntervalSinceDate:self.jobToDebrief.endTimeQuestions];
    double         secondsInAnHour          = 60;
    double         totalMinutes             = ABS(distanceBetweenQuestions / secondsInAnHour);
    
    [result addEntriesFromDictionary:@{@"time_of_questions" : [NSString stringWithFormat:@"%.2f", totalMinutes]}];

    return result;
}

- (IBAction)btnFinalizeTouch:(id)sender {

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
}

- (void)debriefCurrentJob {

    self.jobToDebrief.jobStatus = @(jstDone);
    [self.jobToDebrief.managedObjectContext save];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.homeController) {
        [self.navigationController popToViewController:appDelegate.homeController animated:YES];
    }else {
        UIViewController* homeViewController = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:homeViewController animated:true];
    }
    
    [[TechDataModel sharedTechDataModel] saveCurrentStep:TechNone];
    //[appDelegate.homeController getNextJob];
    ShowOkAlertWithTitle(@"Job Done!", appDelegate.homeController);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return 13;
            break;
        case 1: return  [self.hideSection1 boolValue]? 1 : 2;
            break;
        case 2: return  [self.hideSection2 boolValue]? 1 : 12;
            break;
        case 3: return  7;
            break;
        case 4: return  1;
            break;
        case 5 : return 2;
            break;
        case 6 : return 1;
            break;
        default:
            break;
    }
    return self.elementsToShow.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int sectionIdx = 0 ;
    switch (indexPath.section) {
        case 0:
            sectionIdx = 0;
            break;
        case 1:
            sectionIdx = 13;
            break;
        case 2:
            sectionIdx = 15;
            break;
        case 3:
            sectionIdx = 27;
           break;
        case 4:
            sectionIdx = 34;
            break;
        case 5:
            sectionIdx = 35;
            break;
        case 6:
            sectionIdx = 36;
            break;
        default:
            break;
    
    }
    
    if (indexPath.section == 6)  {
        return 90;
    } else
    {
    if ([self.elementsToShow[indexPath.row + sectionIdx][@"accType"] integerValue] == txtViewCellAcc) {
        return 90.0f;
    
    }}
    
    return 42.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 6)  {
         DebriefCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savecell"];
         cell.finalizeButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
         cell.backgroundColor = [UIColor clearColor];
         return cell;
     }
    
         int sectionIdx = 0 ;
    switch (indexPath.section) {
        case 0:
            sectionIdx=0;
            break;
        case 1:
            sectionIdx=13;
            break;
        case 2:
            sectionIdx =15;
            break;
        case 3:
            sectionIdx = 27;
            break;
        case 4:
            sectionIdx = 34;
            break;
        case 5:
            sectionIdx = 35;
            break;
        case 6:
            sectionIdx = 36;
            break;
        default:
            break;
    }
    
    if (![self.getcArray boolValue] && self.allCellsArray && self.allCellsArray.count == self.elementsToShow.count){
        DebriefCell *  cell = [self.allCellsArray objectAtIndex:(indexPath.row + sectionIdx)];
        return cell;
    }
    
    DebriefCell *  cell = [tableView dequeueReusableCellWithIdentifier:kDebriefCellIdentifier];
    cell.cellData  = self.elementsToShow[indexPath.row+sectionIdx];
    
    cell.separatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    cell.lblTitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    cell.lblSubtitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    cell.txtField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    cell.textField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    cell.backgroundColor = [UIColor clearColor];
    
    if ([self.elementsToShow[indexPath.row + sectionIdx][@"accType"] integerValue] == drpDownCellAcc) {
        
        
        if ([cell.lblTitle.text isEqualToString:@"Call Back"]) {
            self.defaulthideSection1 = [NSNumber numberWithBool:[cell.txtField.text isEqualToString:@"NO"]];
            
        }
        
        if ([cell.lblTitle.text isEqualToString:@"Repair Scheduled"]) {
            self.defaulthideSection2 = [NSNumber numberWithBool:[cell.txtField.text isEqualToString:@"NO"]];
            
        }
        
        if ([cell.lblTitle.text isEqualToString:@"Follow Up Required"]) {
            self.defaulthideSection3 = [NSNumber numberWithBool:[cell.txtField.text isEqualToString:@"NO"]];
            
        }

        
        [cell setOnDropDownValueChange:^(DebriefCell *aCell) {
            
            
            if ([aCell.lblTitle.text isEqualToString:@"Call Back"]) {
                self.hideSection1 = [NSNumber numberWithBool:[aCell.txtField.text isEqualToString:@"NO"]];
                [self.tableView reloadData];
            }
            
            if ([aCell.lblTitle.text isEqualToString:@"Repair Scheduled"]) {
                self.hideSection2 = [NSNumber numberWithBool:[aCell.txtField.text isEqualToString:@"NO"]];
 
              [self.tableView reloadData];
            }
            
            if ([aCell.lblTitle.text isEqualToString:@"Follow Up Required"]) {
                self.hideSection3 = [NSNumber numberWithBool:[aCell.txtField.text isEqualToString:@"NO"]];
               [self.tableView reloadData];
             
            }
            
        }];
        
        [cell setOnDropDown:^(DebriefCell *aCell) {
            if ([self.tableView.subviews containsObject:aCell.txtField.dropDownTableView]) {
                [aCell.txtField resignFirstResponder];
            } else {
              [aCell.txtField becomeFirstResponder];
              if ([aCell.cellData[@"accType"] integerValue] == 1) {
                [aCell.txtField resignFirstResponder];
              }
                aCell.txtField.dropDownTableView.hidden = NO;
                [self.tableView addSubview:aCell.txtField.dropDownTableView];
            }
            
            CGRect dropdownOriginFrame = CGRectMake(0, 30, aCell.txtField.dropDownTableView.frame.size.width, aCell.txtField.dropDownTableView.frame.size.height);
            CGRect frame = [self.tableView convertRect:dropdownOriginFrame fromView:aCell.txtField];
            aCell.txtField.dropDownTableView.frame = frame;
            
        }];
    }
    
    cell.tag = [cell.cellData[@"cellType"] integerValue];
    
    __weak typeof (self) weakSelf = self;
    [cell setOnTextChange:^(DebriefCell *c, NSString *str) {
        CGFloat sum1 = (c == weakSelf.totalRevenuCell ? str.doubleValue : [weakSelf.totalRevenuCell.textField.text doubleValue]);
        CGFloat sum2 = (c == weakSelf.addOnFutureRevenuCell ? str.doubleValue : [weakSelf.addOnFutureRevenuCell.textField.text doubleValue]);
        CGFloat totalSum = sum1 + sum2;
        
        [weakSelf.elementsToShow enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"cellType"] integerValue] == ctCellTotalRevenueGenerated) {
                obj[@"accVal"] = [self changeCurrencyFormat:totalSum];
                obj[@"APIValues"] = @[[self changeCurrencyFormat:totalSum]];
                weakSelf.totalRevenuGeneratedCell.cellData = obj;
                *stop = YES;
            }
        }];
    }];
    
    switch (cell.tag) {
        case ctCellTotalRevenue:
            self.totalRevenuCell = cell;
            break;
        case ctCellAddOnSaleFuture:
            self.addOnFutureRevenuCell = cell;
            break;
        case ctCellTotalRevenueGenerated:
            self.totalRevenuGeneratedCell = cell;
            break;
        default:
            break;
    }
    
    [self.allCellsArray addObject:cell];
          return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;//50;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
   return [NSString stringWithFormat:@"%li",(long)section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Perform some final layout updates
    if (section == ([tableView numberOfSections] - 1)) {
        [self tableViewWillFinishLoading:tableView];
    }
    
    // Return nil, or whatever view you were going to return for the footer
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableViewWillFinishLoading:(UITableView *)tableView
{
    NSLog(@"finished loading");
    if (![self.loadet boolValue]){
        self.loadet = [NSNumber numberWithBool:YES];
        self.hideSection1 =  self.defaulthideSection1;
        self.hideSection2 =  self.defaulthideSection2;
        self.hideSection3 =  self.defaulthideSection3;
        
        [self.tableView reloadData];
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
@end
