//
//  NSString+Validation.m
//  HvacTek
//
//  Created by Max on 11/13/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

-(BOOL) isValidEmail
{
    BOOL stricterFilter = NO; //
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(bool) isNumeric{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:self];
    if (number != nil) {
        return true;
    }
    return false;
}
@end
