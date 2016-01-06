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

@end

@implementation ViewOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Customer's Choice";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  //  ServiceOptionVC *vc = [segue destinationViewController];
    if ([[segue destinationViewController] isKindOfClass:[ServiceOptionVC class]]) {
        ServiceOptionVC *vc = [segue destinationViewController];
        vc.optionsDisplayType = odtReadonlyWithPrice;
        vc.priceBookAndServiceOptions = self.priceBookAndServiceOptions;
    }
    
    if ([[segue destinationViewController] isKindOfClass:[PlatinumOptionsVC class]]) {
        
        PlatinumOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.priceBookAndServiceOptions;
    }

}

@end
