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

@property (nonatomic, strong) NSMutableArray     *serviceOptionsRemoved;

@end

@implementation RecommendationTableViewCell

static NSString *kCELL_IDENTIFIER = @"OptionTableViewCell";

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.tableView registerClass:[ServiceOptionTableViewCell class] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    self.lbSelectOption.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    self.btnPrice1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    self.btnPrice2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    self.lbESAsaving.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.lb24MonthRates.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.financingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    [self configureColorScheme];

    
    [self.tableView reloadData];
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    
    self.choiceOptionButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.choiceOptionButton setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateNormal];
    
    self.gradientView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
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
        self.choiceOptionButton.hidden = YES;
        self.tableView.hidden      = YES;
        break;
    }
    case odtReadonlyWithPrice:
    {
        self.vPrice.hidden         = NO;
        self.lbSelectOption.hidden = YES;
        self.btnResetOption.hidden = YES;
        self.choiceOptionButton.hidden = YES;
        self.tableView.hidden      = NO;
        break;
    }
    case odtCustomerFinalChoice:
    {
        self.vPrice.hidden         = YES;
        self.lbSelectOption.hidden = NO;
        self.btnResetOption.hidden = YES;
        self.choiceOptionButton.hidden = YES;
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
        self.choiceOptionButton.hidden = NO;
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

        if (removedOptions.count) {
            CGFloat totalPriceNormal = 0;
            CGFloat totalPriceESA = 0;
            for (PricebookItem *p in removedOptions) {
                
                int totalQuantity = 1;
                if ([p.quantity intValue] > 1)
                    totalQuantity = [p.quantity intValue];
                
                
                totalPriceNormal += p.amount.floatValue * totalQuantity;//this is 0.85 amount
                
                totalPriceESA += p.amountESA.floatValue * totalQuantity;
            }
            
            if (_optionsDisplayType == odtCustomerFinalChoice) {
                
                if (self.isDiscounted) {
                    self.lbSelectOption.text = [self changeCurrencyFormat:totalPriceESA];
                }
                else {
                    self.lbSelectOption.text = [self changeCurrencyFormat:totalPriceNormal];
                }

            } else {
                [self.btnPrice1 setTitle:[self changeCurrencyFormat:totalPriceESA] forState:UIControlStateNormal];
                [self.btnPrice2 setTitle:[self changeCurrencyFormat:ceil(totalPriceNormal)] forState:UIControlStateNormal];
                
                if (totalPriceESA > 1000) {
                    self.lb24MonthRates.text = [NSString stringWithFormat:@"24 payments of $%d", (int)(totalPriceNormal/24.)];
                }else{
                    self.lb24MonthRates.text = [NSString stringWithFormat:@"For 0%% Financing"];
                    self.financingLabel.text = [NSString stringWithFormat:@"Does Not Qualify"];
                }
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
    [cell setBackgroundColor:[UIColor cs_getColorWithProperty:kColorPrimary0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSERVICE_OPTION_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.optionsDisplayType == odtReadonlyWithPrice) {
        return [self.serviceOptionsRemoved count];;
    }else{
        return [self.serviceOptions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ServiceOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    PricebookItem *pOptions    = self.serviceOptions[indexPath.row];
    cell.textLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    if (self.optionsDisplayType == odtReadonlyWithPrice) {
        PricebookItem *pRemoved    = self.serviceOptionsRemoved[indexPath.row];
        if (cell.textLabel.attributedText){
            cell.textLabel.attributedText = nil;
        }
        
        NSString * serviceString;
        if ([pRemoved.quantity intValue] > 1) {
            serviceString = [NSString stringWithFormat:@"(%@) ",pRemoved.quantity];
        }else{
            serviceString = @"";
        }
        cell.textLabel.text = [serviceString stringByAppendingString:pRemoved.name];
        
        
    }else{
        
        NSString * serviceString;
        if ([pOptions.quantity intValue] > 1) {
            serviceString = [NSString stringWithFormat:@"(%@) ",pOptions.quantity];
        }else{
            serviceString = @"";
        }
        NSString * nameString = [serviceString stringByAppendingString:pOptions.name];
        
        
        if (![self.serviceOptionsRemoved containsObject:pOptions]){
            
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
            cell.textLabel.attributedText = attrText;
            
        }else{
            if (cell.textLabel.attributedText){
                cell.textLabel.attributedText = nil;
            }
            cell.textLabel.text = nameString;
        }
        
    }
    
    cell.textLabel.font       = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.rowIndex             = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PricebookItem *p          = self.serviceOptions.firstObject;
    UILabel   *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 0.0, 0.0, 0.0)];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    titleLabel.font             = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    titleLabel.text             = p.name;


    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];
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

- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithInt:number]];
}

@end
