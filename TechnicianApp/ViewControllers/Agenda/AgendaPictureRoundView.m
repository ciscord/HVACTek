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
    self.layer.masksToBounds = YES;
    
}


@end
