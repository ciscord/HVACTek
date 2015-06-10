//
//  AddProductViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "AddProductViewController.h"

@interface AddProductViewController ()

@end

@implementation AddProductViewController
@synthesize modelNumber;
@synthesize price;
@synthesize optionOne, optionTwo, optionThree;
@synthesize typeButton, doneButton, saveButton, chooseImage;
@synthesize image;
@synthesize pickerView;
@synthesize type;
@synthesize pickerController;
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
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];

    pickerView.hidden = YES;
    pickerController.delegate = self;
    manufacturers = [[NSArray alloc]initWithObjects:@"Daiken",@"Trane",@"York",@"Rheem",@"Bryant",@"Honeywell", nil];
    [self setDelegates];
    saveButton.enabled = NO;
    
    if (itemz) {
        
        edit = YES;
       modelNumber.text = itemz.modelName;
        float p = [itemz.price floatValue];
        price.text = [NSString stringWithFormat:@"%.2f",p];
        image.image = [UIImage imageWithData:itemz.photo];
        optionOne.text = [NSString stringWithFormat:@"$%.2f", [itemz.optionOne floatValue]];
        optionTwo.text = [NSString stringWithFormat:@"$%.2f", [itemz.optionTwo floatValue]];
        optionThree.text = [NSString stringWithFormat:@"$%.2f", [itemz.optionThree floatValue]];
        typeButton.titleLabel.text = itemz.manu;
        saveButton.enabled = YES;
        
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



- (IBAction)typeSelect:(id)sender {
    pickerView.hidden = NO;
    saveButton.hidden = YES;
}

- (IBAction)pickerDone:(id)sender {
    
    pickerView.hidden = YES;
    saveButton.hidden = NO;
}



- (IBAction)saveItemAction:(id)sender {
    
    Item *item;
    UIAlertView *al;
    if (!edit) {
        item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];

        
        item.modelName = modelNumber.text;
        float p = [price.text floatValue];
        item.price = [NSNumber numberWithFloat:p];
        float q = [optionOne.text floatValue];
        item.optionOne = [NSNumber numberWithFloat:q];
        
        float r = [optionTwo.text floatValue];
        item.optionTwo = [NSNumber numberWithFloat:r];
        
        float s = [optionThree.text floatValue];
        item.optionThree= [NSNumber numberWithFloat:s];

        NSData *imageData = UIImagePNGRepresentation(imagePic);
        item.photo = imageData;
        item.type = type;
        
        al = [[UIAlertView alloc]initWithTitle:@"Succesfully Saved" message:[NSString stringWithFormat:@"You have saved a new %@",type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        
        
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
            item.modelName = modelNumber.text;
            float p = [price.text floatValue];
            item.price = [NSNumber numberWithFloat:p];
            float q = [optionOne.text floatValue];
            item.optionOne = [NSNumber numberWithFloat:q];
            
            float r = [optionTwo.text floatValue];
            item.optionTwo = [NSNumber numberWithFloat:r];
            
            float s = [optionThree.text floatValue];
            item.optionThree= [NSNumber numberWithFloat:s];
            
            
            NSData *imageData = UIImagePNGRepresentation(imagePic);
            item.photo = imageData;
            item.type = type;
            al = [[UIAlertView alloc]initWithTitle:@"Succesfully Saved" message:[NSString stringWithFormat:@"You have saved an exisiting %@",type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        }
        
        
        
        
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
    
   // UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Succesfully Saved" message:[NSString stringWithFormat:@"You have saved a new %@",type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [al show];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

    
#pragma mark - Textfields

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

-(void) setDelegates {
    modelNumber.delegate = self;
    price.delegate = self;
    optionOne.delegate = self;
    optionTwo.delegate = self;
    optionThree.delegate = self;
}

#pragma mark - Photo

- (IBAction)imageSelect:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	image.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imagePic = image.image;
    saveButton.enabled = YES;
}

#pragma mark - Picker
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return manufacturers.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return manufacturers[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    manufactName = manufacturers[row];
    [typeButton setTitle:manufactName forState:UIControlStateNormal];
    
}
*/

@end
