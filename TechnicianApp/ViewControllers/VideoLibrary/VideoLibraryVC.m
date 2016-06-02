//
//  VideoLibraryVC.m
//  HvacTek
//
//  Created by Dorin on 6/1/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "VideoLibraryVC.h"
#import "VideoLibraryCell.h"
#import "AVPlayerVC.h"

@interface VideoLibraryVC ()

@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSArray *videosArray;

@end

@implementation VideoLibraryVC

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
    self.title = @"Video Library";
    [self.videoTableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
}


#pragma mark - Button Actions
- (IBAction)backClicked:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    
//    AVPlayerVC *vc = [[AVPlayerVC alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hvactek.com/uploads/additional/HVAC_Service_West_Chester_PA___Signature_HVAC___610.400.10631.mp4"]];
    [self playVideoWithId:@"asd"];
}




- (void)playVideoWithId:(NSString *)videoId {
    
    NSURL *websiteUrl = [NSURL URLWithString:@"http://www.hvactek.com/uploads/additional/HVAC_Service_West_Chester_PA___Signature_HVAC___610.400.10631.mp4"];
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


#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;//self.videosArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    //cell.titleLabel.text = [self.videosArray objectAtIndex:indexPath.row][@"title"];
    //cell.descriptionLabel.text = [self.videosArray objectAtIndex:indexPath.row][@"description"];
    
    return cell;
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
