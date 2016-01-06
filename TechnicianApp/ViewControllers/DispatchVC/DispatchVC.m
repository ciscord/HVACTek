//
//  DispatchVC.m
//  Signature
//
//  Created by Iurie Manea on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "DispatchVC.h"
#import <SFRoundProgressCounterView/SFRoundProgressCounterView.h>
#import "SFCounterLabel+SignatureFormat.h"
#import "UIImageView+AFNetworking.h"

@interface DispatchVC () <SFRoundProgressCounterViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgInspiration;
@property (weak, nonatomic) IBOutlet UILabel *lbInspirationSentence;
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *vwCounter;

@property (weak, nonatomic) IBOutlet UILabel *lbCustomerInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtClientProblems;
@property (weak, nonatomic) IBOutlet UIView *vwInspiration;
@property (strong, nonatomic) UIViewController *customerOverviewVC;

@end

@implementation DispatchVC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.isTitleViewHidden = YES;

	self.vwCounter.delegate = self;
	NSNumber *interval = [NSNumber numberWithLong:5000.0];
	self.vwCounter.intervals = @[interval];
	self.vwCounter.outerProgressColor = [UIColor colorWithRed:76. / 255. green:67. / 255. blue:45. / 255. alpha:1.];
	self.vwCounter.outerTrackColor = [UIColor colorWithRed:187. / 255. green:178. / 255. blue:174. / 255. alpha:1.];
	self.vwCounter.innerCircleView.backgroundColor = self.view.backgroundColor;
	self.vwCounter.outerCircleView.backgroundColor = [UIColor clearColor];
	self.vwCounter.hideFraction = YES;
	self.vwInspiration.backgroundColor = self.view.backgroundColor;
	[self.imgInspiration setImageWithURL:[NSURL URLWithString:[[DataLoader sharedInstance] inspirationImagePath]] placeholderImage:nil];

	[self setInspirationText:[[DataLoader sharedInstance] inspirationSentence]];
}

- (void)setInspirationText:(NSString *)text {
	UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:77];

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.alignment = NSTextAlignmentCenter;

//	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
//	[string addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor],
//	                         NSFontAttributeName : font,
//	                         NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-2.0],
//	                         NSStrokeColorAttributeName : [UIColor whiteColor],
//	                         NSParagraphStyleAttributeName : paragraphStyle }
//	                range:NSMakeRange(0, [text length])];

//	self.lbInspirationSentence.attributedText = string;
    self.lbInspirationSentence.text = @"";
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];

    NSDictionary *jobInfo = job.swapiJobInfo;
    NSDictionary *customerInfo = job.swapiCustomerInfo;
    
    self.lbCustomerInfo.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@ %@", [customerInfo objectForKeyNotNull:@"FirstName"], [customerInfo objectForKeyNotNull:@"LastName"], [customerInfo objectForKeyNotNull:@"Address1"],
                                [customerInfo objectForKeyNotNull:@"City"], [customerInfo objectForKeyNotNull:@"State"], [customerInfo objectForKeyNotNull:@"Zip"]];
    self.txtClientProblems.text = [[jobInfo objectForKeyNotNull:@"Instructions"] stringByReplacingOccurrencesOfString:@">" withString:@""];
}

- (void)viewWillAppear:(BOOL)animated {
	self.vwInspiration.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */
- (IBAction)btnBeginTouch:(id)sender {

    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (!job.dispatchTime) {
        job.dispatchTime = [NSDate date];
        [job.managedObjectContext save];
    }

    [self performSelector:@selector(prepareCustomerOverview) withObject:nil afterDelay:1];

	self.vwInspiration.hidden = NO;
	[self.vwCounter start];
}

-(void)prepareCustomerOverview {
    self.customerOverviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerOverviewVC"];
}

#pragma mark = SFRoundProgressTimerViewDelegate
- (void)countdownDidEnd:(SFRoundProgressCounterView *)progressTimerView {
	[self.navigationController pushViewController:self.customerOverviewVC animated:YES];
}

@end
