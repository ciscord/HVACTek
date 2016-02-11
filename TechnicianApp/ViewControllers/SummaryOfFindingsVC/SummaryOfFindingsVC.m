//
//  SummaryOfFindingsVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "SummaryOfFindingsVC.h"
#import "RepairVsServiceVC.h"
#import "PriceBookView.h"
#import "ServiceOptionVC.h"
#import "PricebookItem.h"
#import "PlatinumOptionsVC.h"

#pragma mark -

@interface SummaryOfFindingsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet RoundCornerView *vControlContainer;
@property (weak, nonatomic) IBOutlet UITextField     *tfSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbProblemTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet RoundCornerView *vContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (nonatomic, strong) NSMutableArray *priceBookList;
@property (nonatomic, strong) NSMutableArray *selectedMainOptions;
@property (nonatomic, strong) NSMutableArray *localPriceBookList;

@property (nonatomic, strong) NSString *filterTerm;

@end

static NSString *s_CellID = @"PriceBookView";

@implementation SummaryOfFindingsVC

static NSString *localPriceBookFileName = @"LocalPriceBook.plist";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Develop Summary of Findings";
    self.vControlContainer.backgroundColor = [UIColor colorWithRed:0.937 green:0.965 blue:0.886 alpha:1.000];
    
    self.tfSearch.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, 0.0)];
    self.tfSearch.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"summary-findings-search-icon"]];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setFrame: CGRectMake(0.0, 0.0, 40.0, 30.0)];
    
    self.tfSearch.rightView = imageView;
    self.tfSearch.rightViewMode = UITextFieldViewModeAlways;
    
    self.tfSearch.font = [UIFont fontWithName:@"Calibri" size:18];
    self.lbProblemTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    self.btnAdd.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    self.btnBack.titleLabel.font = self.btnAdd.titleLabel.font;
    self.btnNext.titleLabel.font = self.btnAdd.titleLabel.font;
    
    self.priceBookList = @[].mutableCopy;
    self.selectedMainOptions = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:s_CellID bundle:nil] forCellReuseIdentifier:s_CellID];
    [self setFilterTerm:@""];
}

-(void) loadLocalPricebooks
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [basePath stringByAppendingPathComponent: localPriceBookFileName];
    
    
    NSMutableDictionary *priceBooks = [NSMutableDictionary dictionaryWithContentsOfFile: filePath];
    if(priceBooks) {
        self.localPriceBookList = [NSMutableArray array];
        NSArray *keys = [priceBooks allKeys];
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {

            NSDictionary *d = [priceBooks objectForKey: key];

            PricebookItem *p = [PricebookItem pricebookWithID:d[@"itemID"]
                                                   itemNumber:d[@"itemNumber"]
                                                    itemGroup:d[@"itemGroup"]
                                                         name:d[@"name"]
                                                     quantity:@""
                                                       amount:d[@"amount"]
                                                 andAmountESA:d[@"amountESA"]];
            [self.priceBookList addObject: p];
            [self.localPriceBookList addObject: p];
        }];
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Keyboard Notifications

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGPoint center = [self.vContent convertPoint:self.vContent.center fromView:self.vContent.superview];
    center.y -= 140;
    self.vControlContainer.center = center;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGPoint center = [self.vContent convertPoint:self.vContent.center fromView:self.vContent.superview];
    self.vControlContainer.center = center;
    
    // commit animations
    [UIView commitAnimations];
}

#pragma mark -

-(void) setFilterTerm:(NSString *)filterTerm
{
    if ([filterTerm length]) {

        [self.priceBookList removeAllObjects];
        [self.selectedServiceOptions enumerateObjectsUsingBlock:^(PricebookItem *priceBook, NSUInteger idx, BOOL *stop) {
            if ([priceBook.name rangeOfString: filterTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.priceBookList addObject: priceBook];
            }
        }];
        
        [self.localPriceBookList enumerateObjectsUsingBlock:^(PricebookItem *priceBook, NSUInteger idx, BOOL *stop) {
            if ([priceBook.name rangeOfString: filterTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.priceBookList addObject: priceBook];
            }
        }];
    } else {
        self.priceBookList = [NSMutableArray arrayWithArray: self.selectedServiceOptions];
        [self loadLocalPricebooks];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing: YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)addNewPriceBook:(id)sender {
    
    if ([UIAlertController class])
    {
        // use UIAlertController
        UIAlertController *alert= [UIAlertController alertControllerWithTitle: @"Add New Item"
                                                                      message: nil
                                                               preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                       UITextField *nameTextField = alert.textFields[0];
                                                       UITextField *amountTextField = alert.textFields[1];
                                                       NSString *name = nameTextField.text;
                                                       NSNumber *amount = @([amountTextField.text floatValue]);
                                                       
                                                       [self addNewPriceBookWithName: name andAmount: amount];
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];

        [alert addAction:cancel];
        [alert addAction:ok];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Item name";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Amount";
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Add New Item"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Add", nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert textFieldAtIndex:1].secureTextEntry = NO;
        [alert textFieldAtIndex:0].placeholder = @"Item name";
        [alert textFieldAtIndex:1].placeholder = @"Amount";
        [alert textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [alert setDelegate: self];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"serviceOptionSegue"])
    {
        ServiceOptionVC *vc = [segue destinationViewController];
        vc.optionsDisplayType = odtEditing;
        NSMutableArray *result = @[].mutableCopy;
        for (PricebookItem *p in self.selectedMainOptions) {
            p.isMain = YES;
            [result addObject:p];
        }
        
        for (PricebookItem *p in self.selectedServiceOptions) {
            if ([self.selectedMainOptions indexOfObject:p] == NSNotFound) {
                p.isMain = NO;
                [result addObject:p];
            }
        }
        vc.priceBookAndServiceOptions = result;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.priceBookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceBookView *cell = (PriceBookView*)[tableView dequeueReusableCellWithIdentifier:s_CellID];
    PricebookItem *pricebook = self.priceBookList[indexPath.row];
    cell.lbName.text = pricebook.name;
    cell.btnCheckbox.selected = [self.selectedMainOptions containsObject:pricebook];
    cell.tag = indexPath.row;
    __weak typeof (self) weakSelf = self;
    [cell setOnSelect:^(PriceBookView *sender) {
        PricebookItem *option = weakSelf.priceBookList[sender.tag];
        if ([weakSelf.selectedMainOptions containsObject:option]) {
            [weakSelf.selectedMainOptions removeObject:option];
        }
        else {
            [weakSelf.selectedMainOptions addObject:option];
        }
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        NSString *name = [alertView textFieldAtIndex: 0].text;
        NSNumber *amount = @([[alertView textFieldAtIndex: 1].text floatValue]);
        
        [self addNewPriceBookWithName: name andAmount: amount];
    }
}

#pragma mark -

-(void) addNewPriceBookWithName: (NSString *) name andAmount: (NSNumber *) amount
{
    if ([name length] == 0) {
        ShowOkAlertWithTitle(@"Invalid name, please try again!", self);
        return;
    }
    
    if (!amount) {
        ShowOkAlertWithTitle(@"Invalid amount, please try again!", self);
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [basePath stringByAppendingPathComponent: localPriceBookFileName];
    
    NSMutableDictionary *priceBooks = [NSMutableDictionary dictionaryWithContentsOfFile: filePath];
    if(!priceBooks) priceBooks = [NSMutableDictionary new];
    
    if ([[priceBooks allKeys] containsObject: name]) {
        
        ShowOkAlertWithTitle([NSString stringWithFormat: @"An item with '%@' name already exists, please try again!", name], self);
        return;
    }
    
    NSDictionary *d = @{@"itemID" : @(-1), @"itemNumber" : @(-1), @"itemGroup" : @"LOCAL", @"name" : name, @"amount" : amount, @"amountESA" : amount};
    
    [priceBooks setObject:d forKey: name];
    [priceBooks writeToFile:filePath atomically: YES];
    
    
    self.priceBookList = [NSMutableArray arrayWithArray: self.selectedServiceOptions];
    [self loadLocalPricebooks];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *term = [textField.text stringByReplacingCharactersInRange:range withString: string];
    
    self.filterTerm = term;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
