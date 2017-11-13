//
//  UIImage+Additions.m
//  HvacTek
//
//  Created by Max on 11/13/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "UIImage+Additions.h"


@implementation UIImage (Additions)


-(UIImage*) imageWithColor:(UIColor*) color
{
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), false);
    CGRect rect = CGRectZero;
    rect.size = [self size];
    
    // tint the image
    [self drawInRect:rect];
    [color set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeNormal);
    
    // restore alpha channel
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:CGColorGetAlpha(color.CGColor)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
