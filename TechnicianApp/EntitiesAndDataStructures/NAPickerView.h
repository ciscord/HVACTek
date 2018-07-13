#import <UIKit/UIKit.h>
#import "NALabelCell.h"
#import "HvakTekColorScheme.h"

@protocol NAPickerViewDelegate <NSObject>

typedef void (^NACellConfigureBlock)(id, id);
typedef void (^NACellHighlightConfigureBlock)(id);
typedef void (^NACellUnHighlightConfigureBlock)(id);

- (void)didSelectedAtIndexDel:(NSInteger)index;

@end

@interface NAPickerView : UIView

@property (weak, nonatomic) id delegate;
@property (assign, nonatomic) BOOL infiniteScrolling;
@property (assign, nonatomic) BOOL onSound;
@property (assign, nonatomic) BOOL showOverlay;


@property (copy, nonatomic) NACellConfigureBlock configureBlock;
@property (copy, nonatomic) NACellHighlightConfigureBlock highlightBlock;
@property (copy, nonatomic) NACellUnHighlightConfigureBlock unhighlightBlock;

// backgroud color
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign ,nonatomic) NSInteger selectedIndex;


- (id)initWithFrame:(CGRect)frame
           andItems:(NSArray *)items
   andCellClassName:(NSString *)className
        andDelegate:(id)delegate;

- (id)initWithFrame:(CGRect)frame
           andItems:(NSArray *)items
        andDelegate:(id)delegate;

- (void)setIndex:(NSInteger)index;
- (void)setIndex:(NSInteger)index animated:(BOOL)animated;
@end
