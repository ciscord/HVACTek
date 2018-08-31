//
//  ViewOptionsVC.m
//  Signature
//
//  Created by Iurie Manea on 3/3/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ViewOptionsVC.h"
#import "ServiceOptionVC.h"
#import "PlatinumOptionsVC.h"

@interface ViewOptionsVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation ViewOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Customer's Choice";
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"  IAQ  " style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    NSString *textString = @"Based on our conversation earlier and my thorough\n evaluation of your entire system I have put together four\n different solutions for YOU to choose from.\n\n We'll discuss everything from the immediate repairs\n required to offering you a total comfort solution, but first\n I would like to start by reviewing all of my findings with you.\n Fair Enough?";
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:25];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [textString length])];
    self.titleLabel.attributedText = attrString;
    
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > ViewOptions) {
        
        PlatinumOptionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlatinumOptionsVC"];
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        
        [[TechDataModel sharedTechDataModel] saveCurrentStep:ViewOptions];
    }
    
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = ViewOptions;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  //  ServiceOptionVC *vc = [segue destinationViewController];
    if ([[segue destinationViewController] isKindOfClass:[ServiceOptionVC class]]) {
//        ServiceOptionVC *vc = [segue destinationViewController];
        [DataLoader saveOptionsDisplayType:odtReadonlyWithPrice];
        
    }
    
}

@end
