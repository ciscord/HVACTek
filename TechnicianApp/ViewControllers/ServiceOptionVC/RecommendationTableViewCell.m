//
//  RecommendationTableViewCell.m
//  Signature
//
//  Created by Andrei Zaharia on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "RecommendationTableViewCell.h"
#import <FrameAccessor/FrameAccessor.h>
#import "PricebookItem.h"

#define kSERVICE_OPTION_HEIGHT 23.0

typedef void (^OnDidRemoveOption)(NSInteger rowIndex);

@interface ServiceOptionTableViewCell : UITableViewCell

@property (nonatomic, copy)             OnDidRemoveOption onRemovedOption;
@property (nonatomic)           NSInteger                 rowIndex;

@end

@implementation ServiceOptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self && ![self.accessoryView isKindOfClass:[UIButton class]]) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setShowsTouchWhenHighlighted:YES];
//        [button setTitle:@"⊖" forState:UIControlStateNormal];
////        [button.titleLabel setFont: [UIFont fontWithName:@"Calibri-Light" size: 14]];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setFrame:CGRectMake(0.0, 0.0, 24, 24)];
//        [button addTarget:self action:@selector(didDeleteServiceOption:) forControlEvents:UIControlEventTouchUpInside];
//        self.accessoryView = button;
//    }
    return self;
}

- (IBAction)didDeleteServiceOption:(id)sender {
    if (self.onRemovedOption) {
        self.onRemovedOption(self.rowIndex);
    }
}

@end

#pragma mark -

@interface RecommendationTableViewCell ()

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray     *serviceOptions;
//@property (weak, nonatomic) IBOutlet UIView      *vSeparator1;
//@property (weak, nonatomic) IBOutlet UIView      *vSeparator2;
//@property (weak, nonatomic) IBOutlet UIView      *vPrice;
//@property (weak, nonatomic) IBOutlet UIButton    *btnPrice1;
//@property (weak, nonatomic) IBOutlet UIButton    *btnPrice2;
//@property (weak, nonatomic) IBOutlet UILabel     *lbESAsaving;
//@property (weak, nonatomic) IBOutlet UILabel     *lb24MonthRates;

@property (nonatomic, strong) NSMutableArray     *serviceOptionsRemoved;

@end

@implementation RecommendationTableViewCell

static NSString *kCELL_IDENTIFIER = @"OptionTableViewCell";

- (void)awakeFromNib {
    // Initialization code
    [self.tableView registerClass:[ServiceOptionTableViewCell class] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    self.lbSelectOption.font = [UIFont fontWithName:@"Calibri-Light" size:22];
    self.btnPrice1.titleLabel.font = [UIFont fontWithName:@"Calibri-Light" size:30];
    self.btnPrice2.titleLabel.font = [UIFont fontWithName:@"Calibri-Light" size:30];
    self.lbESAsaving.font = [UIFont fontWithName:@"Calibri-Light" size:14];
    self.lb24MonthRates.font = [UIFont fontWithName:@"Calibri-Light" size:14];
    
    self.choiceOptionButton.layer.borderWidth = 1.0f;
    self.choiceOptionButton.layer.borderColor = self.choiceOptionButton.titleLabel.textColor.CGColor;
    
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOptionsDisplayType:(OptionsDisplayType)optionsDisplayType {

    _optionsDisplayType = optionsDisplayType;
    self.isEditable     = _isEditable && (_optionsDisplayType == odtEditing);
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
    switch (_optionsDisplayType) {
    case odtNoValues:
    {
        self.vPrice.hidden         = YES;
        self.lbSelectOption.hidden = YES;
        self.btnResetOption.hidden = YES;
        self.tableView.hidden      = YES;
        break;
    }
    case odtReadonlyWithPrice:
    {
        self.vPrice.hidden         = NO;
        self.lbSelectOption.hidden = YES;
        self.btnResetOption.hidden = YES;
        self.tableView.hidden      = NO;
        break;
    }
    case odtCustomerFinalChoice:
    {
        self.vPrice.hidden         = YES;
        self.lbSelectOption.hidden = NO;
        self.btnResetOption.hidden = YES;
        self.tableView.hidden      = NO;
        self.lbSelectOption.font = self.btnPrice1.titleLabel.font;
        break;
    }
    default:
    {
        self.vPrice.hidden         = YES;
        self.lbSelectOption.hidden = !isEditable;
        self.lbSelectOption.hidden = YES;
        self.btnResetOption.hidden = (_rowIndex != 0);
        self.tableView.hidden      = NO;
        break;
    }
    }

    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_optionsDisplayType == odtNoValues) {

        self.lbRecommandationName.center = self.contentView.middlePoint;

    } else {
        self.lbRecommandationName.centerY = self.contentView.middleY;
        self.tableView.y                  = 5;
        self.tableView.height             = self.contentView.height - 8;
        self.btnResetOption.centerY       = self.contentView.middleY;
        self.lbSelectOption.centerY       = self.contentView.middleY;

        self.vPrice.centerY = self.contentView.middleY;
        
        self.choiceImageView.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        self.choiceOptionButton.centerY = self.contentView.middleY;
    }
}


- (IBAction)btnPrice1touch:(UIButton *)sender {
    if (self.onPriceSelected) {
        self.onPriceSelected(self.rowIndex, YES);
    }
}

- (IBAction)btnPrice2touch:(UIButton *)sender {
    if (self.onPriceSelected) {
        self.onPriceSelected(self.rowIndex, NO);
    }
}


- (IBAction)didSelectOption:(id)sender {
    if (self.onOptionReset) {
        self.onOptionReset(0, 0);
    }
}

- (void)displayServiceOptions:(NSArray *)options andRemovedServiceOptions:(NSArray *)removedOptions {

    self.serviceOptions = [NSMutableArray arrayWithArray:options];
    self.serviceOptionsRemoved = [NSMutableArray arrayWithArray:removedOptions];

    if (self.optionsDisplayType == odtReadonlyWithPrice || _optionsDisplayType == odtCustomerFinalChoice) {

        self.vPrice.hidden = (options.count == 0 || (_optionsDisplayType == odtCustomerFinalChoice));

        if (options.count) {
            CGFloat totalPriceNormal = 0;
            CGFloat totalPriceESA = 0;
            for (PricebookItem *p in options) {
                totalPriceNormal += p.amount.floatValue;
                totalPriceESA += p.amountESA.floatValue;
            }
            if (_optionsDisplayType == odtCustomerFinalChoice) {
                
                if (self.isDiscounted) {
//                    CGFloat discountedPrice = totalPrice * 0.85;
                    self.lbSelectOption.text = [self changeCurrencyFormat:totalPriceESA];
                }
                else {
                    self.lbSelectOption.text = [self changeCurrencyFormat:totalPriceNormal];
                }

            } else {

//                CGFloat discountedPrice = totalPrice * 0.85;
                
//                [self.btnPrice1 setTitle:[NSString stringWithFormat:@"$%.2f", totalPriceNormal] forState:UIControlStateNormal];
//                [self.btnPrice2 setTitle:[NSString stringWithFormat:@"$%.2f", totalPriceESA] forState:UIControlStateNormal];
                [self.btnPrice1 setTitle:[self changeCurrencyFormat:totalPriceESA] forState:UIControlStateNormal];
                [self.btnPrice2 setTitle:[self changeCurrencyFormat:totalPriceNormal] forState:UIControlStateNormal];

                self.lb24MonthRates.text = (totalPriceNormal > 1500 ? [NSString stringWithFormat:@"24 payments of $%.0f", totalPriceNormal/24.] : @"");
            }
        }
    }

    [self.tableView reloadData];
}

- (void)didRemoveOptionAtIndex:(NSInteger)itemIndex {
    if (self.onOptionSelected) {
        self.onOptionSelected(self.rowIndex, itemIndex+1);
    }
}



#pragma mark - OptionsBtn Action
- (IBAction)optionsBtnClicked:(UIButton *)sender {
    if (self.optionButtonSelected) {
        self.optionButtonSelected(self.rowIndex);
    }
}


#pragma mark - UITableViewDelegate & DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSERVICE_OPTION_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ///return [self.serviceOptions count] - 1;
    ///return [self.serviceOptionsUpdated count] - 1;
    
    if ([self.serviceOptions count] == 0){
        return 0;
    }else{
        return [self.serviceOptionsRemoved count] - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //__weak RecommendationTableViewCell *weakSelf = self;

    ServiceOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    ///PricebookItem                  *p    = self.serviceOptions[indexPath.row+1];
    PricebookItem                  *p    = self.serviceOptionsRemoved[indexPath.row+1];
    
    cell.accessoryView.hidden = !self.isEditable || p.isMain;
    
    
    if (![self.serviceOptions containsObject:p]){
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:p.name attributes:attributes];
        cell.textLabel.attributedText = attrText;
        
    }else{
        if (cell.textLabel.attributedText){
            cell.textLabel.attributedText = nil;
        }
        cell.textLabel.text = p.name;
    }
    
    ///cell.textLabel.text = p.name;
    cell.textLabel.font       = [UIFont fontWithName:@"Calibri-Light" size:17];
    ///cell.accessoryView.hidden = !self.isEditable || p.isMain;
    cell.rowIndex             = indexPath.row;
    
    ///cell.rowIndex = [self.serviceOptions indexOfObject:p];
//    [cell setOnRemovedOption:^(NSInteger rowIndex) {
//         [weakSelf didRemoveOptionAtIndex:rowIndex];
//     }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSERVICE_OPTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PricebookItem *p          = self.serviceOptions.firstObject;
    UILabel   *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 0.0, 0.0, 0.0)];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    titleLabel.font             = [UIFont fontWithName:@"Calibri-Light" size:17];
    titleLabel.text             = p.name;


    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLabel];
    return headerView;
}

#pragma mark -

+ (CGFloat)heightWithData:(NSArray *)data {
    CGFloat height = 0.0;
    if ([data isKindOfClass:[NSArray class]]) {

        height = kSERVICE_OPTION_HEIGHT * [data count];
        if (height > kSERVICE_OPTION_HEIGHT * 10) {
            height = kSERVICE_OPTION_HEIGHT * 10;
        }
    }

    return MAX(130.0, height);
}

#pragma mark - Currency String

- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithFloat:number]];
}

@end
