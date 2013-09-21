 #import <UIKit/UIKit.h>

@interface GBInfiniteLoopScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views;

- (id)initWithFrame:(CGRect)frame placeholder:(UIView *)placeholder;

- (void)addView:(UIView *)view;

@end