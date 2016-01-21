//
//  BaseVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@property(nonatomic, strong) UIImageView *imgTopBar;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UILabel *lbTitle;
@property(nonatomic, strong) UIView *upperArcView;
@property(nonatomic, strong) UIView *bottomArcView;

@end

@implementation BaseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:172./255 green:213./255 blue:122./255 alpha:1.];
    
    self.imgTopBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 99)];
    self.imgTopBar.image = [UIImage imageNamed:@"bg-top-bar"];
    [self.view addSubview:self.imgTopBar];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.imgTopBar.bottom + 20, self.view.width, 53)];
    [self.view addSubview:self.titleView];
    
    UIImageView *imgTitleBar = [[UIImageView alloc] initWithFrame:self.titleView.bounds];
    imgTitleBar.image = [UIImage imageNamed:@"bg-title"];
    [self.titleView addSubview:imgTitleBar];
    self.lbTitle = [[UILabel alloc] initWithFrame:self.titleView.bounds];
    self.lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:44];
    self.lbTitle.textColor = [UIColor colorWithRed:118./255 green:189./255 blue:29./255 alpha:1.];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.lbTitle];
    
    self.lbTitle.text = self.title;
    
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    CGPoint center = CGPointMake(self.view.width/2, 20);
    
    maskLayer.path = (__bridge CGPathRef _Nullable)([UIBezierPath bezierPathWithArcCenter:center radius:0.5 startAngle:20.0 endAngle:20.0 clockwise:YES]);
    
    
    self.upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 184, self.view.width, 50)];
    self.upperArcView.backgroundColor = [UIColor redColor];
 //   self.upperArcView.layer.mask = maskLayer;
    [self.view addSubview:self.upperArcView];

}



-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.lbTitle.text = title;
}



-(void)setIsTitleViewHidden:(BOOL)isTitleViewHidden
{
    self.titleView.hidden = isTitleViewHidden;
}



-(BOOL)isTitleViewHidden
{
    return self.titleView.hidden;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end