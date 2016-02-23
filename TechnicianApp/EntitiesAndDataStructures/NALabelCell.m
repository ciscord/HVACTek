#import "NALabelCell.h"

@implementation NALabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)cellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 44)];
        [self addSubview:self.textView];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CGFloat)cellHeight
{
    return 44.f;
}

@end
