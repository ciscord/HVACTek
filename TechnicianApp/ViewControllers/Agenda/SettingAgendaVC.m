//
//  SettingAgendaVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "SettingAgendaVC.h"
#import "AgendaPictureVC.h"

@interface SettingAgendaVC ()



@end

@implementation SettingAgendaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Setting The Agenda", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)choiseBtnClicked:(id)sender {
    UIButton *button = sender;
    
    if (!button.selected)
        button.selected = YES;
    else
        button.selected = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goSettingAgenda"]) {
        AgendaPictureVC *vc = segue.destinationViewController;
        vc.choosedType = self.choosenType;
    }
}


@end
