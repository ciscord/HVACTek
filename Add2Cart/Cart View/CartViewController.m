//
//  CartViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "CartViewController.h"

//cels
@interface CellProducts : UITableViewCell;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation CellProducts

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end


@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *productList;
@property (strong, nonatomic) IBOutlet UIView *vTableviewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSystemRebate;
@property (strong, nonatomic) IBOutlet UILabel *lblFinancingD;
@property (strong, nonatomic) IBOutlet UILabel *lblFinancingSum;
@property (strong, nonatomic) IBOutlet UILabel *lblInvestment;
@end

@implementation CartViewController
@synthesize cartItems;
@synthesize rebates;
@synthesize yourOrderLabel, afterSavingsLabel, finance, monthlypayment, productsView;
@synthesize months;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    

    headers = [[NSArray alloc]initWithObjects:@"Air Conditioners",@"Heat Pumps", @"Furnaces",@"Air Handlers"
               ,@"Geothermal", @"Indoor Air Quality",@"Controls", nil]; //@"Rebates"

 
    products = [[NSMutableString alloc]init];
    self.productList =[[NSMutableArray alloc]init];
    
    productsView.editable = YES;
    [productsView setFont:[UIFont fontWithName:@"arial" size:24]];
    
    productsView.editable = NO;
    
    
    [self buildQuote];
    [self updateProductList];
    [self.btnEmail setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) buildQuote {
//    
//    
//    float totalAmount;
//    float totalSavings;
//    float afterSavings;
//    float finacePay;
//    float monthlyPay;
//    
//    totalAmount = 0.0f;
//    
//    for (int jj = 0; jj <cartItems.count; jj++) {
//        Item *itm = cartItems[jj];
//        totalAmount += [itm.finalPrice floatValue];
//    }
//    
//    for (int jj = 0; jj <rebates.count; jj++) {
//        Item *itm = rebates[jj];
//        totalSavings += [itm.finalPrice floatValue];
//    }
//    
//    
//    
//    //months = 60;
//    if (months == 60) {
//        perc = 1.67f;
//    } else if  (months == 24){
//        perc = 4.17f;
//    } else if (months == 36) {
//        perc = 2.78f;
//    } else if (months == 48) {
//        perc     = 2.09f;
//    } else if (months == 120){
//        perc = 1.06f;
//    }
//    
//     NSLog(@"Months is %d and perc is %f",months,perc);
//    
//    afterSavings = totalAmount - totalSavings;
//    float o = afterSavings / 100.0f;
//    float p = o * perc;
//    float q = p + afterSavings;
//    finacePay = q / months;
//    
//    float n = afterSavings / 100.0f;
//    float m = n * 4.99f;
//    float w = m + afterSavings;
//    float y = w / 100.0f;
//    float i = y * 1.06f;
//    float j = i + afterSavings;
//    monthlyPay = j / 120.0f;
//    [self updateLabels:totalAmount :totalSavings :afterSavings :finacePay :monthlyPay];
//    
//

    float totalAmount;
       float totalSavings;
        float afterSavings;
        float finacePay;
        float monthlyPay;
    totalAmount = 0.0f;
 
    
    for (int jj = 0; jj <cartItems.count; jj++) {
        Item *itm = cartItems[jj];
        if ([itm.type isEqualToString:@"TypeThree"]&&[itm.optionOne floatValue]!=0)
        {
            totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
        }
        else
        {
            totalAmount += [itm.finalPrice floatValue];
        }

      //  totalAmount += [itm.finalPrice floatValue];
    }

    for (int jj = 0; jj <rebates.count; jj++) {
        Item *itm = rebates[jj];
        totalSavings += [itm.finalPrice floatValue];
    }
    
    float invest;
    switch (months) {
        case 24:
        {
            finacePay =  (totalAmount - totalSavings)/.915/24;
            invest = (finacePay*24);
            break;
        }
            
        case 36:
        {
            finacePay = (totalAmount - totalSavings)/.88/36;
            invest = (finacePay*36);
            break;
        }
        case 48:{
            finacePay = (totalAmount - totalSavings)/.865/48;
            invest = (finacePay*48);
            break;
        }
        case 60:{
            finacePay = (totalAmount - totalSavings)/.85/60;
            invest = (finacePay*60);
            break;
        }
        case 84:{
            finacePay = (totalAmount - totalSavings)/.8975 * 0.0144;
            invest = (totalAmount - totalSavings)/.8975;
            break;
        }
        case 144:{
            finacePay = (totalAmount - totalSavings)/.909 * 0.0111;
            invest = (totalAmount - totalSavings)/.909;
            break;
        }
        default:
        {
            finacePay = totalAmount - totalSavings;
            invest=  (totalAmount - totalSavings);
            break;
        }
    }
    
    [self updateLabels:invest :totalSavings :afterSavings :finacePay :monthlyPay ];
    //[self updateLabels:totalAmount :totalSavings :afterSavings :finacePay :monthlyPay ];

}

//-(void) updateLabels:(float)totalAmount :(float)totalSavings :(float)afterSavings :(float)finacePay :(float)monthlyPay {

-(void) updateLabels:(float)total :(float)totalSave :(float)afterSaving :(float)financeP :(float)month {
//    yourOrderLabel.text = [NSString stringWithFormat:@"$%.2f",totalAmount];
//    afterSavingsLabel.text =[NSString stringWithFormat:@"$%.2f",afterSavings];
//    finance.text = [NSString stringWithFormat:@"$%.2f",finacePay];
//    monthlypayment.text = [NSString stringWithFormat:@"$%.2f",monthlyPay];
   
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:2];
    //[formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    //new
    self.lblSystemRebate.text=[NSString stringWithFormat:@"$%@",[nf stringFromNumber:[NSNumber numberWithFloat:totalSave]]];
    self.lblInvestment.text = [NSString stringWithFormat:@"$%@",[nf stringFromNumber:[NSNumber numberWithFloat:total]]];
    switch (months) {
        case 84:
            //3.99% Best Rate 84 Months
            self.lblFinancingD.text =[NSString stringWithFormat:@"3.99%% Best Rate \n%i Months",months];
           
            break;
        case 144:
            self.lblFinancingD.text =[NSString stringWithFormat:@"7.99%% Lowest Payment \n%i Months",months];
            break;
            
        case 0:
            self.lblFinancingD.text =[NSString stringWithFormat:@"Cash /Check /Credit Card"];
            break;
            
        default:
            self.lblFinancingD.text =[NSString stringWithFormat:@"0%% Financing\n%i Equal Payments",months];
            break;
    }
    
     self.lblFinancingSum.text =[NSString stringWithFormat:@"$%@",[nf stringFromNumber:[NSNumber numberWithFloat:financeP]]];
    

}



-(float) parseTheString:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 1) {
    
    
    NSString *stringy = strip[1];
    //    NSLog(@"Strip holds %d the first is %@ and second %@",strip.count, strip[0], strip[1]);
    
    
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:stringy.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:stringy];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    NSLog(@"%@", strippedString); // "123123123"
    
    return [strippedString floatValue];
    } else {
        return  [string floatValue];
    }
}



- (IBAction)btnDone:(id)sender {
    [self home];
}

-(void) home {
  
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) updateProductList {
    for (int x = 0; x < cartItems.count; x++){
        Item *itm = cartItems[x];
        
        if ( [itm.type isEqualToString:@"TypeOne"] || [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"] ) {
            // do nothing
            
        } else {
            [products appendString:[NSString stringWithFormat:@"%@\n",itm.modelName]];
            [self.productList addObject:itm.modelName];
        }
        
       
    }
    
    productsView.text = products;
    [self.tableView reloadData];
    
    self.vTableviewHeader.hidden=(self.productList.count==0);
}



- (IBAction)email:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Quote from Signature Quote App";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"\nProducts for Quote:\n\n\n%@,",products];
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"quizfeedback@cisi.org"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setToRecipients:toRecipents];
    [[mc navigationBar] setTintColor:[UIColor whiteColor]];
    [[mc navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (IBAction)mainMenu:(id)sender {
    //[self performSegueWithIdentifier:@"main" sender:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//cellP
#pragma marck tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productList.count;
};



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CellProducts *acell = [self.tableView dequeueReusableCellWithIdentifier:@"cellP" forIndexPath:indexPath];
    [acell.lblTitle setText:self.productList[indexPath.row]];
       return acell;
    
};


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 50;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 5;
    
}




@end





