//
//  PictureLibraryVC.m
//  HvacTek
//
//  Created by dora's Mac on 6/29/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "PictureLibraryVC.h"
#import "VideoLibraryCell.h"
#import "CompanyAditionalInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PictureGalleryVC.h"

@interface PictureLibraryVC ()

@property (weak, nonatomic) IBOutlet UITableView *pictureTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSArray *picturesArray;

@end

@implementation PictureLibraryVC

static NSString *kCELL_IDENTIFIER = @"VideoLibraryCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureColorScheme];
    [self configureVC];
}


#pragma mark - Configure VC
- (void)configureColorScheme {
    self.backButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


-(void)configureVC {
    self.title = @"Picture Library";
    [self.pictureTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        if (companyObject.isPicture) {
            [infoArray addObject:companyObject];
        }
    }
    self.picturesArray = infoArray.mutableCopy;
}


#pragma mark - Button Actions
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.picturesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyAditionalInfo * selectedItem = self.picturesArray[indexPath.row];
    
    VideoLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.titleLabel.text = selectedItem.info_title;
    cell.descriptionLabel.text = selectedItem.info_description;
    //cell.coverImage.image = [UIImage imageNamed:@"pictureGallery_placeholder"];
    
    
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:selectedItem.info_url]
                      placeholderImage:[UIImage imageNamed:@"pictureGallery_placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 //
                             }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyAditionalInfo * selectedItem = self.picturesArray[indexPath.row];
    
    UIStoryboard * storyboard = self.storyboard;
    PictureGalleryVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"PictureGalleryVC"];
    detail.pictureName = selectedItem.info_url;
    [self.navigationController pushViewController: detail animated: YES];
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
