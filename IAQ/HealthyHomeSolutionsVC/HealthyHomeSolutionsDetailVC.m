//
//  HealthyHomeSolutionsDetailVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//
#import <AVKit/AVKit.h>
#import <TWRDownloadManager/TWRDownloadManager.h>
#import <AVFoundation/AVFoundation.h>

#import "HealthyHomeSolutionsDetailVC.h"
#import "HealthyAgreementTableViewCell.h"
#import "IAQDataModel.h"
#import "PictureGalleryVC.h"
#import "PDFViewControllerVC.h"
@interface HealthyHomeSolutionsDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* fileProductArray;
}
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *topBannerView;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation HealthyHomeSolutionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    self.topBannerView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    [self.circleButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    self.circleButton.layer.cornerRadius = self.circleButton.bounds.size.width/2;
    self.circleButton.clipsToBounds = true;
    
    self.topLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    NSMutableArray* selectedProductArray;
    
    if (self.iaqType == BEST) {
        [self.circleButton setTitle:@"Best" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBestProductsArray;
    }else if (self.iaqType == BETTER) {
        [self.circleButton setTitle:@"Better" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray;
    }else if (self.iaqType == GOOD) {
        [self.circleButton setTitle:@"Good" forState:UIControlStateNormal];
        selectedProductArray = [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray;
    }
    
    fileProductArray = [NSMutableArray array];
    for (IAQProductModel* iaqProduct in selectedProductArray) {
        if (iaqProduct.files.count >0) {
            [fileProductArray addObject:iaqProduct];
        }
        
    }
    
    if (fileProductArray.count == 0) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"No additional information available"];
        [self presentViewController:alert animated:true completion:nil];
    }
    [self.dataTableView reloadData];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HealthyAgreementTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"agreementcell" forIndexPath:indexPath];
    
    IAQProductModel* iaqProduct = [fileProductArray objectAtIndex:indexPath.section];
    FileModel* fileModel = [iaqProduct.files objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = fileModel.desString;
    cell.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    if ([fileModel.type isEqualToString:@"image"]) {
        cell.iconView.image = [[UIImage imageNamed:@"image"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    }else if ([fileModel.type isEqualToString:@"video"]) {
        cell.iconView.image = [[UIImage imageNamed:@"video"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    }else if ([fileModel.type isEqualToString:@"document"]) {
        cell.iconView.image = [[UIImage imageNamed:@"pdf"] imageWithColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    IAQProductModel* iaqProduct = [fileProductArray objectAtIndex:section];
    return iaqProduct.files.count;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return fileProductArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IAQProductModel* iaqProduct = [fileProductArray objectAtIndex:section];
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 1000, 60)];
    headerLabel.text = [NSString stringWithFormat:@"   %@", iaqProduct.title];
    headerLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:30]];
    return headerLabel;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IAQProductModel* iaqProduct = [fileProductArray objectAtIndex:indexPath.section];
    FileModel* fileModel = [iaqProduct.files objectAtIndex:indexPath.row];
    
    if ([fileModel.type isEqualToString:@"image"]) {
    
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
        PictureGalleryVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"PictureGalleryVC"];
        detail.pictureName = fileModel.fullUrl;
        [self.navigationController pushViewController: detail animated: YES];
        
    }else if ([fileModel.type isEqualToString:@"video"]) {
        NSURL *videoUrl;
        if ([[TWRDownloadManager sharedManager] fileExistsForUrl:fileModel.fullUrl]) {//play video from local
            videoUrl =  [NSURL fileURLWithPath:[[TWRDownloadManager sharedManager] localPathForFile:fileModel.fullUrl]];
            [self playVideoForURL:videoUrl];
        }else {//play video from url
            if ([[[DataLoader sharedInstance] reachabilityManager] isReachable]) {
                videoUrl = [NSURL URLWithString:fileModel.fullUrl];
                [self playVideoForURL:videoUrl];
                
                //download video file
                [[TWRDownloadManager sharedManager] downloadFileForURL:fileModel.fullUrl progressBlock:^(CGFloat progress) {
                     NSLog(@"progress %f video file:%@",progress, fileModel.fullUrl);
                } completionBlock:^(BOOL completed) {
                    NSLog(@"~~~completed downloading~~~");
                    
                } enableBackgroundMode:YES];
                
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
    }else if ([fileModel.type isEqualToString:@"document"]) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"IAQStoryboard" bundle:nil];
        PDFViewControllerVC * pdfViewController = [storyboard instantiateViewControllerWithIdentifier:@"PDFViewControllerVC"];
        pdfViewController.pdfUrl = fileModel.fullUrl;
        [self presentViewController: pdfViewController animated:YES completion:nil];
    }
    
}

- (void)playVideoForURL:(NSURL *)url {
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    playerController.player = [AVPlayer playerWithURL:url];
    [playerController.player play];
    [self presentViewController:playerController animated:YES completion:nil];
}

@end
