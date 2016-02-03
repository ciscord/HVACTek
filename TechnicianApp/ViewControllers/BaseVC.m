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
@property(nonatomic, strong) UIView *logoView;
@property(nonatomic, strong) UILabel *lbTitle;
@property(nonatomic, strong) UIView *upperArcView;
@property(nonatomic, strong) UIView *bottomArcView;

@end

@implementation BaseVC

/*
 
 [self configureColorScheme];
 
 #pragma mark - Color Scheme
 - (void)configureColorScheme {
 self.ButtonView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
 self.label.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
 }
 
 
 */



- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundColor];
    [self configureLogoImage];
    [self configureTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



#pragma mark - BackgroundColors
- (void)configureBackgroundColor {
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
}



#pragma mark - Logo
- (void)configureLogoImage {
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    [self.logoView setBackgroundColor:[UIColor cs_getColorWithProperty:kColorSecondary0]];
    [self.view addSubview:self.logoView];
    
    self.imgTopBar = [[UIImageView alloc] initWithFrame:CGRectMake(159, 64, 450, 100)];
    self.imgTopBar.contentMode = UIViewContentModeScaleAspectFit;
    
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
    
    
    /// arch Views
    [self configureUpperView];
    [self configureBottomView];
}


- (void)configureUpperView {
    CGFloat round = 20;
    self.upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 164, self.view.width, 20)];
    self.upperArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = self.upperArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x,startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.upperArcView.bounds;
    layer.path = aPath.CGPath;
    self.upperArcView.layer.mask = layer;
    
    [self.view addSubview:self.upperArcView];
}


- (void)configureBottomView {
    CGFloat round = 20;
    self.bottomArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 1004, self.view.width, 20)];
    self.bottomArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.bottomArcView.layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = self.bottomArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x, startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bottomArcView.bounds;
    layer.path = aPath.CGPath;
    self.bottomArcView.layer.mask = layer;
    
    
    [self.view addSubview:self.bottomArcView];
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