//
//  AgendaPictureRoundView.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "AgendaPictureRoundView.h"

@implementation AgendaPictureRoundView

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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 25;
    //self.layer.borderWidth = 1.;
    //self.layer.borderColor = [[UIColor colorWithRed:0.496 green:0.754 blue:0.224 alpha:1.000] CGColor];
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
