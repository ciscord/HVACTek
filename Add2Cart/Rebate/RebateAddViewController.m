//
//  RebateAddViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 12/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "RebateAddViewController.h"
#import "HvakTekColorScheme.h"

@interface RebateAddViewController ()<UIAlertViewDelegate>
{
    BOOL edit;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureColorScheme];
    [self configureUpperView];
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

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    self.save.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    __weak UIImageView *weakImageView = self.logoImageView;
    [self.logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                              placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           UIImageView *strongImageView = weakImageView;
                                           if (!strongImageView) return;
                                           
                                           strongImageView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           //
                                       }];
}

#pragma mark - Upper View
- (void)configureUpperView {
    CGFloat round = 20;
    UIView *upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 174, self.view.frame.size.width, 20)];
    upperArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = upperArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x,startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = upperArcView.bounds;
    layer.path = aPath.CGPath;
    upperArcView.layer.mask = layer;
    
    [self.view addSubview:upperArcView];
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
            int id_rebate = [itemz.typeID intValue] - 999;
            NSString *strID = [NSString stringWithFormat:@"%d",id_rebate];
          
            [[DataLoader sharedInstance] updateRebatesToPortal:self.nameField.text
                                                        amount:priceAmount
                                                      included:@"1"
                                                     rebate_id:strID
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
        int id_rebate = [rebID intValue] + 999;
        item.typeID = [NSNumber numberWithInt:id_rebate];
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
