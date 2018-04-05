//
//  PictureLibraryVC.m
//  HvacTek
//
//  Created by dora's Mac on 6/29/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "MediaLibraryVC.h"
#import "VideoLibraryCell.h"
#import "CompanyAditionalInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PictureGalleryVC.h"
#import "PDFViewController1VC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <TWRDownloadManager/TWRDownloadManager.h>
@interface MediaLibraryVC ()

@property (weak, nonatomic) IBOutlet UITableView *pictureTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSArray *mediaArray;

@end

@implementation MediaLibraryVC

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
    self.title = @"Library";
    [self.pictureTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (CompanyAditionalInfo *companyObject in [[DataLoader sharedInstance] companyAdditionalInfo]) {
        [infoArray addObject:companyObject];
    }
    self.mediaArray = infoArray.mutableCopy;
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
    return self.mediaArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyAditionalInfo * selectedItem = self.mediaArray[indexPath.row];
    
    VideoLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.titleLabel.text = selectedItem.info_title;
    cell.descriptionLabel.text = selectedItem.info_description;
    //cell.coverImage.image = [UIImage imageNamed:@"pictureGallery_placeholder"];
    
    if (selectedItem.isVideo) {
        NSURL *videoUrl;
        if ([[TWRDownloadManager sharedManager] fileExistsForUrl:selectedItem.info_url]) {
            videoUrl =  [NSURL fileURLWithPath:[[TWRDownloadManager sharedManager] localPathForFile:selectedItem.info_url]];
            cell.coverImage.image =  [UIImage imageWithCGImage:[self getVideThumbnailAtUrl:videoUrl]];
            
        }else {
            //        if ([[[DataLoader sharedInstance] reachabilityManager] isReachable]) {
            //            cell.coverImage.image = [UIImage imageNamed:@"video-thumbnail"];
            //            videoUrl = [NSURL URLWithString:selectedItem.info_url];
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                UIImage *image = [UIImage imageWithCGImage:[self getVideThumbnailAtUrl:videoUrl]];
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    cell.coverImage.image = image;
            //                });
            //            });
            //        }else{
            //            cell.coverImage.image = [UIImage imageNamed:@"video-thumbnail"];
            //        }
            cell.coverImage.image = [UIImage imageNamed:@"video-thumbnail"];
        }
        
        [[TWRDownloadManager sharedManager] isFileDownloadingForUrl:selectedItem.info_url withProgressBlock:^(CGFloat progress) {
            cell.titleLabel.text = @"Video Downloading...";
            cell.descriptionLabel.text = @"";
            cell.coverImage.image = [UIImage imageNamed:@"video-thumbnail"];
        } completionBlock:^(BOOL completed) {
            [self.pictureTableView beginUpdates];
            [self.pictureTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.pictureTableView endUpdates];
        }];
    }else if (selectedItem.isPicture) {
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:selectedItem.info_url]
                           placeholderImage:[UIImage imageNamed:@"pictureGallery_placeholder"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      //
                                  }];
    }else {
        cell.coverImage.image = [[UIImage imageNamed:@"pdf"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyAditionalInfo * selectedItem = self.mediaArray[indexPath.row];
    
    if (selectedItem.isVideo) {
        NSURL *videoUrl;
        if ([[TWRDownloadManager sharedManager] fileExistsForUrl:selectedItem.info_url]) {
            videoUrl =  [NSURL fileURLWithPath:[[TWRDownloadManager sharedManager] localPathForFile:selectedItem.info_url]];
            [self playVideoForURL:videoUrl];
        }else {
            if ([[[DataLoader sharedInstance] reachabilityManager] isReachable]) {
                videoUrl = [NSURL URLWithString:selectedItem.info_url];
                [self playVideoForURL:videoUrl];
                NSLog(@"isReachable");
            }else{
                UIAlertController *alert= [UIAlertController alertControllerWithTitle: @"Oops! Something went wrong."
                                                                              message: @"Video wasn't downloaded to the app and there isn't internet connection available right now."
                                                                       preferredStyle: UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                           }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                NSLog(@"is Not Reachable");
            }
        }
    }else if (selectedItem.isPicture) {
        UIStoryboard * storyboard = self.storyboard;
        PictureGalleryVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"PictureGalleryVC"];
        detail.pictureName = selectedItem.info_url;
        [self.navigationController pushViewController: detail animated: YES];
    }else {
        UIStoryboard * storyboard = self.storyboard;
        PDFViewController1VC * pdfViewController = [storyboard instantiateViewControllerWithIdentifier:@"PDFViewController1VC"];
        pdfViewController.pdfUrl = selectedItem.info_url;
        [self.navigationController pushViewController: pdfViewController animated: YES];
    }
    
}

- (void)playVideoWithId:(NSString *)videoId {
    
    NSURL *websiteUrl = [NSURL URLWithString:videoId];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];
}

- (CGImageRef)getVideThumbnailAtUrl:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    return  refImg;
}

- (void)playVideoForURL:(NSURL *)url {
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    playerController.player = [AVPlayer playerWithURL:url];
    [playerController.player play];
    [self presentViewController:playerController animated:YES completion:nil];
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
