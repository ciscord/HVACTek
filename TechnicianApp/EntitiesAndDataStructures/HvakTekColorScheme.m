//
//  HvakTekColorScheme.m
//  HvacTek
//
//  Created by Dorin on 1/23/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "HvakTekColorScheme.h"

@implementation HvTekColor (HvTekColorAddition)


+ (UIColor *)cs_getColorWithProperty:(float)percent {
    NSString *hexColor;
    
    if (percent == kColorPrimary || percent == kColorPrimary0 || percent == kColorPrimary20 || percent == kColorPrimary30 || percent == kColorPrimary50) {
        hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
    }else {
        hexColor = [[[DataLoader sharedInstance] currentCompany] secondary_color];
    }
    
    hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
    UIColor *color = [UIColor hx_colorWithHexString:hexColor];
    
    return [[self class] lighterColorForColor:color withPercent:percent];
}


+ (UIColor *)lighterColorForColor:(UIColor *)c withPercent:(float)percent
{
    CGFloat redValue, greenValue, blueValue, alphaValue, rgbMax;
    rgbMax = 255.0;
    
    if ([c getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue]){
        
        CGFloat redValueNew, greenValueNew, blueValueNew;
        redValueNew     = (percent * (rgbMax - redValue * rgbMax) + redValue * rgbMax);
        greenValueNew   = (percent * (rgbMax - greenValue * rgbMax) + greenValue * rgbMax);
        blueValueNew    = (percent * (rgbMax - blueValue * rgbMax) + blueValue * rgbMax);
        
        return [UIColor colorWithRed:redValueNew    / rgbMax
                               green:greenValueNew  / rgbMax
                                blue:blueValueNew   / rgbMax
                               alpha:alphaValue];
    }
    return [UIColor yellowColor];
}


@end
