//
//  TYAlertView+HvacTek.m
//  HvacTek
//
//  Created by Max on 11/13/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "TYAlertController+HvacTek.h"
#import "HvakTekColorScheme.h"
@implementation TYAlertController (HvacTek)

+ (instancetype)showAlertWithStyle1:(NSString *)title message:(NSString *)message {
    TYAlertView* alertView = [TYAlertView alertViewWithTitle:title message:message];
    alertView.buttonDefaultBgColor = [UIColor cs_getColorWithProperty:kColorPrimary];
   
    [alertView addAction:[TYAlertAction actionWithTitle:@"OK" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
    }]];
    
    
    TYAlertController* alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle: TYAlertControllerStyleAlert];
    
    return alertController;
}
@end
