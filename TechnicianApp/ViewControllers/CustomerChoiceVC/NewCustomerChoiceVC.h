//
//  NewCustomerChoiceVC.h
//  Signature
//
//  Created by Dorin on 8/11/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface NewCustomerChoiceVC : BaseVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
}

@property (strong, nonatomic) NSMutableArray *unselectedOptionsArray;
@property (nonatomic, strong) NSDictionary *fullServiceOptionsDict;
@property (nonatomic, strong) NSDictionary *selectedServiceOptionsDict;
@property (nonatomic, assign) BOOL isDiscounted;
@property (nonatomic, assign) BOOL isOnlyDiagnostic;
@property (nonatomic, strong) NSString *paymentValue;
@property (nonatomic, strong) NSString *initialTotal;
@property (weak, nonatomic) IBOutlet UIView *hiddenURLView;
@property (weak, nonatomic) IBOutlet RoundCornerView *roundedURLView;
@property (weak, nonatomic) IBOutlet UITextView *hiddenURLTextView;



@end
