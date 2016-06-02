

#import "AVPlayerVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface AVPlayerVC ()

@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;

@end

@implementation AVPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = self.view;
    
    NSString *resourceName = @"http://www.hvactek.com/uploads/additional/HVAC_Service_West_Chester_PA___Signature_HVAC___610.400.10631.mp4";
    
//    NSString* movieFilePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
//    NSAssert(movieFilePath, @"movieFilePath is nil");
    
    NSURL *fileURL = [NSURL URLWithString:resourceName];
   //NSURL *fileURL = [NSURL fileURLWithPath:resourceName]; //movieFilePath
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    
    playerViewController.player = [AVPlayer playerWithURL:fileURL];
    
    self.avPlayerViewcontroller = playerViewController;
    
    [self resizePlayerToViewSize];
    
    [view addSubview:playerViewController.view];
 
    view.autoresizesSubviews = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) resizePlayerToViewSize
{
    CGRect frame = self.view.frame;
    
    NSLog(@"frame size %d, %d", (int)frame.size.width, (int)frame.size.height);
    
    self.avPlayerViewcontroller.view.frame = frame;
}

@end
