//
//  PriceBookTableViewCell.m
//  Signature
//
//  Created by Andrei Zaharia on 12/11/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "PriceBookView.h"

@implementation PriceBookView

- (IBAction)touchCell:(id)sender {
    
    if(self.onSelect)
    {
        self.onSelect(self);
    }
}

@end
