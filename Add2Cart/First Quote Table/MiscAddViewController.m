//
//  MiscAddViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 21/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "MiscAddViewController.h"

@interface MiscAddViewController ()

@end

@implementation MiscAddViewController
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
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    
    
    // Do any additional setup after loading the view.
    save.enabled = NO;
    nameField.delegate = self;
    priceField.delegate = self;
    type = @"TypeTwo";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    save.enabled = YES;
    return YES;
    
}

- (IBAction)saveButton:(id)sender {
    
    Item *item;
            item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
        item.modelName = nameField.text;
       // float p = [priceField.text floatValue];
        item.price = priceField.text;
        item.type = type;
       
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Succesfully Saved" message:[NSString stringWithFormat:@"You have saved a new product"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) home {
  
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}
*/
@end
