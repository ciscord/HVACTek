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
- (void) prepareForReuse{

    NSLog(@"adscads");
}

- (void)setCellData:(NSMutableDictionary *)cellData {
    _cellData               = cellData;
    self.lblSubtitle.hidden = YES;
    self.txtField.hidden    = YES;
    self.btnChkBox.hidden = YES;

    
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
            [self.btnRightTextFiled setTitleColor:self.txtField.textColor forState:UIControlStateNormal];
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
        self.txtField.layer.borderColor            = [[UIColor colorWithWhite:0.960 alpha:1.000] CGColor];
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
        self.txtView.layer.borderColor = [[UIColor colorWithWhite:0.960 alpha:1.000] CGColor];
        break;
    }
    case txtFieldCellAcc:
    case txtFieldNumericCellAcc:
    {
        self.txtField.text = cellData[@"accVal"];

        if ([cellData[@"align"] integerValue] == cRight) {
            self.txtField.frame = self.lblTextFieldPlaceHolder.frame;
            self.lblTitle.frame = self.lblTitlePlaceHolder.frame;

        }
        if (!self.paddingView) {
            self.paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        }
        self.txtField.leftView          = self.paddingView;
        self.txtField.leftViewMode      = UITextFieldViewModeAlways;
        self.txtField.layer.borderWidth = 1;
        self.txtField.layer.borderColor = [[UIColor colorWithWhite:0.960 alpha:1.000] CGColor];
        self.txtField.hidden            = NO;
        if (self.cellType == txtFieldNumericCellAcc) {
            self.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
      //  self.txtField.delegate = self;
        break;
    }
    case chkBoxCellAcc:
    {
        self.btnChkBox.hidden = NO;
        [self.btnChkBox addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//            self.btnChkBox.layer.borderWidth=1;
//            self.btnChkBox.layer.borderColor=[[UIColor colorWithRed:143./255 green:200./255 blue:73./255 alpha:0.8] CGColor];
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
        value = self.txtField.text;
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

    if ([[(CHDropDownTextField *)textField dropDownTableTitlesArray] count]) {
        [textField resignFirstResponder];
    }
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
@end

@implementation TechnicianDebriefVC

static NSString *kDebriefCellIdentifier = @"debriefCellIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadet = [NSNumber numberWithBool:NO];
    self.hideSection1 = [NSNumber numberWithBool:NO];
    self.hideSection2 = [NSNumber numberWithBool:NO];
    self.hideSection3 = [NSNumber numberWithBool:NO];
    
    self.title = @"Technical Debrief";
 

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

    NSMutableDictionary *jobName                 = [self itemDicWith:@"Job Name" accType:lblCellAcc accVal:jobNameValue possVals:@[] align:cCenter APIField:@"job_name" APIValues:@[jobNameValue]];
    NSMutableDictionary *jobNumber               = [self itemDicWith:@"Job Number" accType:lblCellAcc accVal:self.jobToDebrief.swapiJobInfo[@"JobNo"] possVals:@[] align:cCenter APIField:@"job_number" APIValues:@[self.jobToDebrief.swapiJobInfo[@"JobNo"]]];
    NSMutableDictionary *department              = [self itemDicWith:@"Department" accType:drpDownCellAcc accVal:@"" possVals:self.departments align:cCenter APIField:@"departament" APIValues:self.departments];
    NSMutableDictionary *dispathTime             = [self itemDicWith:@"Dispath Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.dispatchTime] possVals:@[] align:cCenter APIField:@"dispatch_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.dispatchTime]]];
    NSMutableDictionary *startTime               = [self itemDicWith:@"Start Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.startTime] possVals:@[] align:cCenter APIField:@"start_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.startTime]]];
    NSMutableDictionary *completionTime          = [self itemDicWith:@"Completion Time" accType:lblCellAcc accVal:[dateTimeFormatterToDisplay stringFromDate:self.jobToDebrief.completionTime] possVals:@[] align:cCenter APIField:@"completion_time" APIValues:@[[dateTimeFormatterToAPI stringFromDate:self.jobToDebrief.completionTime]]];
    NSMutableDictionary *totalHours              = [self itemDicWith:@"Total Hours" accType:lblCellAcc accVal:[NSString stringWithFormat:@"%.2f", totalHoursValue] possVals:@[] align:cCenter APIField:@"total_hours" APIValues:@[[NSString stringWithFormat:@"%.2f", totalHoursValue]]];
    NSMutableDictionary *ageOfSystem             = [self itemDicWith:@"Age Of System" accType:txtFieldNumericCellAcc accVal:jobInfo[@"UnitAge"] possVals:@[] align:cCenter APIField:@"age_of_system" APIValues:@[]];
    NSMutableDictionary *replacementLeadSheduled = [self itemDicWith:@"Replacement Lead Sheduled" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"replacement_lead_scheduled" APIValues:@[@1, @0]];
    NSMutableDictionary *newESAOpportunity       = [self itemDicWith:@"New ESA Opportunity" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"new_esa_opportunity" APIValues:@[@1, @0]];
    NSMutableDictionary *esaRenewallOpportunity  = [self itemDicWith:@"ESA Renewall Opportunity" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"esa_renewal_opportunity" APIValues:@[@1, @0]];
    NSMutableDictionary *esaSold                 = [self itemDicWith:@"ESA Sold" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"esa_sold" APIValues:@[@1, @0]];
    //NSMutableDictionary *workPerformed           = [self itemDicWith:@"Work Performed" accType:txtViewCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"work_performed" APIValues:@[]];
    //NSMutableDictionary *diagnosticOnlyRevenue   = [self itemDicWith:@"Diagnostic Only Revenue" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"diagnostic_only_revenue" APIValues:@[]];
    //NSMutableDictionary *maintenanceRevenue      = [self itemDicWith:@"Maintenance Revenue" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"maintenance_revenue" APIValues:@[]];
    NSMutableDictionary *totalRevenue            = [self itemDicWith:@"Total Revenue Today" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"total_revenue" APIValues:@[] cellValueType:ctCellTotalRevenue];
    //NSMutableDictionary *addOnSaleFuture         = [self itemDicWith:@"Add On Sale Future" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"add_on_sale_future" APIValues:@[] cellValueType:ctCellAddOnSaleFuture];
    //NSMutableDictionary *totalRevenueGenerated   = [self itemDicWith:@"Total Revenue Generated" accType:lblCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"total_revenua_generated" APIValues:@[@""] cellValueType:ctCellTotalRevenueGenerated];
//    NSMutableDictionary *billableHours                      = [self itemDicWith:@"Billable Hours" accType:lblCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"billable_hours" APIValues:@[@""]];
//    NSMutableDictionary *billableHoursEfficiency            = [self itemDicWith:@"Billable Hours Efficiency" accType:lblCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"billable_hours_efficiency" APIValues:@[@""]];
    NSMutableDictionary *paymentCollected                   = [self itemDicWith:@"Payment Collected" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"payment_collected" APIValues:@[@1, @0]];
    NSMutableDictionary *paymentMethod                      = [self itemDicWith:@"Payment Method" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"payment_method" APIValues:@[]];
    NSMutableDictionary *callBack                           = [self itemDicWith:@"Call Back" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"callback" APIValues:@[@1, @0]];
    NSMutableDictionary *who                                = [self itemDicWith:@"Who" accType:drpDownCellAcc accVal:self.whoCurrent possVals:self.whoList align:cCenter APIField:@"who" APIValues:self.whoListCodes];
    NSMutableDictionary *repairScheduled                    = [self itemDicWith:@"Repair Scheduled" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"repair_scheduled" APIValues:@[@1, @0]];
    NSMutableDictionary *priceQuoted                        = [self itemDicWith:@"Price Quoted" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"price_quoted" APIValues:@[]];
    NSMutableDictionary *priceApproved                      = [self itemDicWith:@"Price Approved" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cRight APIField:@"price_approved" APIValues:@[@1, @0]];
    NSMutableDictionary *ammountof50PercentDepositCollected = [self itemDicWith:@"Ammount Of 50% Deposit Collected" accType:txtFieldNumericCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"deposit_collected" APIValues:@[]];
    NSMutableDictionary *partsOrderedBy                     = [self itemDicWith:@"Parts Ordered By" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"parts_ordered_by" APIValues:@[]];
    NSMutableDictionary *supplerPartsOrderedFrom            = [self itemDicWith:@"Supplier Parts Ordered From" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"supplier_parts_ordered_form" APIValues:@[]];
    NSMutableDictionary *timeNeededForRepair                = [self itemDicWith:@"Time Needed For Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"time_needed_for_repair" APIValues:@[]];
    NSMutableDictionary *whenIsTheRepairScheduled           = [self itemDicWith:@"When Is The Repair Scheduled" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"when_repair_scheduled" APIValues:@[]];
    NSMutableDictionary *modelOfSystemNeedingRepair         = [self itemDicWith:@"Model Of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"model_system_needing_required" APIValues:@[]];
    NSMutableDictionary *serialNumberOfSystemNeedingRepair  = [self itemDicWith:@"Serial Number Of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"serial_number_system_needing_repair" APIValues:@[]];
    NSMutableDictionary *locationOfSystemNeedingRepair      = [self itemDicWith:@"Location of System Needing Repair" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"location_system_needing_repair" APIValues:@[]];
    NSMutableDictionary *specialInstructionsOrToolsRequired = [self itemDicWith:@"Special Instructions Or Tools Required" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cRight APIField:@"special_instructions_or_tools_required" APIValues:@[]];
    NSMutableDictionary *installAndSignAllStickers          = [self itemDicWith:@"Install And Sign All Stickers" accType:chkBoxCellAcc accVal:@"" possVals:@[@0, @1] align:cRight APIField:@"sign_all_stickers" APIValues:@[@0, @1]];
    NSMutableDictionary *allEquipmentInSystem               = [self itemDicWith:@"All Equipment In System" accType:chkBoxCellAcc accVal:@"" possVals:@[@0, @1] align:cRight APIField:@"all_equipment_in_system" APIValues:@[@0, @1]];
    NSMutableDictionary *sentAnglesListReviewLink           = [self itemDicWith:@"Sent Angie's List Review Link" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"list_review_link" APIValues:@[@1, @0]];
    NSMutableDictionary *sentReviewBuzzLink                 = [self itemDicWith:@"Sent Review Buzz Link" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"buzz_link" APIValues:@[@1, @0]];
    NSMutableDictionary *attachAllPartsUsedToTicked         = [self itemDicWith:@"Johnstone App Parts Ordered" accType:drpDownCellAcc accVal:@"NO" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"attach_all_parts_used_to_tiket" APIValues:@[@0, @1]];
    NSMutableDictionary *thermostatSetAndSystemRunning      = [self itemDicWith:@"Thermostat Set & System Running" accType:chkBoxCellAcc accVal:@"" possVals:@[@0, @1] align:cRight APIField:@"system_running" APIValues:@[@0, @1]];
    NSMutableDictionary *followUpRequired                   = [self itemDicWith:@"Follow Up Required" accType:drpDownCellAcc accVal:@"YES" possVals:@[@"YES", @"NO"] align:cCenter APIField:@"follow_up_required" APIValues:@[@1, @0]];
    
      NSMutableDictionary *followUpNotes             = [self itemDicWith:@"Notes" accType:txtFieldCellAcc accVal:@"" possVals:@[] align:cCenter APIField:@"age_of_system" APIValues:@[]];

//    if ([callBack[@"accVal"]  isEqual: @"YES"]) {
//        NSLog(@"YES selected");
//    }
    return @[jobName,
             jobNumber,
             department,
             dispathTime,
             startTime,
             completionTime,
             totalHours,
             ageOfSystem,
             replacementLeadSheduled,
             newESAOpportunity,
             esaRenewallOpportunity,
             esaSold,
             //workPerformed,
             //diagnosticOnlyRevenue,
             //maintenanceRevenue,
             totalRevenue,
             //addOnSaleFuture,
             //totalRevenueGenerated,
//             billableHours,
//             billableHoursEfficiency,
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
             allEquipmentInSystem,
             sentAnglesListReviewLink,
             sentReviewBuzzLink,
             attachAllPartsUsedToTicked,
             thermostatSetAndSystemRunning,
             followUpRequired,
             followUpNotes];
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
    for (NSInteger i = 0; i < self.elementsToShow.count; i++) {

        DebriefCell *cell = (DebriefCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [result addEntriesFromDictionary:cell.valueForApi];
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
                                              
         [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
         [weakSelf debriefCurrentJob];

     } onError:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
         ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
     }];
}

- (void)debriefCurrentJob {

    self.jobToDebrief.jobStatus = @(jstDone);
    [self.jobToDebrief.managedObjectContext save];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController popToViewController:appDelegate.homeController animated:YES];
    //[appDelegate.homeController getNextJob];
    ShowOkAlertWithTitle(@"Job Done!", appDelegate.homeController);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case 0: return 15;
            break;
        case 1: return  [self.hideSection1 boolValue]? 1 : 2;
            break;
        case 2: return  [self.hideSection2 boolValue]? 1 : 12;
            break;
        case 3: return  6;
            break;
        case 4: return  [self.hideSection3 boolValue]? 1 : 2;
            break;
        case 5 : return 1;
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
            sectionIdx=0;
            break;
        case 1:
            sectionIdx=15;
            break;
        case 2:
            sectionIdx =17;
            break;
        case 3:
            sectionIdx = 29;
           break;
        case 4:
            sectionIdx = 35;
        default:
            break;
    
    }
    
    if (indexPath.section == 5)  {
        return 90;
    } else
    {
    if ([self.elementsToShow[indexPath.row + sectionIdx][@"accType"] integerValue] == txtViewCellAcc) {
        return 90.0f;
    
    }}
    
    return 42.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 5)  {
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savecell"];
         return cell;
     }
    
         int sectionIdx = 0 ;
    switch (indexPath.section) {
        case 0:
            sectionIdx=0;
            break;
        case 1:
            sectionIdx=15;
            break;
        case 2:
            sectionIdx =17;
            break;
        case 3:
            sectionIdx = 29;
            break;
        case 4:
            sectionIdx = 35;
        default:
            break;
    }
    
    
    if (![self.getcArray boolValue] && self.allCellsArray && self.allCellsArray.count == self.elementsToShow.count){
        DebriefCell *  cell = [self.allCellsArray objectAtIndex:(indexPath.row + sectionIdx)];
        return cell;
    }
    
    
   //   NSLog(@"r %ld",(long)indexPath.row);
     NSLog(@"%ld sectia %ld",(long)indexPath.row + sectionIdx, indexPath.section);
    
    
     DebriefCell *  cell = [tableView dequeueReusableCellWithIdentifier:kDebriefCellIdentifier];
    cell.cellData  = self.elementsToShow[indexPath.row+sectionIdx];
    
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
                aCell.txtField.dropDownTableView.hidden = NO;
                [self.tableView addSubview:aCell.txtField.dropDownTableView];
                
            }
            
            
            
            CGRect frame = [self.tableView convertRect:aCell.txtField.dropDownTableView.frame fromView:aCell.txtField];
            aCell.txtField.dropDownTableView.frame = frame;
            
        }];
    }
    cell.tag = [cell.cellData[@"cellType"] integerValue];
    
    __weak typeof (self) weakSelf = self;
    [cell setOnTextChange:^(DebriefCell *c, NSString *str) {
        CGFloat sum1 = (c == weakSelf.totalRevenuCell ? str.doubleValue : [weakSelf.totalRevenuCell.txtField.text doubleValue]);
        CGFloat sum2 = (c == weakSelf.addOnFutureRevenuCell ? str.doubleValue : [weakSelf.addOnFutureRevenuCell.txtField.text doubleValue]);
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
    
    
    //*************************************************************
//    if ([cell.lblTitle.text isEqualToString:@"Price Quoted"]) {
//        self.priceQuotedCell  = cell;
//        self.priceQuotedCell.hidden = YES;
//    }
//    
//    if ([cell.lblTitle.text isEqualToString:@"Price Approved"]) {
//        self.priceAppruvedCell  = cell;
//        self.priceAppruvedCell.hidden = YES;
//    }
    
//    if ([cell.lblTitle.text isEqualToString:@"Who"]) {
//        self.whoCell  = cell;
//        self.whoCell.hidden = YES;
//    }
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



#pragma mark - Currency String

- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithFloat:number]];
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