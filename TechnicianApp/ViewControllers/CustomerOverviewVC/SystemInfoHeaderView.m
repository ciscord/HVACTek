//
//  SystemInfoHeaderView.m
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "SystemInfoHeaderView.h"

@interface SystemInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIButton *btnCollapse;

@end

@implementation SystemInfoHeaderView

-(void) setCollapsed:(BOOL)collapsed
{
    _collapsed = collapsed;
    
    NSString *imageName = collapsed ? @"customer-overview-arrow-colapsed" : @"customer-overview-arrow-expanded";
    [self.btnCollapse setImage:[UIImage imageNamed: imageName] forState: UIControlStateNormal];
}

- (IBAction)didTapStateToggleBtn:(id)sender {
    self.collapsed = !self.collapsed;
    
    if (self.onToggle) {
        self.onToggle(self);
    }
}

@end
