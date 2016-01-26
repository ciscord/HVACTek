//
//  RebateAddViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 12/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "RebateAddViewController.h"

@interface RebateAddViewController ()<UIAlertViewDelegate>
{
    BOOL edit;
}

@end

@implementation RebateAddViewController
@synthesize nameField, priceField, save, type;
@synthesize managedObjectContext;
@synthesize itemz;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    
    /* types = [[NSArray alloc]initWithObjects:@"Air Conditioners",@"Heat Pumps", @"Furnaces",@"Air Handlers"
     ,@"Geothermal", @"IAQ",@"Accessories",@"Rebates", @"Boilers",@"Hot Water Heaters", nil];
*/
    self.type = @"Rebates";
    //self.type = @"Air Conditioners";
    // Do any additional setup after loading the view.
    save.enabled = NO;
    save.alpha = 0.5;
    
    
    self.nameField.delegate = self;
    self.priceField.delegate = self;
    if (itemz) {
        
        edit = YES;
         nameField.text = itemz.modelName;
         float p = [itemz.finalPrice floatValue];
         priceField.text = [NSString stringWithFormat:@"%.0f",p];
            }
}


-(void) home {
  
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) getItem:(Item *)itemy {
    
    Item *editt;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    req.predicate = [NSPredicate predicateWithFormat:@"modelName = %@",itemy.modelName];
    NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"modelName" ascending:YES];
    req.sortDescriptors =[NSArray arrayWithObject:sort];
    
    NSError *error = nil;
    NSArray *occ = [managedObjectContext executeFetchRequest:req error:&error];
    
    if (![occ count]) {
        
    } else  {
        editt = [occ lastObject];
    }
  }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.nameField.text.length > 0 && self.priceField.text.length > 0) {
        save.alpha = 1.0;
        save.enabled = YES;
    }else{
        save.alpha = 0.5;
        save.enabled = NO;
    }
    return YES;
}



- (IBAction)saveButton:(id)sender {
    
    if (edit) {
        float priceAmount = [self.priceField.text floatValue];
        
        if (priceAmount > 0) {
            [[DataLoader sharedInstance] updateRebatesToPortal:self.nameField.text
                                                        amount:priceAmount
                                                      included:@"1"
                                                     rebate_id:[itemz.typeID stringValue]
                                                     onSuccess:^(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd) {
                                                         NSLog(@"SUCCES %@ :%@",successMessage, rebateID);
                                                         [self addLocalRebateWithId:rebateID andOrd:rebateOrd];
                                                      
                                                  }onError:^(NSError *error) {
                                                      ShowOkAlertWithTitle(error.localizedDescription, self);
                                                      NSLog(@"ERROR");
                                                  }];
        }else{
            ShowOkAlertWithTitle(@"Please introduce a valid price amount.", self);
        }
    }else{
        float priceAmount = [self.priceField.text floatValue];
        
        if (priceAmount > 0) {
            [[DataLoader sharedInstance] addRebatesToPortal:self.nameField.text
                                                     amount:priceAmount
                                                   included:@"1"
                                                  onSuccess:^(NSString *successMessage, NSNumber *rebateID, NSNumber *rebateOrd) {
                                                      NSLog(@"SUCCES %@ :%@",successMessage, rebateID);
                                                      [self addLocalRebateWithId:rebateID andOrd:rebateOrd];
                                                      
                                                  }onError:^(NSError *error) {
                                                      ShowOkAlertWithTitle(error.localizedDescription, self);
                                                      NSLog(@"ERROR");
                                                  }];
        }else{
            ShowOkAlertWithTitle(@"Please introduce a valid price amount.", self);
        }
    }
}


#pragma mark - Add New Rebate
-(void)addLocalRebateWithId:(NSNumber *)rebID andOrd:(NSNumber *)ordID {
    Item *item;
    
    if (!edit) {
        
        item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
        item.modelName = nameField.text;
        float p = [priceField.text floatValue];
        item.finalPrice = [NSNumber numberWithFloat:p];
        item.type = @"Rebates";
        item.usserAdet =[NSNumber numberWithInt:1];
        item.ord = ordID;
        item.typeID = rebID;
       // item.
        //itm.type = @"Rebates";
    } else {
        
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        req.predicate = [NSPredicate predicateWithFormat:@"modelName = %@",itemz.modelName];
        NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"modelName" ascending:YES];
        req.sortDescriptors =[NSArray arrayWithObject:sort];
        
        NSError *error = nil;
        NSArray *occ = [managedObjectContext executeFetchRequest:req error:&error];
        
        if (![occ count]) {
            
        } else  {
            item = [occ lastObject];
            item.modelName = nameField.text;
            float p = [priceField.text floatValue];
            item.finalPrice = [NSNumber numberWithFloat:p];
            item.type = type;
            
        }
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Succesfully Saved" message:[NSString stringWithFormat:@"You have saved a new %@",type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
    
};
@end
