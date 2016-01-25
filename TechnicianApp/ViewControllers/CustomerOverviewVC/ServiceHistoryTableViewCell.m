//
//  ServiceHistoryTableViewCell.m
//  Signature
//
//  Created by Iurie Manea on 3/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ServiceHistoryTableViewCell.h"
#import "DataLoader.h"
#import "SServiceHistory.h"

@interface ServiceHistoryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDateValue;
@property (weak, nonatomic) IBOutlet UILabel *lbAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbAmountValue;
@property (weak, nonatomic) IBOutlet UILabel *lbJobInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lbWorkDone;

@end

@implementation ServiceHistoryTableViewCell

static UIFont *boldSystemFont;

+(CGFloat)heightForData:(SServiceHistory*)data andMaxWidth:(CGFloat)maxWidth {
    
    static ServiceHistoryTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = (ServiceHistoryTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"ServiceHistoryTableViewCell" owner:nil options:nil] firstObject];
    });
    
    [sizingCell displayData: data];
    
    return [sizingCell calculateHeightForConfiguredSizingCellWithMaxWidth: maxWidth];
}

- (CGFloat)calculateHeightForConfiguredSizingCellWithMaxWidth: (CGFloat) width {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.bounds = CGRectMake(0.0f, 0.0f, width, CGRectGetHeight(self.bounds));
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(void)displayData:(SServiceHistory*)data {
    
    self.lbDateValue.text = data.date;
    self.lbAmountValue.text = data.amount;
    
    NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc] initWithString:@"Job Instruction: " attributes:@{NSFontAttributeName : boldSystemFont}];
    NSMutableAttributedString *s2;
    if (data.instructions.length) {
        s2 = [[NSMutableAttributedString alloc] initWithString:data.instructions attributes:@{NSFontAttributeName : s_Calibri14}];
        [s1 appendAttributedString:s2];
    }

    self.lbJobInstructions.attributedText = s1;
    
    s1 = [[NSMutableAttributedString alloc] initWithString:@"Work Done: " attributes:@{NSFontAttributeName : boldSystemFont}];

    if (data.workDone.length) {
        s2 = [[NSMutableAttributedString alloc] initWithString:data.workDone attributes:@{NSFontAttributeName : s_Calibri14}];
        [s1 appendAttributedString:s2];
    }
    self.lbWorkDone.attributedText = s1;
    
    [self setNeedsLayout];
}

- (void)awakeFromNib {
    // Initialization code
    if (!s_CalibriLight13) {
        s_CalibriLight13 = [UIFont fontWithName:@"Calibri-Light" size:13];
    }
    
    if (!s_Calibri14) {
        s_Calibri14 = [UIFont fontWithName:@"Calibri" size:14];
    }
    
    if (!boldSystemFont) {
        boldSystemFont = [UIFont boldSystemFontOfSize:13];
    }
    
    self.lbDate.font = boldSystemFont;
    self.lbAmount.font = boldSystemFont;
    
    [self configureColorScheme];
    
    
//    self.lbDateValue.font = s_Calibri14;
//    self.lbAmountValue.font = s_Calibri14;
//    self.lbJobInstructions.font = s_Calibri14;
//    self.lbWorkDone.font = s_Calibri14;
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.lbDate.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbAmount.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbDateValue.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbAmountValue.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbJobInstructions.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbWorkDone.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
