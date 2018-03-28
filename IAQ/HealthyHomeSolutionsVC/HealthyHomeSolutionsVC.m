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
@interface HealthyHomeSolutionsVC ()<UITextFieldDelegate>
{
    
    
}
@property (weak, nonatomic)     IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic)   IBOutlet UILabel* titleLabel;
@property (weak, nonatomic)     IBOutlet UICollectionView *collectionView;

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
        
        //skip sort page if array count is 1
        if ([IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count == 1) {
            IAQCustomerChoiceVC* iaqCustomerChoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IAQCustomerChoiceVC"];
            
            [self.navigationController pushViewController:iaqCustomerChoiceVC animated:true];
        }else {
            HealthyHomeSolutionsSortVC* healthyHomeSolutionsSortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsSortVC"];
            [self.navigationController pushViewController:healthyHomeSolutionsSortVC animated:true];
        }
        
    }else {
        checkedProducts = [NSMutableArray array];
        for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
            [checkedProducts addObject:@"1"];
            iaqModel.quantity = @"1";
        }
        
    }
}

- (void) tapTechButton {
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    NSNumber* techCurrentStep = [userdefault objectForKey:@"techCurrentStep"];
    if (techCurrentStep == nil) {
        techCurrentStep = [NSNumber numberWithInteger:TechnicianHome];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    UIViewController* currentViewController;
    
    Job* activeJob = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (activeJob == nil) {
        currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
    }else {
        switch (techCurrentStep.intValue) {
            case TechnicianHome:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
                break;
            case Dispatch:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"DispatchVC"];
                break;
            case CustomerOverview:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomerOverviewVC"];
                break;
            case SettingAgenda:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingAgendaVC"];
                break;
            case AgendaPicture:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"AgendaPictureVC"];
                break;
            case Questions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC"];
                break;
            case Questions1:
            {
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC1"];
                QuestionsVC* questionsVC = (QuestionsVC*) currentViewController;
                
                questionsVC.questionType = qtTechnician;
                break;
            }
            case UtilityOverpayment:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"UtilityOverpaymentVC"];
                break;
            case ExploreSummary:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ExploreSummaryVC"];
                break;
            case SummaryOfFindingsOptions1:
            {
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC1"];
                SummaryOfFindingsOptionsVC* questionsVC = (SummaryOfFindingsOptionsVC*) currentViewController;
                
                questionsVC.isiPadCommonRepairsOptions = YES;
                break;
            }
            case SortFindings:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SortFindingsVC"];
                break;
            case SummaryOfFindingsOptions2:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC2"];
                break;
            case ViewOptions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewOptionsVC"];
                break;
            case PlatinumOptions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlatinumOptionsVC"];
                break;
            case RRFinalChoice:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"RRFinalChoiceVC"];
                break;
            case ServiceOption1:
            {
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ServiceOptionVC"];
                ServiceOptionVC* serviceOptionVC = (ServiceOptionVC*) currentViewController;
                
                serviceOptionVC.optionsDisplayType = odtEditing;
                break;
            }
            case CustomerChoice:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomerChoiceVC"];
                break;
            case AdditionalInfoPage:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"AdditionalInfoPageVC"];
                break;
            case NewCustomerChoice:
            case InvoicePreview:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewCustomerChoiceVC"];
                break;
                
            case TechnicianDebrief:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianDebriefVC"];
                break;
            default:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
                break;
        }
    }
    
    
    
    
    AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    UINavigationController *navController = (UINavigationController *)appDelegate.window.rootViewController;
    
    UIViewController* homeViewController = [navController.viewControllers objectAtIndex:1];
    [navController popToViewController:homeViewController animated:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5), dispatch_get_main_queue(), ^{
        [navController pushViewController:currentViewController animated:true];
    });
    
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
    
    if ([IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count == 1) {
        [userdefault setObject:[NSNumber numberWithInteger:IAQCustomerChoice]  forKey:@"iaqCurrentStep"];
    }else{
        [userdefault setObject:[NSNumber numberWithInteger:IAQHealthyHomeSolutionSort]  forKey:@"iaqCurrentStep"];
    }
    
    [userdefault synchronize];
    
    //skip sort page if array count is 1
    if ([IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count == 1) {
        IAQCustomerChoiceVC* iaqCustomerChoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IAQCustomerChoiceVC"];
        
        [self.navigationController pushViewController:iaqCustomerChoiceVC animated:true];
    }else {
        HealthyHomeSolutionsSortVC* healthyHomeSolutionsSortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsSortVC"];
        [self.navigationController pushViewController:healthyHomeSolutionsSortVC animated:true];
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
