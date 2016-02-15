

#import <UIKit/UIKit.h>

@interface THProgressView : UIView

@property (nonatomic, strong) UIColor* progressTintColor;
@property (nonatomic, strong) UIColor* borderTintColor;
@property (nonatomic, strong) UIColor* progressBackgroundColor;
@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end