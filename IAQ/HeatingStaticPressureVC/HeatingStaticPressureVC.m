//
//  HeatingStaticPressureVC.m
//  HvacTek
//
//  Created by Max on 11/8/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "HeatingStaticPressureVC.h"

@interface HeatingStaticPressureVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *filterSizeField;
@property (weak, nonatomic) IBOutlet UITextField *mervRatingField;
@property (weak, nonatomic) IBOutlet UITextField *systemTypeField;
@property (weak, nonatomic) IBOutlet UITextField *aField;
@property (weak, nonatomic) IBOutlet UITextField *bField;
@property (weak, nonatomic) IBOutlet UITextField *cField;
@property (weak, nonatomic) IBOutlet UITextField *dField;
@property (weak, nonatomic) IBOutlet UITextField *abField;
@property (weak, nonatomic) IBOutlet UITextField *acField;
@property (weak, nonatomic) IBOutlet UITextField *bdField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *backgroundLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *borderField;


@end

@implementation HeatingStaticPressureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UILabel* backlabel in self.backgroundLabel) {
        backlabel.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    }
    
    for (UITextField* iborderfield in self.borderField) {
        iborderfield.clipsToBounds = true;
        iborderfield.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
        iborderfield.layer.borderWidth = 1;
        
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
