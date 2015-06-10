//
//  CartViewController.h
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Item.h"

@interface CartViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    NSArray *headers;
    int months;
    float perc;
    NSMutableString *products;
    
}

@property (weak, nonatomic) IBOutlet UILabel *yourOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterSavingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *finance;
@property (weak, nonatomic) IBOutlet UILabel *monthlypayment;

@property (weak, nonatomic) IBOutlet UITextView *productsView;
@property (nonatomic, strong) NSArray *cartItems;
@property (nonatomic) int months;
@property (nonatomic, strong) NSArray *rebates;
- (IBAction)email:(id)sender;
- (IBAction)mainMenu:(id)sender;

@end
