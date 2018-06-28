//
//  ServiceOptionsVC.m
//  HvacTek
//
//  Created by Max on 11/11/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsVC.h"
#import "CHDropDownTextField.h"
#import "CHDropDownTextFieldTableViewCell.h"
#import "ServiceOptionViewCell.h"
#import "IAQDataModel.h"
#import "HealthyHomeSolutionsSortVC.h"
#import "IAQCustomerChoiceVC.h"
#import "TechnicianHomeVC.h"
#import "AppDelegate.h"
#import "TechDataModel.h"
#import "QuestionsVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "ServiceOptionVC.h"
#import "SummaryOfFindingVC.h"
@interface HealthyHomeSolutionsVC ()<UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{
    
    
}
@property (weak, nonatomic)     IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic)   IBOutlet UILabel* titleLabel;
@property (weak, nonatomic)     IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
static NSString *kCellIdentifier = @"ServiceOptionViewCell";
@implementation HealthyHomeSolutionsVC
@synthesize checkedProducts;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    [self.titleLabel setTextColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    [self.collectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //load
    if ([IAQDataModel sharedIAQDataModel].currentStep > IAQHealthyHomeSolution) {
        [self loadIAQFromCoredata];
        [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray = [NSMutableArray array];
        
        NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
        
        [IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray = [userdefault objectForKey:@"iaqSortedProductsIdArray"];
        [IAQDataModel sharedIAQDataModel].iaqSortedProductsQuantityArray = [userdefault objectForKey:@"iaqSortedProductsQuantityArray"];
        
        checkedProducts = [NSMutableArray array];
        
        for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
            if ([[IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray containsObject:iaqModel.productId]) {
                iaqModel.quantity = [[IAQDataModel sharedIAQDataModel].iaqSortedProductsQuantityArray objectAtIndex:[[IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray indexOfObject:iaqModel.productId]];
                [[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray addObject:iaqModel];
                [checkedProducts addObject:@"1"];
            }else {
                [checkedProducts addObject:@"0"];
            }
        }
       
        SummaryOfFindingVC* summaryOfFindingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingVC"];
        [self.navigationController pushViewController:summaryOfFindingVC animated:true];
        
    }else {
        [self downloadIAQProducts];
        
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [IAQDataModel sharedIAQDataModel].iaqProductsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2 - 40, 70);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = indexPath.item;
    IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
    
    ServiceOptionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.btnCheckbox.hidden = false;
    cell.lbValue.text = item.title;
    cell.qtyTextField.text    = item.quantity;
    cell.qtyTextField.tag = itemIndex;
    cell.tag = itemIndex;
    cell.parentViewController = self;
   
    NSString* checkedState = [checkedProducts objectAtIndex:indexPath.item];
    if ([checkedState isEqualToString:@"1"]) {
        cell.btnCheckbox.selected = true;
    }else{
        cell.btnCheckbox.selected = false;
    }
    
    [cell setOnCheckboxToggle:^(BOOL selected){
        [checkedProducts removeObjectAtIndex:itemIndex];
        if (selected) {
            [checkedProducts insertObject:@"1" atIndex:itemIndex];
            if ([item.quantity isEqualToString:@"0"]) {
                item.quantity = @"1";
                
                [collectionView reloadData];
            }
            
        }else {
            [checkedProducts insertObject:@"0" atIndex:itemIndex];
           
            item.quantity = @"0";
            
            [collectionView reloadData];
            
        }
        
    }];
    return cell;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - button event
-(IBAction)nextButtonClick:(id)sender {

    [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray = [NSMutableArray array];
    [IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray = [NSMutableArray array];
    [IAQDataModel sharedIAQDataModel].iaqSortedProductsQuantityArray = [NSMutableArray array];
    
    for (int i = 0; i <  [IAQDataModel sharedIAQDataModel].iaqProductsArray.count; i++) {
        IAQProductModel * iaqModel  = [[IAQDataModel sharedIAQDataModel].iaqProductsArray objectAtIndex:i];
        if ([iaqModel.quantity intValue] > 0 && [[checkedProducts objectAtIndex:i] isEqualToString:@"1"]) {
            [[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray addObject:iaqModel];
            [[IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray addObject:iaqModel.productId];
            [[IAQDataModel sharedIAQDataModel].iaqSortedProductsQuantityArray addObject:iaqModel.quantity];
            
        }
    }
    
    if ([IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count == 0) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Please input quantity"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    [IAQDataModel sharedIAQDataModel].isfinal = false;
    
    //reset auto load
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:[IAQDataModel sharedIAQDataModel].iaqSortedProductsIdArray  forKey:@"iaqSortedProductsIdArray"];
    [userdefault setObject:[IAQDataModel sharedIAQDataModel].iaqSortedProductsQuantityArray  forKey:@"iaqSortedProductsQuantityArray"];
    [userdefault setObject:[NSNumber numberWithInteger:IAQSummaryOfFinding]  forKey:@"iaqCurrentStep"];
    
    [userdefault synchronize];
    
    SummaryOfFindingVC* summaryOfFindingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingVC"];
    [self.navigationController pushViewController:summaryOfFindingVC animated:true];
        
}
//////////////////////////////////////////////
- (void) downloadIAQProducts {
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
        checkedProducts = [NSMutableArray array];
        for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
            [checkedProducts addObject:@"1"];
            iaqModel.quantity = @"1";
        }
        [self.collectionView reloadData];
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
    
    _fetchedResultsController = nil;
    
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
