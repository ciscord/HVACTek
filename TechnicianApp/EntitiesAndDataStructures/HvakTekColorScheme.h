//
//  HvakTekColorScheme.h
//  HvacTek
//
//  Created by Dorin on 1/23/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#define HvTekColor UIColor
#else
#import <Cocoa/Cocoa.h>
#define HvTekColor NSColor
#endif

#import <UIKit/UIKit.h>
#import "HexColors.h"
#import "HvacTekConstants.h"
#import "DataLoader.h"

@interface HvTekColor (HvTekColorAddition)

+ (nullable UIColor *)cs_getColorWithProperty:(float)percent;

@end
