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

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:172./255 green:213./255 blue:122./255 alpha:1.];
    
    self.imgTopBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 99)];
    self.imgTopBar.image = [UIImage imageNamed:@"bg-top-bar"];
//    self.imgTopBar.frame = CGRectMake(0, 0, self.view.width, 148);
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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



@end
