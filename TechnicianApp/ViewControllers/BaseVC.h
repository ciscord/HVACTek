//
//  BaseVC.h
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FrameAccessor/FrameAccessor.h>
#import "TODOMacros.h"
#import "RoundCornerView.h"
#import "DataLoader.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"
#import "HvakTekColorScheme.h"
#import "NSDate+Utilities.h"


@interface BaseVC : UIViewController
{
    IBOutletCollection(UIView) NSArray* seperatorViewArray;
    __weak IBOutlet UIButton *nextButton;
}
@property (nonatomic, assign) BOOL isTitleViewHidden;
@property(nonatomic, strong) UILabel *lbTitle;
- (NSString *)changeCurrencyFormat:(float)number;
@end
