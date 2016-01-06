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
@synthesize managedObjectContext;




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
    
    ///go back with new cart if entered with existent cart
    if (self.isViewingCart) {
        testerViewController * vc =(testerViewController*)self.testerVC;
        if (vc.savedCarts.count < 3) {
            [vc.cartItems removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setInteger:[vc.savedCarts count] - 1 forKey:@"workingCurrentCartIndex"];
            vc.isEditing = NO;
            [self.delegate saveCartSelected];
        }
    }
    
    
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
    acell.editButton.tag = indexPath.row;
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
            if (![nsar containsObject:itm.modelName])
                [nsar addObject:itm.modelName];
        }
        
        
    }
    
      return 230 + (50 * nsar.count);
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}


#pragma mark - CartCell Delegate
-(void)editCard:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex andMonths:(NSNumber *)monthCount {
    
     testerViewController * vc =(testerViewController*)self.testerVC;
    
    int editIndex = 0;
    if ([vc.savedCarts containsObject:cart]) {
        editIndex = [vc.savedCarts indexOfObject:cart];
        
        [vc.cartItems removeAllObjects];
        [vc.cartItems addObjectsFromArray:[cart objectForKey:@"cartItems"]];
        
        vc.months = [monthCount intValue];
        
        [[NSUserDefaults standardUserDefaults] setInteger:editIndex forKey:@"workingCurrentCartIndex"];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate editCardSelected];
    }else{
        [vc.cartItems removeAllObjects];
        [vc.cartItems addObjectsFromArray:[cart objectForKey:@"cartItems"]];
        
        vc.months = [monthCount intValue];
        
        // isEditing!
        
        if (!vc.isEditing) {
            int newIndex = [vc.savedCarts count] < 3 ? [vc.savedCarts count] : 2;
            [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:@"workingCurrentCartIndex"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
      //  [self.delegate saveCartSelected];
    }
    

};


-(void)save:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex andMonths:(NSNumber *)monthCount {
    
    testerViewController * vc =(testerViewController*)self.testerVC;
    
    
    if (self.isViewingCart) {
        
        
        if ([vc.savedCarts containsObject:cart]) {
            [[NSUserDefaults standardUserDefaults] setInteger:[vc.savedCarts count] - 1 forKey:@"workingCurrentCartIndex"];
            
            [self.delegate saveCartSelected];
        }
        
        
    }else {
        
        if (vc.isEditing) {
            
            int curIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"workingCurrentCartIndex"];
            [vc.savedCarts replaceObjectAtIndex:curIndex withObject:cart];
            
            [vc.cartItems removeAllObjects];
            
            vc.months = [monthCount intValue];
            
            if (vc.savedCarts.count < 3)
                [[NSUserDefaults standardUserDefaults] setInteger:[vc.savedCarts count] - 1 forKey:@"workingCurrentCartIndex"];
            
            [self.delegate saveCartSelected];
            
        }else{
            if (vc.savedCarts.count < 3) {
                [vc.savedCarts addObject:cart];
                [vc.cartItems removeAllObjects];
                
                vc.months = [monthCount intValue];
                
                
                int newIndex = [vc.savedCarts count] < 3 ? [vc.savedCarts count] : 2;
                [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:@"workingCurrentCartIndex"];
                
                [self.delegate saveCartSelected];
            }
        }

    }
    
    vc.isEditing = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
};


-(void)done{
    [self home];
};


@end