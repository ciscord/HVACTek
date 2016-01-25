//
//  RoundCornerView.m
//  Signature
//
//  Created by Iurie Manea on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "RoundCornerView.h"

@implementation RoundCornerView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    self.layer.cornerRadius = 12;
    //self.layer.borderWidth = 1.;
    //self.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    self.layer.masksToBounds = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
