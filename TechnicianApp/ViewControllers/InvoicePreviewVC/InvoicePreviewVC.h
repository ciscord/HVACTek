//
//  InvoicePreviewVC.h
//  HvacTek
//
//  Created by Dorin on 5/18/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoader.h"
#import "HvakTekColorScheme.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"

@interface InvoicePreviewVC : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *previewHtmlString;
@property (nonatomic, strong) NSDictionary *invoiceDictionary;
@property (readwrite) BOOL isAutoLoad;
@end
