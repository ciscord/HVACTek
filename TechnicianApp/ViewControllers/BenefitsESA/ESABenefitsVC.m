//
//  ESABenefitsVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ESABenefitsVC.h"
#import "ViewOptionsVC.h"

@interface ESABenefitsVC ()

@end

@implementation ESABenefitsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"ESA Program Benefits", nil);
    
    self.discountLabel.numberOfLines = 0;
    self.discountLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.discountView.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[ViewOptionsVC class]]) {
        
        ViewOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.serviceOptionsPriceBook;
    }
}

@end
