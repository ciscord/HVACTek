//
//  RepairVsServiceVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/11/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "RepairVsServiceVC.h"

@interface RepairVsServiceVC ()

@end

@implementation RepairVsServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TechDataModel sharedTechDataModel] saveCurrentStep:RepairVsService];
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
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

@end
