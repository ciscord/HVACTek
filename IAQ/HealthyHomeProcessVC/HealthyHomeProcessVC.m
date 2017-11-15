//
//  HealthyHomeProcessVC.m
//  HvacTek
//
//  Created by Max on 11/8/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeProcessVC.h"
#import "DataLoader.h"
#import "HeatingStaticPressureVC.h"
#import "IAQDataModel.h"
@interface HealthyHomeProcessVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UILabel *technicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerDetailLabel;


@end
#define kAdd2CartURL [NSURL URLWithString:@""]
@implementation HealthyHomeProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureColorScheme];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {

    self.layer1View.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    
    self.technicalLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.customerLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.technicalDetailLabel.textColor = [UIColor blackColor];
    self.customerDetailLabel.textColor = [UIColor blackColor];
    
}
- (IBAction)nextButtonClick:(id)sender {
    
    [[DataLoader sharedInstance] getIAQProducts:kAdd2CartURL
                                           onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                               NSArray* receiveDataArray = (NSArray*) reciveData;
                                               
                                               for (NSDictionary* product in receiveDataArray) {
                                                   IAQProductModel* iaqProduct = [[IAQProductModel alloc] init];
                                                   iaqProduct.quantity = @"0";
                                                   iaqProduct.businessId = [product objectForKey:@"businessid"];
                                                   iaqProduct.createdAt = [product objectForKey:@"created_at"];
                                                   iaqProduct.createdBy = [product objectForKey:@"created_by"];
                                                   iaqProduct.productId = [product objectForKey:@"id"];
                                                   iaqProduct.ord = [product objectForKey:@"ord"];
                                                   iaqProduct.price = [product objectForKey:@"price"];
                                                   iaqProduct.title = [product objectForKey:@"title"];
                                                   
                                                   iaqProduct.files = [NSMutableArray array];
                                                   NSArray* fileArray = [product objectForKey:@"files"];
                                                   
                                                   for (NSDictionary* filedata in fileArray) {
                                                       FileModel* iaqFile = [[FileModel alloc] init];
                                                       iaqFile.createAt = [filedata objectForKey:@"created_at"];
                                                       iaqFile.desString = [filedata objectForKey:@"description"];
                                                       iaqFile.filename = [filedata objectForKey:@"filename"];
                                                       iaqFile.fullUrl = [filedata objectForKey:@"full_url"];
                                                       iaqFile.iqaId = [filedata objectForKey:@"iaq_id"];
                                                       iaqFile.iqaId = [filedata objectForKey:@"id"];
                                                       iaqFile.ord = [filedata objectForKey:@"ord"];
                                                       iaqFile.type = [filedata objectForKey:@"type"];
                                                       [iaqProduct.files addObject:iaqFile];
                                                   }
                                                   [[IAQDataModel sharedIAQDataModel].iaqProductsArray addObject: iaqProduct];
                                               }
                                               
                                               HeatingStaticPressureVC* heatingStaticPressureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HeatingStaticPressureVC"];
                                               [self.navigationController pushViewController:heatingStaticPressureVC animated:true];
                                           }onError:^(NSError *error) {
                                               ShowOkAlertWithTitle(error.localizedDescription, self);
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
