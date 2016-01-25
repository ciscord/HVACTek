//
//  HvakTekColorScheme.m
//  HvacTek
//
//  Created by Dorin on 1/23/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "HvakTekColorScheme.h"

@implementation HvTekColor (HvTekColorAddition)


+ (UIColor *)cs_getColorWithProperty:(csColors)percent {
    NSString *hexColor;
    float currentPercent = 0;
    
    switch (percent) {
        case kColorPrimary:
            hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
            currentPercent = qColorPrimary;
            break;
        case kColorPrimary0:
            hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
            currentPercent = qColorPrimary0;
            break;
        case kColorPrimary20:
            hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
            currentPercent = qColorPrimary20;
            break;
        case kColorPrimary30:
            hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
            currentPercent = qColorPrimary30;
            break;
        case kColorPrimary50:
            hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
            currentPercent = qColorPrimary50;
            break;
        case kColorSecondary:
            hexColor = [[[DataLoader sharedInstance] currentCompany] secondary_color];
            currentPercent = qColorSecondary;
            break;
        case kColorSecondary0:
            hexColor = [[[DataLoader sharedInstance] currentCompany] secondary_color];
            currentPercent = qColorSecondary0;
            break;
        case kColorSecondary10:
            hexColor = [[[DataLoader sharedInstance] currentCompany] secondary_color];
            currentPercent = qColorSecondary10;
            break;
            
        default:
            break;
    }
    
//    if (percent == kColorPrimary || percent == kColorPrimary0 || percent == kColorPrimary20 || percent == kColorPrimary30 || percent == kColorPrimary50) {
//        hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
//    }else if (percent == kColorSecondary || percent == kColorSecondary0 || percent == kColorSecondary10) {
//        hexColor = [[[DataLoader sharedInstance] currentCompany] secondary_color];
//    }
    
   // hexColor = [[[DataLoader sharedInstance] currentCompany] primary_color];
    UIColor *color = [UIColor hx_colorWithHexString:hexColor];
    
    return [[self class] lighterColorForColor:color withPercent:currentPercent];
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
    return [UIColor colorWithRed:104/255.0 green:144/255.0 blue:201/255.0 alpha:1.0];
}


@end
