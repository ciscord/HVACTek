//
//  CartViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"

@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate, CartCellDelegate>

@property (strong, nonatomic) NSMutableArray *productList;

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
    [self configureVC];
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    [self.btnEmail setHidden:YES];

}

-(void)configureVC{
    [self.cartstableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"CartCell"];
     self.cartstableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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



#pragma mark - Tableview Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carts.count;
};



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartCell *acell = [self.cartstableView dequeueReusableCellWithIdentifier:@"CartCell"];
    acell.delegate = self;
    acell.cart = self.carts[indexPath.row];
    acell.lblCartNumber.text = [NSString stringWithFormat:@"Your Cart %li",(long)indexPath.row +1 ];
    [acell updateProductList];
       return acell;
};


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary * ar = self.carts[indexPath.row];
    NSMutableArray * crti = [ar objectForKey:@"cartItems"];
    NSMutableArray * nsar  = [[NSMutableArray alloc]init];
    
    for (int x = 0; x < crti.count; x++){
        Item *itm = crti[x];
        
        if ( [itm.type isEqualToString:@"TypeOne"] || [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"] ) {
            // do nothing
            
        } else {
            [nsar addObject:itm.modelName];
        }
        
        
    }
    
      return 230 + (50 * nsar.count);
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}

#pragma marck cart cell delegate
-(void)editCard:(NSMutableDictionary*)cart{
//     testerViewController * vc =(testerViewController*)self.testerVC;
//     vc.cartItems = [cart objectForKey:@"cartItems"];
     [self.navigationController popViewControllerAnimated:YES];
};
-(void)save:(NSMutableDictionary*)cart{
    
    testerViewController * vc =(testerViewController*)self.testerVC;
    if (vc.savedCarts.count < 3) {
        [vc.savedCarts addObject:cart];
    }
    [self.navigationController popViewControllerAnimated:YES]; 
    
};
-(void)done{
    [self home];
};


@end


