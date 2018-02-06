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
