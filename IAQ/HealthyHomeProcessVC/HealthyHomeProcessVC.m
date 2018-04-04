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
#import "AppDelegate.h"
@interface HealthyHomeProcessVC ()<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic) IBOutlet UILabel *technicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *technicalDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerDetailLabel;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HealthyHomeProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Healthy Home Process";
    // Do any additional setup after loading the view.
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    [self configureColorScheme];
    
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQHealthyHomeProcess) {
        [self loadIAQFromCoredata];
    }
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    
    [[DataLoader sharedInstance] getIAQProducts: ^(NSString *successMessage, NSDictionary *reciveData) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               
                                               //online: delete previous data and add new data
                                               [self deleteAllEntities:@"IAQProductModel"];
                                               AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                                               NSManagedObjectContext* backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                                               [backgroundMOC setUndoManager:nil];
                                               [backgroundMOC setParentContext:appDelegate.managedObjectContext];
                                               
                                               NSArray* receiveDataArray = (NSArray*) reciveData;
                                               
                                               for (NSDictionary* product in receiveDataArray) {
                                                   
                                                   IAQProductModel* iaqProduct = [NSEntityDescription insertNewObjectForEntityForName:@"IAQProductModel" inManagedObjectContext:backgroundMOC];
                                                   
                                                   iaqProduct.quantity = @"0";
                                                   iaqProduct.businessId = [product objectForKey:@"businessid"];
                                                   iaqProduct.createdAt = [product objectForKey:@"created_at"];
                                                   iaqProduct.createdBy = [product objectForKey:@"created_by"];
                                                   iaqProduct.productId = [product objectForKey:@"id"];
                                                   iaqProduct.ord = [[product objectForKey:@"ord"] intValue];
                                                   iaqProduct.price = [product objectForKey:@"price"];
                                                   iaqProduct.title = [product objectForKey:@"title"];
                                                   
                                                   iaqProduct.files = [NSMutableArray array];
                                                   NSArray* fileArray = [product objectForKey:@"files"];
                                                   
                                                   for (NSDictionary* filedata in fileArray) {
                                                       FileModel* iaqFile = [[FileModel alloc]init];
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
                                                   
                                               }
                                               NSError *error;
                                               if (![backgroundMOC save:&error]) {
                                                   NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                                               }
                                               
                                               [appDelegate.managedObjectContext save:&error];
                                               
                                               //load data from coredata
                                               [self loadIAQFromCoredata];
                                               
                                           }onError:^(NSError *error) {
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               //offline load data
                                               [self loadIAQFromCoredata];
                                           }];
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    // if you've already made a fetch request, return the results
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IAQProductModel" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    // sort by id
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ord" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    
    NSError *error;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [appDelegate.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [appDelegate.managedObjectContext save:&error];
}

-(void) loadIAQFromCoredata {
    [IAQDataModel sharedIAQDataModel].iaqProductsArray = [NSMutableArray array];
    for (IAQProductModel* iaqProduct in self.fetchedResultsController.fetchedObjects) {
        [[IAQDataModel sharedIAQDataModel].iaqProductsArray addObject: iaqProduct];
    }
    
    HeatingStaticPressureVC* heatingStaticPressureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HeatingStaticPressureVC"];
    [self.navigationController pushViewController:heatingStaticPressureVC animated:true];
    _fetchedResultsController = nil;
    
    if ([IAQDataModel sharedIAQDataModel].currentStep == IAQNone) {
        [[IAQDataModel sharedIAQDataModel] resetAllData];
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:[NSNumber numberWithInteger:IAQHeatingStaticPressure]  forKey:@"iaqCurrentStep"];
        [userdefault synchronize];
    }
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
