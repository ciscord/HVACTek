#import <UIKit/UIKit.h>

@interface NAPickerCell : UITableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          cellWidth:(CGFloat)cellWidth;

+ (CGFloat)cellHeight;

@end
