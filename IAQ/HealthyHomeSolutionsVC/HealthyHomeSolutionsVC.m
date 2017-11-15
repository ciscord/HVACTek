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

@interface HealthyHomeSolutionsVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
static NSString *kCellIdentifier = @"ServiceOptionViewCell";
@implementation HealthyHomeSolutionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.titleLabel setTextColor:[UIColor cs_getColorWithProperty:kColorPrimary]];
    [self.collectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    IAQProductModel *item      = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
    
    ServiceOptionViewCell             *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.btnCheckbox.hidden = true;
    cell.lbValue.text = item.title;
    cell.qtyTextField.delegate = self;
    cell.qtyTextField.text    = item.quantity;
    cell.qtyTextField.tag = itemIndex;
    cell.tag = itemIndex;
   
    CGRect titleRect = cell.lbValue.frame;
    titleRect.origin.x = 10;
    titleRect.size.width += 49;
    cell.lbValue.frame = titleRect;
    return cell;
}



#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *term = [textField.text stringByReplacingCharactersInRange:range withString: string];
    
    if (![term isNumeric]) {
        return NO;
    }
    NSInteger itemIndex = textField.tag;
    IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
    
    item.quantity = term;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - button event
-(IBAction)nextButtonClick:(id)sender {

    [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray = [NSMutableArray array];
    BOOL checkSelectedService = false;
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
        if ([iaqModel.quantity intValue] > 0) {
            checkSelectedService = true;
            [[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray addObject:iaqModel];
        }
    }
    
    if (checkSelectedService == false) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Please input quantity"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    
    HealthyHomeSolutionsSortVC* healthyHomeSolutionsSortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsSortVC"];
    [self.navigationController pushViewController:healthyHomeSolutionsSortVC animated:true];
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
