//
//  testerViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 17/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "testerViewController.h"
#import "PictureLibraryVC.h"
#import "VideoLibraryVC.h"
#import "RRQuestionsVC.h"
#import "HealthyHomeSolutionsAgreementVC.h"
#import "IAQDataModel.h"
@interface testerViewController () <CartViewControllerDelegate>{
    
    IBOutlet UILabel *lblSystemRebates;
    IBOutlet UILabel *lblInvestemts;
//    IBOutlet UILabel *lblFinancing;
    
    IBOutlet UIButton *btnFinancing;
    
    __weak IBOutlet UIButton *btnEasyPay;
//    IBOutlet UILabel *lblFinancingValue;
    IBOutlet UIButton *btnCart1;
    IBOutlet UIButton *btnCart2;
    IBOutlet UIButton *btnCart3;
    __weak IBOutlet UIButton *cartButton;
    __weak IBOutlet UIButton *iaqButton;
    
    __weak IBOutlet UIImageView *logoImageView;
    __weak IBOutlet UIButton *videoButton;
    __weak IBOutlet UIButton *pictureButton;
    __weak IBOutlet UIButton *tcoButton;
    
    __weak IBOutlet UILabel *lblEasyPay;
    __weak IBOutlet UILabel *lblEasyPrice;
    __weak IBOutlet UILabel *lblEasyPercent;
    
    __weak IBOutlet UILabel *lblInvestmentMonth;
    __weak IBOutlet UILabel *lblFastPercent;
    
    __weak IBOutlet UILabel *lblFastPay;
    __weak IBOutlet UILabel *lblFastPrice;

    float easyPaymentFactor;
    float fastPaymentFactor;
    
    NSString* investDescription;
    
    BOOL isEasy;
}
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIButton *rebatesButton;
@property (weak, nonatomic) IBOutlet UIButton *investmentButton;
@property (weak, nonatomic) IBOutlet UICollectionView *monthsCollectionView;

@end

@implementation testerViewController
@synthesize managedObjectContext;
@synthesize prodFRC;
@synthesize monthlyPayment, totalAmountLabel, totalSavingsLabel,afterSavingsLabel,financeMonthLabel;
@synthesize additemsB;
@synthesize secView;
@synthesize tableViewX;
@synthesize firstOption;
@synthesize easyFinancialsData;
@synthesize fastFinancialsData;

static NSString *kCellIdentifier = @"MonthsCollectionViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidDisappear:(BOOL)animated {
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //need to update
    easyPaymentFactor = 0;
    fastPaymentFactor = 0;
    self.fastMonth = -1;
    self.easyMonth = -1;
    
    lblEasyPercent.text = @"";
    lblFastPercent.text = @"";
    //
    
    [self configureColorScheme];
    [self configureUpperView];
    
    self.easyFinancialsData = [[NSMutableArray alloc] init];
    self.fastFinancialsData = [[NSMutableArray alloc] init];
    
    allData = [[NSMutableArray alloc] init];
    
     [self.monthsCollectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    //Init the ints ??????
    choosedAirCon = 0;
    choosedHeatPump = 0;
    choosedFurn = 0;
    choosedAirH = 0;
    choosedGeo = 0;
    choosedIAQ = 0;
    choosedAcces = 0;
    choosedBoilers = 0;
    choosedHotWater = 0;
    choosedWarranties = 0;
    choosedDuctlessMiniSplits = 0;
    
    //Tapped is for collapsable cell
    tapped= FALSE;
    sections = [[NSMutableSet alloc]initWithCapacity:9];
    
    //reset all labels.
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    afterSavings =0.0f ;
    finacePay = 0.0f;
    monthlyPay = 0.0f;
    
    //Move to a mutable array for later.
    _cartItems = [[NSMutableArray alloc]init];
    self.carts = [[NSMutableArray alloc]init];
    self.savedCarts = [[NSMutableArray alloc]init];
    
    //Setup the navbar.
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];// style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnBack, btnShare, nil]];
    
    //Set delegate & views
    tableViewX.delegate = self;
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(celltapped:)];
    [tableViewX addGestureRecognizer:tap];
    [tableViewX addGestureRecognizer:swipeGestureRight];
    [tableViewX addGestureRecognizer:swipeGestureLeft];
    [self.view sendSubviewToBack:secView];
    
    __weak typeof (self) weakSelf = self;
    [[DataLoader sharedInstance] add2cartFinancials:nil
                                          onSuccess:^(NSString *successMessage, NSDictionary *reciveData) {
                                              if (reciveData.count == 1) {
                                                  [self  clearFinancials];
                                                  [self saveFinancials:reciveData];
                                                  [self fetchFinancingObjects];
                                                  [self buildQuote];
                                                  
                                              }
                                              
                                          }onError:^(NSError *error) {
                                              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                              [self fetchFinancingObjects];
                                          }];
}


-(void) clearFinancials {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"financialId" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    
    NSError *fetchingError = nil;
    
    NSArray *occP = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchingError];
    
    if (![occP count]) {
        
    } else  {
        for (int i = 0; i<occP.count; i++) {
            Financials  *del = occP[i];
            [self.managedObjectContext deleteObject:del];
        }
    }
}

- (void)saveFinancials:(NSDictionary *)financials {
    NSDictionary* datadict = ((NSArray*)financials)[0];
    
    NSArray* easyPayArray = [datadict objectForKey:@"easy_pay"];
    for (int x = 0; x < easyPayArray.count; x++) {
        
        if (![self isEmpty:[easyPayArray[x] objectForKey:@"value"]] &&
            ![self isEmpty:[easyPayArray[x] objectForKey:@"month"]] ) {
            Financials *itm = (Financials *)[NSEntityDescription insertNewObjectForEntityForName:@"Financials" inManagedObjectContext:self.managedObjectContext];
            itm.financialId = [easyPayArray[x] objectForKey:@"id"];
            itm.businessid = [easyPayArray[x] objectForKey:@"businessid"];
            itm.description1 = [easyPayArray[x] objectForKey:@"description"];
            itm.month = [easyPayArray[x] objectForKey:@"month"];
            itm.type = @"easy";
            itm.value = [easyPayArray[x] objectForKey:@"value"];
            
        }
        
    }
    NSArray* fastPayArray = [datadict objectForKey:@"fast_pay"];
    for (int x = 0; x < fastPayArray.count; x++) {
        
        if (![self isEmpty:[fastPayArray[x] objectForKey:@"month"]] ) {
            Financials *itm = (Financials *)[NSEntityDescription insertNewObjectForEntityForName:@"Financials" inManagedObjectContext:self.managedObjectContext];
            itm.financialId = [fastPayArray[x] objectForKey:@"id"];
            itm.businessid = [fastPayArray[x] objectForKey:@"businessid"];
            itm.description1 = [fastPayArray[x] objectForKey:@"description"];
            itm.month = [fastPayArray[x] objectForKey:@"month"];
            itm.type = @"fast";
            itm.value = [fastPayArray[x] objectForKey:@"value"];
            
        }
        
    }
    
    NSDictionary* investmentDescription = [datadict objectForKey:@"investment_description"];
    if (investmentDescription != nil) {
        Financials *itm = (Financials *)[NSEntityDescription insertNewObjectForEntityForName:@"Financials" inManagedObjectContext:self.managedObjectContext];
        itm.financialId = [investmentDescription objectForKey:@"id"];
        itm.businessid = [investmentDescription objectForKey:@"businessid"];
        itm.value = [investmentDescription objectForKey:@"value"];
        itm.type = @"investment";
    }
    NSError *errorz;
    if (![self.managedObjectContext save:&errorz]) {
        NSLog(@"Cannot save ! %@ %@",errorz,[errorz localizedDescription]);
    }
    
}
- (BOOL) isEmpty:(NSObject*) data {
    if (data == nil) {
        return true;
    }
    if ([data isEqual:[NSNull null]]) {
        return true;
    }
    return false;
}
#pragma mark - Fetch Financing

-(void)fetchFinancingObjects {
    
    //easy financial
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"type = %@",@"easy"];
    NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    fetchRequest.sortDescriptors =[NSArray arrayWithObject:sort];
    
    [fetchRequest setEntity:entity];
    
    NSError *fetchingError = nil;
    
    [self.easyFinancialsData addObjectsFromArray:[self.managedObjectContext
                                  executeFetchRequest:fetchRequest error:&fetchingError]];
    
    //fast financial
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:managedObjectContext];
    fetchRequest1.predicate = [NSPredicate predicateWithFormat:@"type = %@",@"fast"];
    sort =[NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    fetchRequest1.sortDescriptors =[NSArray arrayWithObject:sort];
    
    [fetchRequest1 setEntity:entity];
    
    [self.fastFinancialsData addObjectsFromArray:[self.managedObjectContext
                                                  executeFetchRequest:fetchRequest1 error:&fetchingError]];
    
    //investment
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:managedObjectContext];
    fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"type = %@",@"investment"];
    [fetchRequest2 setEntity:entity];
    
    NSArray* investmentArray  = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:&fetchingError];
    if (investmentArray.count > 0 && investmentArray != nil) {
        Financials *investItem = [investmentArray objectAtIndex:0];
        investDescription = investItem.value;
    }else{
        investDescription = @"";
    }
    
    [self configureFinancingDefaults];
}

-(void)configureFinancingDefaults {
    if (self.easyFinancialsData.count > 0) {
        Financials *item = self.easyFinancialsData[0];
        self.easyMonth = item.month.intValue;
        self.easySelectedIndex = 0;
    }else {
        self.easyMonth = -1;
    }

    if (self.fastFinancialsData.count > 0) {
        Financials *item = self.fastFinancialsData[0];
        self.fastMonth = item.month.intValue;
        self.fastSelectedIndex = 0;
    }else {
        self.fastMonth = -1;
    }
    
}

-(void) home {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud showWhileExecuting:@selector(resetRebatesOnHome) onTarget:self withObject:nil animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated   {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud showWhileExecuting:@selector(resetCartData) onTarget:self withObject:nil animated:YES];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.detailsView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    secView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    cartButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
//    iaqButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    videoButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    pictureButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    tcoButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.rebatesButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.investmentButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
   // btnFinancing.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary35];
     btnFinancing.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    btnEasyPay.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    __weak UIImageView *weakImageView = logoImageView;
    [logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
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
    UIView *upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.detailsView.width, 20)];
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
    
    [self.detailsView addSubview:upperArcView];
}

- (void)resetCartData {
    //Fetch the data.
    [self fetchData];
    
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    afterSavings =0.0f ;
    finacePay = 0.0f;
    monthlyPay = 0.0f;
    
    [self assignChoosedOptionsValues];
    
    [self buildQuote];
    
    btnCart1.hidden = !(self.savedCarts.count > 0);
    btnCart2.hidden = !(self.savedCarts.count > 1);
    btnCart3.hidden = !(self.savedCarts.count > 2);
    
    if (self.isEditing) {
        cartButton.enabled = YES;
        btnCart1.enabled = NO;
        btnCart2.enabled = NO;
        btnCart3.enabled = NO;
        btnCart1.alpha = 0.5;
        btnCart2.alpha = 0.5;
        btnCart3.alpha = 0.5;
    }else{
        cartButton.enabled = self.savedCarts.count < 3;
        btnCart1.enabled = YES;
        btnCart2.enabled = YES;
        btnCart3.enabled = YES;
        btnCart1.alpha = 1.0;
        btnCart2.alpha = 1.0;
        btnCart3.alpha = 1.0;
    }
}

-(void) setupArrays {
    headers = [[NSArray alloc]initWithObjects:@"Controls",  @"Warranties", @"Indoor Air Quality", @"Air Conditioners", @"Furnaces", @"Heat Pumps",
               @"Air Handlers", @"Geothermal" , @"Hot Water Heaters", @"Boilers",  @"Ductless Mini Splits", nil];
    airCon = [[NSMutableArray alloc]init];
    furn = [[NSMutableArray alloc]init];
    heatPump = [[NSMutableArray alloc]init];
    airH = [[NSMutableArray alloc]init];
    geo = [[NSMutableArray alloc]init];
    acces = [[NSMutableArray alloc]init];
    iaq = [[NSMutableArray alloc]init];
    typeFours = [[NSMutableArray alloc]init];
    typeThrees = [[NSMutableArray alloc]init];
    
    boilers=[[NSMutableArray alloc]init];
    hotwater=[[NSMutableArray alloc]init];
    
    warranties = [[NSMutableArray alloc] init];
    ductlessMiniSplits = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch and Sort
-(void) fetchData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"type" ascending:YES];
    NSSortDescriptor *manSort = [[NSSortDescriptor alloc]initWithKey:@"manu" ascending:YES];
    //    NSSortDescriptor *ordSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
    NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"currentCart = %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"workingCurrentCartIndex"]];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, manSort,  nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:cartPredicate];
    
    NSError *fetchingError = nil;
    
    [allData removeAllObjects];
    [allData addObjectsFromArray:[self.managedObjectContext
                                  executeFetchRequest:fetchRequest error:&fetchingError]];
    
    [self setupArrays];
    //Need to call sort here
    [self sortData];
}

-(void) sortData {
    
    int cool = 0;
    int heat = 0;
    int boilersInt = 0;
    int ductlessInt = 0;
    
    if (firstOption.heating)
        heat = 2;
    if (firstOption.cooling)
        cool = 1;
    if (firstOption.boilers)
        boilersInt = 5;
    if (firstOption.ductless)
        ductlessInt = 6;
    
    NSMutableArray *coolProds = [[NSMutableArray alloc] init];
    NSMutableArray *heatProds = [[NSMutableArray alloc] init];
    NSMutableArray *boilersProds = [[NSMutableArray alloc] init];
    NSMutableArray *ductlessProds = [[NSMutableArray alloc] init];
    
    
    //Need to itterate through all of the items for included items.  Once we have an included item check if it matches type 1 or 2. Then check its price and add to final
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        
        int tID = [itm.typeID intValue];
        if (tID == cool && (![coolProds containsObject:itm])) {
            [coolProds addObject:itm];
        }
        if (tID == heat && (![heatProds containsObject:itm])) {
            [heatProds addObject:itm];
        }
        if (tID == boilersInt && (![boilersProds containsObject:itm])) {
            [boilersProds addObject:itm];
        }
        if (tID == ductlessInt && (![ductlessProds containsObject:itm])) {
            [ductlessProds addObject:itm];
        }
        
        
        if ((tID == 3)&& (![typeThrees containsObject:itm])) {
            [typeThrees addObject:itm];
        }// end of 3's
        if ((tID == 4)&& (![typeFours containsObject:itm])) {
            [typeFours addObject:itm];
        }
        
    } //end of iteration
    
    [self sortTypeThrees];
    [self sortTypeFours];
    
    rebates = [[NSMutableArray alloc]init];
    
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        bool t = [itm.include boolValue];
        if (t && [itm.type isEqualToString:@"Rebates"]) {
            [rebates addObject:itm];
        }
    }
    
    //So have the products now... Check the values of the heat and cool now.
    for (int x = 0; x < coolProds.count; x++) {
        Item *itm = coolProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsCoolPrice:itm]];
        itm.finalOption = [self checkOptionsCoolOpt:itm];
        
        if ([itm.finalOption isEqualToString:@"None"]) {
            //do nothing
        } else {
            [self fillArrays:itm];
        }
        
    }
    
    for (int x = 0; x < heatProds.count; x++) {
        Item *itm = heatProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsHeatPrice:itm]];
        itm.finalOption = [self checkOptionsHeatOpt:itm];
        
        if ([itm.finalOption isEqualToString:@"None"]) {
            //don nothing
        } else {
            [self fillArrays:itm];
        }
    }
    
    
    for (int x = 0; x < boilersProds.count; x++) {
        Item *itm = boilersProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsBoilersPrice:itm]];
        itm.finalOption = [self checkOptionsBoilersOpt:itm];
        
        if ([itm.finalOption isEqualToString:@"None"]) {
        } else {
            [self fillArrays:itm];
        }
    }
    
    for (int x = 0; x < ductlessProds.count; x++) {
        Item *itm = ductlessProds[x];
        itm.finalPrice = [NSNumber numberWithFloat:[self checkOptionsDuctlessPrice:itm]];
        itm.finalOption = [self checkOptionsDuctlessOpt:itm];
        
        if ([itm.finalOption isEqualToString:@"None"]) {
            //don nothing
        } else {
            [self fillArrays:itm];
        }
    }
    
    [self arraySort];
    
    //call the blanks here
    
    //   Item *itm;
    if (airCon.count>0) {
        [airCon insertObject:[self loadTheBlank] atIndex:0];
    }
    if (heatPump.count>0) {
        [heatPump insertObject:[self loadTheBlank] atIndex:0];
    }
    if (furn.count>0) {
        [furn insertObject:[self loadTheBlank] atIndex:0];
    }
    if (airH.count>0) {
        [airH insertObject:[self loadTheBlank] atIndex:0];
    }
    if (geo.count>0) {
        [geo insertObject:[self loadTheBlank] atIndex:0];
    }
    if (boilers.count>0) {
        [boilers insertObject:[self loadTheBlank] atIndex:0];
    }
    if (warranties.count>0) {
        [warranties insertObject:[self loadTheBlank] atIndex:0];
    }
    
    if (ductlessMiniSplits.count>0) {
        [ductlessMiniSplits insertObject:[self loadTheBlank] atIndex:0];
    }
    
}

-(void) arraySort {
    
    // NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ord" ascending:YES];
    NSSortDescriptor *manSort = [NSSortDescriptor sortDescriptorWithKey :@"manu" ascending:YES];
    NSSortDescriptor *sortA = [NSSortDescriptor sortDescriptorWithKey:@"finalPrice" ascending:NO];
    
    NSArray *sortDec = @[manSort,sortA];
    
    if (airCon.count>0) {
        airCon = [[airCon sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (heatPump.count>0) {
        heatPump = [[heatPump sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (furn.count>0) {
        furn = [[furn sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (airH.count>0) {
        airH = [[airH sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (geo.count>0) {
        geo = [[geo sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (boilers.count>0) {
        boilers = [[boilers sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (hotwater.count>0) {
        hotwater = [[hotwater sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if(acces.count > 0) {
        acces = [[acces sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (iaq.count > 0) {
        iaq = [[iaq sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if(warranties.count > 0) {
        warranties = [[warranties sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
    if (ductlessMiniSplits.count > 0) {
        ductlessMiniSplits = [[ductlessMiniSplits sortedArrayUsingDescriptors:sortDec] mutableCopy];
    }
}

-(void) sortTypeThrees {
    Item *itm;
    
    for (int xj = 0; xj < typeThrees.count; xj++) {
        itm = typeThrees[xj];
        NSString *opt = itm.optionOne;
        float opty = [itm.optOnePrice floatValue];
        itm.finalOption = opt;
        itm.finalPrice = [NSNumber numberWithFloat:opty];
        [self fillArrays:itm];
    }
    
}

-(void) sortTypeFours {
    Item *itm;
    for (int xj = 0; xj < typeFours.count; xj++) {
        itm = typeFours[xj];
        NSString *opt = itm.optionOne;
        float opty = [itm.optOnePrice floatValue];
        itm.finalOption = opt;
        itm.finalPrice = [NSNumber numberWithFloat:opty];
        [self fillArrays:itm];
    }
}

-(void) fillArrays:(Item *)itm {
    
    if ([itm.type isEqualToString:@"Air Conditioners"]) {
        [airCon addObject:itm];
    } else if ([itm.type isEqualToString:@"Heat Pumps"]) {
        [heatPump addObject:itm];
    } else if ([itm.type isEqualToString:@"Furnaces"]) {
        [furn addObject:itm];
    }else if ([itm.type isEqualToString:@"Air Handlers"]) {
        [airH addObject:itm];
    } else if ([itm.type isEqualToString:@"Geothermal"]) {
        [geo addObject:itm];
    }
    else
        if ([itm.type isEqualToString:@"IAQ"]) {
            int c =0;
            for (Item * ii in iaq) {
                if ([ii.modelName isEqualToString:itm.modelName]) {
                    c++;
                }
            }
            if (![iaq containsObject:itm]&& c==0) {
                [iaq addObject:itm];
            }
        }
        else if ([itm.type isEqualToString:@"Boilers"]) {
            [boilers addObject:itm];
        } else if ([itm.type isEqualToString:@"Hot Water Heaters"]) {
            int c =0;
            for (Item * ii in hotwater) {
                if ([ii.modelName isEqualToString:itm.modelName]) {
                    c++;
                }
            }
            if (c==0) {
                [hotwater addObject:itm];
            }
            
        } else if ([itm.type isEqualToString:@"Accessories"]) {
            
            [acces addObject:itm];
        }
        else if ([itm.type isEqualToString:@"Warranties"]) {
            [warranties addObject:itm];
        }
        else if ([itm.type isEqualToString:@"Ductless Mini Splits"]) {
            [ductlessMiniSplits addObject:itm];
        }
}

-(Item *)loadTheBlank {
    
    for (int x = 0; x < allData.count; x++) {
        Item *itm = allData[x];
        if ([itm.type isEqualToString:@"Blank"]) {
            blank = itm;
        }
        
    }
    
    return blank;
}

#pragma mark - Check Actions
-(float) checkOptionsCoolPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.coolingValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.coolingValue]) {
        return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.coolingValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.coolingValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.coolingValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.coolingValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.coolingValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.coolingValue]) {
        return [itm.optEightPrice floatValue];
    }
    return 0.0f;
}

-(NSString *) checkOptionsCoolOpt:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.coolingValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.coolingValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.coolingValue]) {
        return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.coolingValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.coolingValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.coolingValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.coolingValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.coolingValue]) {
        return itm.optionEight;
    }
    
    return @"None";
}

-(float) checkOptionsHeatPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.heatingValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.heatingValue]) {
        return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.heatingValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.heatingValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.heatingValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.heatingValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.heatingValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.heatingValue]) {
        return [itm.optEightPrice floatValue];
    }
    
    return 0.0f;
}

-(NSString *) checkOptionsHeatOpt:(Item *)itm {
    if ([itm.optionOne isEqualToString:firstOption.heatingValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.heatingValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.heatingValue]) {
        return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.heatingValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.heatingValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.heatingValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.heatingValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.heatingValue]) {
        return itm.optionEight;
    }
    return @"None";
}

-(float) checkOptionsBoilersPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.boilersValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.boilersValue]) {
        return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.boilersValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.boilersValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.boilersValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.boilersValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.boilersValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.boilersValue]) {
        return [itm.optEightPrice floatValue];
    }
    
    return 0.0f;
}

-(NSString *) checkOptionsBoilersOpt:(Item *)itm {
    if ([itm.optionOne isEqualToString:firstOption.boilersValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.boilersValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.boilersValue]) {
        return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.boilersValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.boilersValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.boilersValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.boilersValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.boilersValue]) {
        return itm.optionEight;
    }
    return @"None";
}

-(float) checkOptionsDuctlessPrice:(Item *)itm {
    
    if ([itm.optionOne isEqualToString:firstOption.ductlessValue]) {
        return [itm.optOnePrice floatValue];
    } else if ([itm.optionTwo isEqualToString:firstOption.ductlessValue]) {
        return [itm.optTwoPrice floatValue];
    } else if ([itm.optionThree isEqualToString:firstOption.ductlessValue]) {
        return [itm.optThreePrice floatValue];
    } else if ([itm.optionFour isEqualToString:firstOption.ductlessValue]) {
        return [itm.optFourPrice floatValue];
    }else if ([itm.optionFive isEqualToString:firstOption.ductlessValue]) {
        return [itm.optFivePrice floatValue];
    }else if ([itm.optionSix isEqualToString:firstOption.ductlessValue]) {
        return [itm.optSixPrice floatValue];
    }else if ([itm.optionSeven isEqualToString:firstOption.ductlessValue]) {
        return [itm.optSevenPrice floatValue];
    }else if ([itm.optionEight isEqualToString:firstOption.ductlessValue]) {
        return [itm.optEightPrice floatValue];
    }
    
    return 0.0f;
}

-(NSString *) checkOptionsDuctlessOpt:(Item *)itm {
    if ([itm.optionOne isEqualToString:firstOption.ductlessValue]) {
        return itm.optionOne;
    } else if ([itm.optionTwo isEqualToString:firstOption.ductlessValue]) {
        return itm.optionTwo;
    } else if ([itm.optionThree isEqualToString:firstOption.ductlessValue]) {
        return itm.optionThree;
    } else if ([itm.optionFour isEqualToString:firstOption.ductlessValue]) {
        return itm.optionFour;
    }else if ([itm.optionFive isEqualToString:firstOption.ductlessValue]) {
        return itm.optionFive;
    }else if ([itm.optionSix isEqualToString:firstOption.ductlessValue]) {
        return itm.optionSix;
    }else if ([itm.optionSeven isEqualToString:firstOption.ductlessValue]) {
        return itm.optionSeven;
    }else if ([itm.optionEight isEqualToString:firstOption.ductlessValue]) {
        return itm.optionEight;
    }
    return @"None";
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tapped) {
        tapped = FALSE;
        [sections addObject:[NSNumber numberWithInt:tappedSection]];
    }
    
    if ([sections containsObject:[NSNumber numberWithInt:indexPath.section]]) {
        return 30.0f;
    } else {
        switch (indexPath.section) {
            case 3:
                if (airCon.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 5:
                if (heatPump.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 4:
                if (furn.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 6:
                if (airH.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 7:
                if (geo.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 2:
                if (iaq.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 0:
                if (acces.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 9:
                if (boilers.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            case 8:
                if (hotwater .count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
            case 1:
                if (warranties.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
            case 10:
                if (ductlessMiniSplits.count == 0) {
                    return 30.0f;
                } else {
                    return 158.0f;
                }
                break;
            default:
                return 158.0f;
                break;
                
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return headers.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [headers[section] uppercaseString];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.buyButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    Item *itm = nil;
    
    cell.inCartLabel.hidden = YES;
    
    switch (indexPath.section) {
        case 3:{
            //Air Conditioners
            if (choosedAirCon < airCon.count){
                itm = airCon[choosedAirCon];
                //   [self purchase:itm];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            } else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                cell.clipsToBounds = YES;
            }
            break;
        }
        case 5:{
            //heat Pumps
            if (choosedHeatPump < heatPump.count ){
                itm = heatPump[choosedHeatPump];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 4:{
            //furnaces
            if (choosedFurn < furn.count){
                itm = furn[choosedFurn];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            
            break;
        }
        case 6:{
            //Air Handlers
            if (choosedAirH < airH.count){
                itm = airH[choosedAirH];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 7:{
            //Geothermal
            if (choosedGeo < geo.count){
                itm = geo[choosedGeo];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
            }
            break;
        }
        case 2:{
            //IAQ
            if (choosedIAQ < iaq.count){
                itm = iaq[choosedIAQ];
                cell.buyButton.enabled = YES;
                cell.buyButton.hidden = NO;
                cell.removeButton.hidden = NO;
                cell.removeButton.enabled = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
                
                
            }else {
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                cell.clipsToBounds = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
            }
            break;
        }
        case 0:{
            //Accessories
            if (choosedAcces < acces.count){
                itm = acces[choosedAcces];
                cell.buyButton.enabled = YES;
                cell.buyButton.hidden = NO;
                cell.removeButton.hidden = NO;
                cell.removeButton.enabled = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.clipsToBounds = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
            }
            break;
        }
        case 9:{
            //Boilers
            if (choosedBoilers < boilers.count){
                
                itm = boilers[choosedBoilers];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden =YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
                cell.clipsToBounds = YES;
            }
            break;
        }
        case 8:{
            //Hot Water
            if (choosedHotWater < hotwater.count){
                itm = hotwater[choosedHotWater];
                cell.buyButton.enabled = YES;
                cell.buyButton.hidden = NO;
                cell.removeButton.hidden = NO;
                cell.removeButton.enabled = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
            }else {
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                cell.clipsToBounds = YES;
                cell.inCartLabel.hidden = NO;
                
                int occurrences = 0;
                for(Item *oItem in _cartItems) {
                    occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
                }
                
                cell.inCartLabel.text = [NSString stringWithFormat:@"In Cart: %d", occurrences];
            }
            
            break;
        }
        case 1:{
            //Warranties
            if (choosedWarranties < warranties.count){
                
                itm = warranties[choosedWarranties];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden =YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
                cell.clipsToBounds = YES;
            }
            break;
        }
        case 10:{
            //DuctlessMiniSplits
            if (choosedDuctlessMiniSplits < ductlessMiniSplits.count){
                
                itm = ductlessMiniSplits[choosedDuctlessMiniSplits];
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden = YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
            }else {
                cell.buyButton.enabled = NO;
                cell.buyButton.hidden =YES;
                cell.removeButton.enabled = NO;
                cell.removeButton.hidden = YES;
                
                cell.clipsToBounds = YES;
            }
            break;
        }
        default:
            break;
    }
    
    cell.photo.image = nil;
    cell.manufacturerLabel.text = @"";
    cell.priceLabel.text = @"";
    cell.modelName.text = itm.modelName;
    cell.optionLabel.text =  [NSString stringWithFormat:@"Select Option : %@",itm.finalOption];
    [cell.buyButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchDown];
    [cell.removeButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchDown];
    cell.clipsToBounds = YES;
    
    if (![itm.finalOption isEqualToString:@"None"]) {
      
        Photos *photoObj = (Photos *)itm.image;
        cell.photo.image = [UIImage imageWithData:photoObj.photoData];
        cell.manufacturerLabel.text = itm.manu;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", itm.finalPrice];
        cell.buyButton.tag = indexPath.section;
        cell.removeButton.tag = indexPath.section;
        
        [cell.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchDown];
        [cell.removeButton addTarget:self action:@selector(remButton:) forControlEvents:UIControlEventTouchDown];
    }
    
    return cell;
}

-(void) celltapped:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
    HardTableViewCell *swipedCell = [tableViewX cellForRowAtIndexPath:swipedIndexPath];
    
    if (!swipedCell.tapped) {
        swipedCell.tapped = TRUE;
        tapped = TRUE;
        tappedSection = swipedIndexPath.section;
        [tableViewX reloadData];
        
    } else {
        [sections removeObject:[NSNumber numberWithInt:tappedSection]];
        swipedCell.tapped = FALSE;
        
        [tableViewX reloadData];
        if (swipedIndexPath.section != 6 || swipedIndexPath.section != 7) {
            swipedCell.photo.hidden = NO;
            
            swipedCell.modelName.hidden = NO;
        } else {
            swipedCell.photo.hidden = NO;
            
            swipedCell.modelName.hidden = NO;
            
            swipedCell.buyButton.hidden = NO;
            swipedCell.removeButton.hidden = NO;
            [swipedCell bringSubviewToFront:swipedCell.buyButton];
        }
    }
}

#pragma mark - TableView Helpers

-(void)rl {
    [tableViewX reloadData];
}

-(void) cellSwiped:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
    //   HardTableViewCell *swipedCell = (HardTableViewCell*)[tableViewX cellForRowAtIndexPath:swipedIndexPath];
    BOOL change = FALSE;
    Item *itm;
    
    if (swipedIndexPath.section == 3) {
        
        if (airCon.count > 0 && choosedAirCon < airCon.count-1) {
            itm = airCon[choosedAirCon];
            [self removeTheProd:itm];
            itm=airCon[(choosedAirCon+1)];
            [self purchase:itm];
            choosedAirCon++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 5) {
        if (heatPump.count > 0 && choosedHeatPump < heatPump.count-1) {
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];
            itm=heatPump[(choosedHeatPump+1)];
            [self purchase:itm];
            
            choosedHeatPump++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 4) {
        if (furn.count > 0 && choosedFurn < furn.count-1) {
            itm = furn[choosedFurn];
            [self removeTheProd:itm];
            itm=furn[(choosedFurn+1)];
            [self purchase:itm];
            
            choosedFurn++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 6) {
        if (airH.count >0  && choosedAirH < airH.count -1) {
            itm = airH[choosedAirH];
            [self removeTheProd:itm];
            itm=airH[(choosedAirH+1)];
            [self purchase:itm];
            
            choosedAirH++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 7) {
        if (geo.count > 0 && choosedGeo < geo.count-1 ) {
            itm = geo[choosedGeo];
            [self removeTheProd:itm];
            itm=geo[(choosedGeo+1)];
            [self purchase:itm];
            
            choosedGeo++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 2) {
        
        
        if (iaq.count > 0 && choosedIAQ < iaq.count-1 ) {
            choosedIAQ++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 0) {
        if ( acces.count > 0  && choosedAcces < acces.count-1) {
            choosedAcces++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 9) {
        if ( boilers.count > 0  && choosedBoilers < boilers.count-1) {
            itm = boilers[choosedBoilers];
            [self removeTheProd:itm];
            itm=boilers[(choosedBoilers+1)];
            [self purchase:itm];
            
            choosedBoilers++;
            change = YES;
        }
    }
    if (swipedIndexPath.section == 8) {
        if ( hotwater.count > 0  && choosedHotWater < hotwater.count-1) {
            choosedHotWater++;
            change = YES;
            
        }
    }
    
    if (swipedIndexPath.section == 1) {
        if ( warranties.count > 0  && choosedWarranties < warranties.count-1) {
            itm = warranties[choosedWarranties];
            [self removeTheProd:itm];
            itm= warranties[(choosedWarranties+1)];
            [self purchase:itm];
            
            choosedWarranties++;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 10) {
        if ( ductlessMiniSplits.count > 0  && choosedDuctlessMiniSplits < ductlessMiniSplits.count-1) {
            itm = ductlessMiniSplits[choosedDuctlessMiniSplits];
            [self removeTheProd:itm];
            itm= ductlessMiniSplits[(choosedDuctlessMiniSplits+1)];
            [self purchase:itm];
            
            choosedDuctlessMiniSplits++;
            change = YES;
        }
    }
    
    if (change) {
        
        change = NO;
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:swipedIndexPath.row inSection:swipedIndexPath.section];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [tableViewX reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        [self warn];
    }
    
}

-(void) cellSwipedLeft:(UIGestureRecognizer *)recognizer {
    CGPoint swipeLocation = [recognizer locationInView:tableViewX];
    NSIndexPath *swipedIndexPath = [tableViewX indexPathForRowAtPoint:swipeLocation];
    
    Item *itm;
    BOOL change = FALSE;
    if (swipedIndexPath.section == 3) {
        
        if (choosedAirCon > 0) {
            itm = airCon[choosedAirCon];
            [self removeTheProd:itm];
            itm=airCon[(choosedAirCon-1)];
            [self purchase:itm];
            choosedAirCon--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 5) {
        if (choosedHeatPump > 0) {
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];
            itm=heatPump[(choosedHeatPump-1)];
            [self purchase:itm];
            choosedHeatPump--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 4) {
        if (choosedFurn > 0) {
            itm = furn[choosedFurn];
            [self removeTheProd:itm];
            itm=furn[(choosedFurn-1)];
            [self purchase:itm];
            choosedFurn--;
            change = YES;
        } else {
            [self warn];
        };
    }
    if (swipedIndexPath.section == 6) {
        if (choosedAirH > 0) {
            itm = airH[choosedAirH];
            [self removeTheProd:itm];
            itm=airH[(choosedAirH-1)];
            [self purchase:itm];
            choosedAirH--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 7) {
        if (choosedGeo > 0) {
            itm = geo[choosedGeo];
            [self removeTheProd:itm];
            itm=geo[(choosedGeo-1)];
            [self purchase:itm];
            choosedGeo--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 2) {
        if (choosedIAQ > 0) {
            choosedIAQ--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 0) {
        if (choosedAcces > 0) {
            choosedAcces--;
            change = YES;
        } else {
            [self warn];
        }
    }
    if (swipedIndexPath.section == 9) {
        if ( choosedBoilers > 0) {
            itm = boilers[choosedBoilers];
            [self removeTheProd:itm];
            itm=boilers[(choosedBoilers-1)];
            [self purchase:itm];
            
            choosedBoilers--;
            change = YES;
        } else {
            
        }
        
    }
    if (swipedIndexPath.section == 8) {
        if ( choosedHotWater >0) {
            //            itm = hotwater[choosedHotWater];
            //            [self removeTheProd:itm];
            //            itm= hotwater[(choosedHotWater-1)];
            //            [self purchase:itm];
            choosedHotWater--;
            change = YES;
        } else {
            
        }
    }
    
    if (swipedIndexPath.section == 1) {
        if ( choosedWarranties >0) {
            itm = warranties[choosedWarranties];
            [self removeTheProd:itm];
            itm= warranties[(choosedWarranties-1)];
            [self purchase:itm];
            choosedWarranties--;
            change = YES;
        }
    }
    
    if (swipedIndexPath.section == 10) {
        if ( choosedDuctlessMiniSplits >0) {
            itm = ductlessMiniSplits[choosedDuctlessMiniSplits];
            [self removeTheProd:itm];
            itm= ductlessMiniSplits[(choosedDuctlessMiniSplits-1)];
            [self purchase:itm];
            choosedDuctlessMiniSplits--;
            change = YES;
        }
    }
    
    if (change) {
        
        change = NO;
        
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:swipedIndexPath.row inSection:swipedIndexPath.section];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [tableViewX reloadRowsAtIndexPaths:rowsToReload withRowAnimation:YES];
        //  [self buildQuote];
    } else {
        // [self warn];
    }
    
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isEasy) {
        return self.easyFinancialsData.count;
    }else {
        return self.fastFinancialsData.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = indexPath.item;
    Financials *item;
    if (isEasy) {
        item = self.easyFinancialsData[itemIndex];
    }else {
        item = self.fastFinancialsData[itemIndex];
    }
    MonthsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.monthLabel.text = item.month;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Financials *item;
    if (isEasy) {
        item = self.easyFinancialsData[indexPath.item];
        self.easyMonth = item.month.intValue;
        self.easySelectedIndex = indexPath.item;
    }else {
        item = self.fastFinancialsData[indexPath.item];
        self.fastMonth = item.month.intValue;
        self.fastSelectedIndex = indexPath.item;
    }
    
    secView.hidden = YES;
    [self buildQuote];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95, 50);
}

#pragma mark -

-(void) warn {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"No more products to swipe" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [al show];
}

-(void) buyButton:(id)sender {
    int j = [sender tag];
    
    Item *itm;
    switch (j) {
        case 3:{
            //Air Conditioners
            itm = airCon[choosedAirCon];
            [self purchase:itm];
            break;
        }
        case 5:{
            itm = heatPump[choosedHeatPump];
            [self purchase:itm];
            break;
        }
        case 4:{
            itm = furn[choosedFurn];
            [self purchase:itm];
            break;
        }
        case 6:{
            itm = airH[choosedAirH];
            [self purchase:itm];
            break;
        }
        case 7:{
            //Geothermal
            itm = geo[choosedGeo];
            [self purchase:itm];
            break;
        }
        case 2:{
            //IAQ
            itm = iaq[choosedIAQ];
            [self purchase:itm];
            break;
        }
        case 0:{
            //Accessories
            itm = acces [choosedAcces];
            [self purchase:itm];
            break;
        }
        case 9:{
            //Boilers
            itm = boilers [choosedBoilers];
            [self purchase:itm];
            break;
        }
        case 8:{
            //hotWater
            itm = hotwater [choosedHotWater];
            [self purchase:itm];
            break;
        }
        case 1:{
            //Warranties
            itm = warranties [choosedWarranties];
            [self purchase:itm];
            break;
        }
        case 10:{
            //DuctlessMiniSplits
            itm = ductlessMiniSplits [choosedDuctlessMiniSplits];
            [self purchase:itm];
            break;
        }
            
        default:
            break;
    }
    
}

-(void) remButton:(id)sender {
    int j = [sender tag];
    Item *itm;
    switch (j) {
        case 3:{
            //Air Conditioners
            itm = airCon[choosedAirCon];
            [self removeTheProd:itm];
            break;
        }
        case 5:{
            itm = heatPump[choosedHeatPump];
            [self removeTheProd:itm];
            
            break;
        }
        case 4:{
            itm = furn[choosedFurn];
            [self removeTheProd:itm];
            
            break;
        }
        case 6:{
            itm = airH[choosedAirH];
            [self removeTheProd:itm];
            
            break;
        }
        case 7:{
            //Geothermal
            itm = geo[choosedGeo];
            [self removeTheProd:itm];
            
            break;
        }
        case 2:{
            //IAQ
            itm = iaq[choosedIAQ];
            [self removeTheProd:itm];
            
            break;
        }
        case 0:{
            //Accessories
            itm = acces [choosedAcces];
            [self removeTheProd:itm];
            
            break;
        }
        case 9:{
            //Boilers
            itm = boilers [choosedBoilers];
            [self removeTheProd:itm];
            break;
        }
        case 8:{
            //hotWater
            itm = hotwater [choosedHotWater];
            [self removeTheProd:itm];
            break;
        }
        case 1:{
            //Warranties
            itm = warranties [choosedWarranties];
            [self removeTheProd:itm];
            break;
        }
        case 10:{
            //DuctlessMiniSplits
            itm = ductlessMiniSplits [choosedDuctlessMiniSplits];
            [self removeTheProd:itm];
            break;
        }
            
        default:
            break;
    }
}

-(void) purchase:(Item *)itm {
    
    int occurrences = 0;
    for(Item *oItem in _cartItems) {
        occurrences += ([oItem.modelName isEqual:itm.modelName] ? 1 : 0);
    }
    
    if ([itm.finalOption isEqualToString:@"None"]) {
        
    } else {
        [_cartItems addObject:itm];
    }
    
    isLast = TRUE;
    [self buildQuote];
}

-(void) removeTheProd:(Item *)itm {
    
    Item *del;
    BOOL done = FALSE;
    
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    
    for (int x = 0; x < _cartItems.count; x ++) {
        Item *itemz = _cartItems[x];
        if ([itemz.modelName isEqualToString:itm.modelName] && !done) {
            del = itemz;
            done = TRUE;
            [discardedItems addIndex:x];
            break;
        }
    }
    
    // [_cartItems removeObject:del];
    [_cartItems removeObjectsAtIndexes:discardedItems];
    
    
    if (!done && [itm.typeID intValue] == 3) {
        UIAlertView *alx = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat: @"You need to add %@ before you can remove it!",itm.modelName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alx show];
    }
    
    [self buildQuote];
}

-(void)receiveData:(NSArray *)theRebateData :(NSArray *)purchData {
    if (_cartItems.count == 0) {
        [_cartItems addObjectsFromArray:purchData];
    }
}

-(float) parseTheString:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 1) {
        
        NSString *stringy = strip[1];
        NSMutableString *strippedString = [NSMutableString stringWithCapacity:stringy.length];
        
        NSScanner *scanner = [NSScanner scannerWithString:stringy];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        while ([scanner isAtEnd] == NO) {
            NSString *buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [strippedString appendString:buffer];
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
        
        return [strippedString floatValue];
    } else {
        return [string floatValue];;
    }
}

-(NSString *) parseTheOptionName:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 0) {
        
        return strip[0];
    } else {
        return @"";
    }
}

#pragma mark - Update Labels
-(void) buildQuote {
    totalAmount = 0.0f;
    totalSavings = 0.0f;
    
    for (int jj = 0; jj <_cartItems.count; jj++) {
        Item *itm = _cartItems[jj];
        if ([itm.type isEqualToString:@"TypeTwo"]&&[itm.optionOne floatValue]!=0) {
            totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
        }
        else {
            totalAmount += [itm.finalPrice floatValue];
        }
    }
    
    for (int jj = 0; jj <additemsB.count; jj++) {
        Item *itm = additemsB[jj];
        
        
        if (![_cartItems containsObject:itm]) {    ///object contains additional items prices
            
            if ([itm.type isEqualToString:@"TypeTwo"]&&[itm.optionOne floatValue]!=0)
            {
                totalAmount += [itm.finalPrice floatValue]*[itm.optionOne floatValue];
            }
            else
            {
                totalAmount += [itm.finalPrice floatValue];
            }
        }
    }
    
    for (int jj = 0; jj <rebates.count; jj++) {
        Item *itm = rebates[jj];
        totalSavings += [itm.finalPrice floatValue];
    }
    
    float invest = 0.0;
    
    Financials *easyFinanceObject;
    if (self.easyMonth != -1) {
        easyFinanceObject = [self.easyFinancialsData objectAtIndex:self.easySelectedIndex];
        easyPaymentFactor = easyFinanceObject.value.floatValue;
    }
    
    Financials *fastFinanceObject;
    if (self.fastMonth != -1) {
        fastFinanceObject = [self.fastFinancialsData objectAtIndex:self.fastSelectedIndex];
        
    }
    
    invest = (float)(totalAmount - totalSavings);
    float localInvest = (float)(totalAmount - totalSavings);
    
    [self updateLabels:invest :totalSavings :afterSavings :finacePay :monthlyPay localInvest:localInvest easyFinanceObject:easyFinanceObject fastFinanceObject:fastFinanceObject];
}

-(void) updateLabels:(float)total :(float)totalSave :(float)afterSaving :(float)financeP :(float)month localInvest:(float)localInvest easyFinanceObject:(Financials*)easyFinanceObject fastFinanceObject:(Financials*)fastFinanceObject {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // Some code
    
        totalAmountLabel.text = [NSString stringWithFormat:@"Total Amount\n$%.0f",total];
        totalSavingsLabel.text = [NSString stringWithFormat:@"Total Savings\n$%.0f",totalSave];
        afterSavingsLabel.text = [NSString stringWithFormat:@"After Savings\n$%.0f",afterSaving];
        financeMonthLabel.text = [NSString stringWithFormat:@"0%% Financing\nMonthlyPayment\n$%.0f",financeP];
        monthlyPayment.text = [NSString stringWithFormat:@"Monthly Payment\n$%.0f",month];
        
        NSNumberFormatter *nf = [NSNumberFormatter new];
        nf.numberStyle = NSNumberFormatterDecimalStyle;
        [nf setMaximumFractionDigits:2];
        [nf setMinimumFractionDigits:2];
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [numberFormatter setMaximumFractionDigits:0];
        [numberFormatter setMinimumFractionDigits:0];
        
        lblSystemRebates.text=[NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalSave]]];
        lblInvestemts.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest]]];
        lblInvestmentMonth.text = investDescription;
        if (fastFinanceObject) {
            lblFastPrice.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest / self.fastMonth]]];
            lblFastPercent.text = fastFinanceObject.description1;
        }else {
            lblFastPrice.text = @"0";
            lblFastPercent.text = @"No Financing Selected";
        }
        if (easyFinanceObject) {
            lblEasyPrice.text = [NSString stringWithFormat:@"$%@",[numberFormatter stringFromNumber:[NSNumber numberWithFloat:localInvest * easyPaymentFactor]]];
            if (easyPaymentFactor < 0.0001) {
                lblEasyPercent.text = @"0%";
            }else {
                lblEasyPercent.text = easyFinanceObject.description1;
            }
        }else {
            lblEasyPrice.text = @"0";
            lblEasyPercent.text = @"No Financing Selected";
        }
        [tableViewX reloadData];
    });
    
}

#pragma mark - CartBtn Action
- (IBAction)cartButon:(id)sender {
    [self performSegueWithIdentifier:@"cart" sender:nil];
}

#pragma mark Rebate Button Action
- (IBAction)rebateButton:(id)sender {
    [self performSegueWithIdentifier:@"rebate" sender:self];
}

#pragma mark - IAQ Button(Home icon)
- (IBAction)iaqButton:(id)sender {
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    NSNumber* iaqCurrentStep = [userdefault objectForKey:@"iaqCurrentStep"];
    if (iaqCurrentStep == nil) {
        iaqCurrentStep = [NSNumber numberWithInteger:IAQNone];
    }
    [IAQDataModel sharedIAQDataModel].currentStep = [iaqCurrentStep integerValue];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IAQStoryboard" bundle:nil];
    HealthyHomeSolutionsAgreementVC* healthyHomeSolutionsAgreementVC = [storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeProcessVC"];
    [self.navigationController pushViewController:healthyHomeSolutionsAgreementVC animated:true];
}

#pragma mark - Buttons Actions
- (IBAction)monthBut:(id)sender {
    int mon = [sender tag];
    if (isEasy) {
        self.easyMonth = mon;
        self.fastMonth = -1;
    }else {
        self.fastMonth = mon;
        self.easyMonth = -1;
    }
    secView.hidden = YES;
    [self buildQuote];
}

- (IBAction)doneBut:(id)sender {
    secView.hidden = YES;
}

- (IBAction)finBut:(id)sender {
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
}

- (IBAction)btnFinancing:(id)sender {
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
}

#pragma mark easy, fast, invest click
- (IBAction)easyPayClick:(id)sender {
    isEasy = true;
    [_monthsCollectionView reloadData];
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
    
}
- (IBAction)fastPayClick:(id)sender {
//    [self performSegueWithIdentifier:@"cart" sender:nil];
    isEasy = false;
    [_monthsCollectionView reloadData];
    secView.hidden = NO;
    [self.view bringSubviewToFront:secView];
    
}

- (IBAction)investmentClick:(id)sender {
    [self performSegueWithIdentifier:@"cart" sender:nil];
    
}

#pragma mark - CartBtns Actions
- (IBAction)btncart1:(id)sender {
    [self performSegueWithIdentifier:@"savedCart" sender:self];
}

- (IBAction)btnCart2:(id)sender {
    [self performSegueWithIdentifier:@"savedCart" sender:self];
}

- (IBAction)btnCart3:(id)sender {
    [self performSegueWithIdentifier:@"savedCart" sender:self];
}

#pragma mark - Video and Picture Actions
- (IBAction)videoButtonClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:[NSBundle mainBundle]];
    VideoLibraryVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"VideoLibraryVC"];
    [self.navigationController pushViewController: detail animated: YES];
}

- (IBAction)pictureButtonClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:[NSBundle mainBundle]];
    PictureLibraryVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"PictureLibraryVC"];
    [self.navigationController pushViewController: detail animated: YES];
}

- (IBAction)tcoClicked:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"accessTCOfromAdd2cart"];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:[NSBundle mainBundle]];
    RRQuestionsVC * detail = [storyboard instantiateViewControllerWithIdentifier:@"RRQuestionsVC"];
    [self.navigationController pushViewController: detail animated: YES];
}

#pragma mark - CartViewController Delegates
-(void)editCardSelected {
    self.isEditing = YES;
    
}

-(void)saveCartSelected {
    [self restoreChoosedItems];
}

#pragma mark -
-(void)restoreChoosedItems {
    choosedAirCon = 0;
    choosedHeatPump = 0;
    choosedFurn = 0;
    choosedAirH = 0;
    choosedGeo = 0;
    choosedIAQ = 0;
    choosedAcces = 0;
    choosedBoilers = 0;
    choosedHotWater = 0;
    choosedWarranties = 0;
    choosedDuctlessMiniSplits = 0;
}

-(void)assignChoosedOptionsValues {
    if (_cartItems.count > 0) {
        
        [self restoreChoosedItems];
        for (Item * itm  in _cartItems) {
            
            if ([itm.type isEqualToString:@"Air Conditioners"]) {
                
                for (Item * objItm  in airCon) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedAirCon = (int)[airCon indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Heat Pumps"]) {
                
                for (Item * objItm  in heatPump) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedHeatPump = (int)[heatPump indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Furnaces"]) {
                
                for (Item * objItm  in furn) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedFurn = (int)[furn indexOfObject:objItm];
                    }
                }
                
            }else if ([itm.type isEqualToString:@"Air Handlers"]) {
                
                for (Item * objItm  in airH) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedAirH = (int)[airH indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Geothermal"]) {
                
                for (Item * objItm  in geo) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedGeo = (int)[geo indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"IAQ"]) {
                
                for (Item * objItm  in iaq) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedIAQ = (int)[iaq indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Boilers"]) {
                
                for (Item * objItm  in boilers) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedBoilers = (int)[boilers indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Hot Water Heaters"]) {
                
                for (Item * objItm  in hotwater) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedHotWater = (int)[hotwater indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Accessories"]) {
                
                for (Item * objItm  in acces) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedAcces = (int)[acces indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Warranties"]) {
                
                for (Item * objItm  in warranties) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedWarranties = (int)[warranties indexOfObject:objItm];
                    }
                }
                
            } else if ([itm.type isEqualToString:@"Ductless Mini Splits"]) {
                
                for (Item * objItm  in ductlessMiniSplits) {
                    if ([objItm.modelName isEqualToString:itm.modelName]){
                        choosedDuctlessMiniSplits = (int)[ductlessMiniSplits indexOfObject:objItm];
                    }
                }
                
            }
            
        }
    }else{
        [self restoreChoosedItems];
    }
}

#pragma mark - Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"rebate"]) {
        RebateQuoteTableViewController *rq = segue.destinationViewController;
        rq.managedObjectContext = managedObjectContext;
        rq.purch = _cartItems ;
        rq.delegate = self;
    }
    
    
    if ([segue.identifier isEqualToString:@"cart"]) {
        
        CartViewController *cartView = segue.destinationViewController;
        cartView.delegate = self;
        cartView.managedObjectContext = managedObjectContext;
        NSMutableArray *tt = [[NSMutableArray alloc]initWithArray:_cartItems];
        
        for (int jj = 0; jj <additemsB.count; jj++) {
            Item *itm = additemsB[jj];
            if (![tt containsObject:itm])
                [tt addObject:itm];
        }
        
        NSMutableDictionary * cart = [[NSMutableDictionary alloc]init];
        [cart setObject:tt forKey:@"cartItems"];
        [cart setObject:[NSNumber numberWithInt:self.fastMonth] forKey:@"fastMonth"];
        [cart setObject:[NSNumber numberWithInt:self.easyMonth] forKey:@"easyMonth"];
        [cart setObject:[NSNumber numberWithInt:self.easySelectedIndex] forKey:@"easySelectedIndex"];
        [cart setObject:[NSNumber numberWithInt:self.fastSelectedIndex] forKey:@"fastSelectedIndex"];
        [cart setObject:investDescription forKey:@"investDescription"];
        [cart setObject:rebates forKey:@"cartRebates"];
        [cart setObject:self.fastFinancialsData forKey:@"fastFinancialsData"];
        [cart setObject:self.easyFinancialsData forKey:@"easyFinancialsData"];
        cartView.testerVC = self;
        cartView.isViewingCart = NO;
        
        self.carts = [[NSMutableArray alloc]initWithArray:@[cart]];
        cartView.carts = self.carts;
        [cartView.cartstableView reloadData];
    }
    
    if ([segue.identifier isEqualToString:@"savedCart"]) {
        CartViewController *cartView = segue.destinationViewController;
        cartView.delegate = self;
        cartView.testerVC = self;
        cartView.isViewingCart = YES;
        cartView.managedObjectContext = managedObjectContext;        
        
        self.carts = [[NSMutableArray alloc] initWithArray:self.savedCarts];
        cartView.carts = self.carts;
        [cartView.cartstableView reloadData];
    }
}

#pragma mark - Reset Rebates on Home

-(void)resetRebatesOnHome {
    for (int i = 0; i < 3; i++) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
        NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"currentCart = %d", i];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
        fetchRequest.sortDescriptors = sortDescriptors;
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:cartPredicate];
        
        NSError *fetchingError = nil;
        
        allData = [[NSMutableArray alloc] init];
        [allData addObjectsFromArray:[self.managedObjectContext
                                      executeFetchRequest:fetchRequest error:&fetchingError]];
        
        [self resetAllRebates];
    }
}

-(void)resetAllRebates {
    for (int j = 0; j  < allData.count; j++){
        Item *itm = allData[j];
        if ([itm.type isEqualToString:@"Rebates"]) {
            itm.include = NO;
        }
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
}

@end
