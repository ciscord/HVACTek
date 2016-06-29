//
//  PictureGalleryVC.m
//  HvacTek
//
//  Created by dora's Mac on 6/29/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "PictureGalleryVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PictureGalleryVC ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@end

@implementation PictureGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:self.pictureName]
                       placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  //
                              }];
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

@end
