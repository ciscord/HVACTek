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

    [self configureBackgroundColor];
    [self configureLogoImage];
    [self configureTitle];
}



#pragma mark - BackgroundColors
- (void)configureBackgroundColor {
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
}



#pragma mark - Logo
- (void)configureLogoImage {
    self.imgTopBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 99)];
    
    __weak UIImageView *weakImageView = self.imgTopBar;
    [self.imgTopBar setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                          placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       UIImageView *strongImageView = weakImageView;
                                       if (!strongImageView) return;
                                       
                                       strongImageView.image = image;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       //
                                   }];
    
    [self.view addSubview:self.imgTopBar];
}



#pragma mark - Title
- (void)configureTitle{
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.imgTopBar.bottom + 20, self.view.width+2, 53)];
    [self.titleView setBackgroundColor:[UIColor cs_getColorWithProperty:kColorPrimary30]];
    self.titleView.layer.borderWidth = 1.0;
    self.titleView.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    [self.view addSubview:self.titleView];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:self.titleView.bounds];
    self.lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:44];
    self.lbTitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.lbTitle];
    
    self.lbTitle.text = self.title;
    
    /*
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    CGPoint center = CGPointMake(self.view.width/2, 20);
    
    maskLayer.path = (__bridge CGPathRef _Nullable)([UIBezierPath bezierPathWithArcCenter:center radius:0.5 startAngle:20.0 endAngle:20.0 clockwise:YES]);
    
    
    self.upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 184, self.view.width, 50)];
    self.upperArcView.backgroundColor = [UIColor redColor];
    //   self.upperArcView.layer.mask = maskLayer;
    //[self.view addSubview:self.upperArcView];
    
    */
}


#pragma mark
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



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





/*
 - (UIColor *)lighterColorForColor:(UIColor *)c
 {
 CGFloat r, g, b, a;
 if ([c getRed:&r green:&g blue:&b alpha:&a])
 return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
 green:MIN(g + 0.2, 1.0)
 blue:MIN(b + 0.2, 1.0)
 alpha:a];
 return nil;
 }
 
 - (UIColor *)darkerColorForColor:(UIColor *)c
 {
 CGFloat r, g, b, a;
 if ([c getRed:&r green:&g blue:&b alpha:&a])
 return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
 green:MAX(g - 0.2, 0.0)
 blue:MAX(b - 0.2, 0.0)
 alpha:a];
 return nil;
 }
 
 
 
 
 UIColor *baseColor = [UIColor hx_colorWithHexString:[[[DataLoader sharedInstance] currentCompany] primary_color]];
 UIColor *lighterColor = [self lighterColorForColor:baseColor];
 UIColor *darkerColor = [self darkerColorForColor:baseColor];
 
 
 self.view.backgroundColor = lighterColor;
 
 */
 




@end