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
    self.backgroundColor = [UIColor colorWithRed:239./255. green:246./255. blue:226./255. alpha:1.];
    self.layer.cornerRadius = 12;
    self.layer.borderWidth = 1.;
    self.layer.borderColor = [[UIColor colorWithRed:0.496 green:0.754 blue:0.224 alpha:1.000] CGColor];
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
