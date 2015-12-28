//
//  aQuoteFirstTableViewController.m
//  Signature
//
//  Created by James Buckley on 31/07/2014.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "aQuoteFirstTableViewController.h"



@interface aQuoteFirstTableViewController ()

{

}

@end

@implementation aQuoteFirstTableViewController
@synthesize managedObjectContext;
@synthesize prodFRC;
@synthesize nextButton;
@synthesize heatingPicker, heatingSwitch;
@synthesize coolingPicker, coolingSwitch;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *apDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = apDel.managedObjectContext;
    

    coolingArray = [[NSArray alloc]initWithObjects:@"Please Select an Option",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4",@"5",@"6", nil];
    heatingArray = [[NSArray alloc]initWithObjects:@"Please Select an Option",@"40,000",@"60,000",@"68,000",@"79,000",@"80,000",@"100,000",@"101,000",@"120,000",@"124,000",@"135,000",@"140,000",nil];
    firstOption = [[FirstOption alloc]init];
    
    nextButton.enabled = NO;
    coolingPicker.tag = 1;
    coolingPicker.delegate = self;
    coolingPicker.hidden = YES;
    heatingPicker.tag = 2;
    heatingPicker.delegate = self;
    heatingPicker.hidden = YES;
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
}


-(void) home {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}


#pragma mark - Picker
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int j = [pickerView tag];
    switch (j) {
        case 1:{
            return coolingArray.count;
            break;
        }
        case 2:{
            return heatingArray.count;
            break;
        }
        default:
            return 0;
            break;
    }

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
  
    int j = [pickerView tag];
    switch (j) {
        case 1:{
            return coolingArray[row];
            break;
        }
        case 2:{
            return heatingArray[row];
            break;
        }
        
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    int j = [pickerView tag];
    switch (j) {
        case 1:
            firstOption.coolingValue = coolingArray[row];
            break;
        case 2:
            firstOption.heatingValue = heatingArray[row];
            break;
        default:
            break;
    }
}


- (IBAction)nextPage:(id)sender {
    [self performSegueWithIdentifier:@"quoteProd" sender:self];
}

- (IBAction)coolingSwitchfire:(id)sender {
    nextButton.enabled = YES;
    
    if (coolingSwitch.isOn) {
        firstOption.cooling = YES;
        coolingPicker.hidden = NO;
    }else {
        firstOption.cooling = NO;
        coolingPicker.hidden = YES;
    }
}

- (IBAction)heatingSwitchFire:(id)sender {
    nextButton.enabled = YES;
    if (heatingSwitch.isOn) {
        firstOption.heating = YES;
        heatingPicker.hidden = NO;
    }else {
        firstOption.heating = NO;
        heatingPicker.hidden =  YES;
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"quoteProd"]) {
        QuoteFirstTableViewController *sq = segue.destinationViewController;
        sq.managedObjectContext = managedObjectContext;
        sq.firstOption = firstOption;
    }
    
   
}

@end
