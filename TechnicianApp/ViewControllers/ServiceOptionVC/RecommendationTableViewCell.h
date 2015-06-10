//
//  RecommendationTableViewCell.h
//  Signature
//
//  Created by Andrei Zaharia on 12/15/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceOptionVC.h"

typedef void (^OnOptionSelected)(NSInteger rowIndex, NSInteger itemIndex);
typedef void (^OnPriceSelected)(NSInteger rowIndex, BOOL isDiscounted);

@interface RecommendationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gradientView;
@property (weak, nonatomic) IBOutlet UIButton    *btnResetOption;
@property (weak, nonatomic) IBOutlet UILabel     *lbRecommandationName;
@property (weak, nonatomic) IBOutlet UILabel     *lbSelectOption;

@property (assign, nonatomic) OptionsDisplayType optionsDisplayType;;
@property (assign, nonatomic) BOOL               isEditable;
@property (assign, nonatomic) NSInteger          rowIndex;
@property (assign, nonatomic) BOOL               isDiscounted;
@property (nonatomic, copy) OnOptionSelected     onOptionReset;
@property (nonatomic, copy) OnOptionSelected     onOptionSelected;
@property (nonatomic, copy) OnPriceSelected      onPriceSelected;

- (void)displayServiceOptions:(NSArray *)options;

+ (CGFloat)heightWithData:(id)data;

@end
