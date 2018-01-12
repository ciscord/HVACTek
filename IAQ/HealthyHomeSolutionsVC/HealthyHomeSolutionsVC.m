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
@property (weak, nonatomic)     IBOutlet RoundCornerView *layer1View;
@property (weak, nonatomic)   IBOutlet UILabel* titleLabel;
@property (weak, nonatomic)     IBOutlet UICollectionView *collectionView;

@end
static NSString *kCellIdentifier = @"ServiceOptionViewCell";
@implementation HealthyHomeSolutionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Healthy Home Solutions";
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
    IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
    
    ServiceOptionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
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
    unsigned long numberOfDots = [textField.text componentsSeparatedByString:@"."].count - 1;
    if (numberOfDots >0 && [string isEqualToString:@"."]) {
        return false;
    }
    NSString* newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (newString.length > 1) {
        unichar firstChar = [[newString uppercaseString] characterAtIndex:0];
        unichar secondChar = [[newString uppercaseString] characterAtIndex:1];
        if (firstChar == '0' && secondChar != '.') {
            NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
            
            BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
            if (stringIsValid) {
                textField.text = string;
                NSInteger itemIndex = textField.tag;
                IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
                
                item.quantity = string;
            }
            return false;
        }
        
    }
    if (textField.text.length == 1 && string.length == 0) {
        textField.text = @"0";
        return false;
    }
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:newString];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (stringIsValid) {
        
        NSInteger itemIndex = textField.tag;
        IAQProductModel *item = [IAQDataModel sharedIAQDataModel].iaqProductsArray[itemIndex];
        
        item.quantity = newString;
    }
    
    
    return stringIsValid;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - button event
-(IBAction)nextButtonClick:(id)sender {

    [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray = [NSMutableArray array];
    
    for (IAQProductModel * iaqModel in [IAQDataModel sharedIAQDataModel].iaqProductsArray) {
        if ([iaqModel.quantity intValue] > 0) {
            [[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray addObject:iaqModel];
        }
    }
    
    if ([IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count == 0) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Please input quantity"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    [IAQDataModel sharedIAQDataModel].isfinal = false;
    
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
