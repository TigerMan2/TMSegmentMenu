//
//  LTSegmentMenu.m
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import "LTSegmentMenu.h"

@interface LTSegmentMenu ()<UIScrollViewDelegate>
{
    CGFloat _currentWidth;
    NSUInteger _currentIndex;
    NSUInteger _oldIndex;
}
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *titleViews;
@property (nonatomic, strong) NSMutableArray *titleViewWidths;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollLine;
@property (nonatomic, strong) LTSegmentStyle *segmentStyle;
@property (nonatomic, weak) id <LTSegmentMenuDelegate> delegate;
@end

@implementation LTSegmentMenu

static CGFloat const xGap = 5.0;
static CGFloat const wGap = 2 * xGap;
static CGFloat const contentSizeXoffset = 20.0;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles segmentStyle:(LTSegmentStyle *)segmentStyle delegate:(id<LTSegmentMenuDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.delegate = delegate;
        self.segmentStyle = segmentStyle;
        [self initValue];
        [self setupSubviews];
        [self setupUI];
    }
    return self;
}

- (void)initValue {
    _currentIndex = 0;
    _oldIndex = 0;
    _currentWidth = self.width;
}

- (void)setupSubviews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollLine];
    [self setupTitles];
}

- (void)setupTitles {
    if (self.titles.count == 0) return;
    
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        LTSegmentTitleView *titleView = [[LTSegmentTitleView alloc] init];
        titleView.tag = index;
        
        titleView.font = self.segmentStyle.titleFont;
        titleView.text = title;
        titleView.textColor = self.segmentStyle.normalTitleColor;
        titleView.imagePosition = self.segmentStyle.imagePosition;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setupTitleView:selectedIndex:)]) {
            [self.delegate setupTitleView:titleView selectedIndex:index];
        }
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelOnClick:)];
        [titleView addGestureRecognizer:tapGes];
        
        CGFloat titleViewWidth = [titleView titleViewWidth];
        
        [self.titleViewWidths addObject:@(titleViewWidth)];
        [self.scrollView addSubview:titleView];
        [self.titleViews addObject:titleView];
        
        index ++;
    }
}

- (void)setupUI {
    
    if (self.titles.count==0) return;
    
    self.scrollView.frame = CGRectMake(0.0, 0.0, self.width, self.height);
    //标题
    [self setupTitleViewsPosition];
    //滚动条
    [self setupScrollLine];
    
    if (self.segmentStyle.isScrollTitle) { // 设置滚动区域
        LTSegmentTitleView *lastTitleView = (LTSegmentTitleView *)self.titleViews.lastObject;
        
        if (lastTitleView) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame) + contentSizeXoffset, 0.0);
        }
    }
}


- (void)setupTitleViewsPosition {
    CGFloat titleX = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleH = self.height - self.segmentStyle.scrollLineHeight;
    if (!self.segmentStyle.scrollTitle) {
        //标题不能滚动 平分
        titleW = self.scrollView.bounds.size.width / self.titles.count;
        NSInteger index = 0;
        for (LTSegmentTitleView *titleView in self.titleViews) {
            titleX = index * titleW;
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            [titleView adjustsubviewsFrame];
            index ++;
        }
    } else {
        NSInteger index = 0;
        CGFloat lastLabelMaxX = self.segmentStyle.titleMargin;
        CGFloat addMargin = 0.0;
        if (self.segmentStyle.isAutoAdjustTitlesWidth) {
            
            float allTitlesWidth = self.segmentStyle.titleMargin;
            for (int i = 0; i<self.titleViewWidths.count; i++) {
                allTitlesWidth = allTitlesWidth + [self.titleViewWidths[i] floatValue] + self.segmentStyle.titleMargin;
            }
            
            
            addMargin = allTitlesWidth < self.scrollView.bounds.size.width ? (self.scrollView.bounds.size.width - allTitlesWidth)/self.titleViewWidths.count : 0 ;
        }
        
        for (LTSegmentTitleView *titleView in self.titleViews) {
            titleW = [self.titleViewWidths[index] floatValue];
            titleX = lastLabelMaxX + addMargin/2;
            
            lastLabelMaxX += (titleW + addMargin + self.segmentStyle.titleMargin);
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            [titleView adjustsubviewsFrame];
            
            index ++;
        }
        
    }
    
    LTSegmentTitleView *currentView = (LTSegmentTitleView *)self.titleViews[_currentIndex];
    if (currentView) {
        /** 设置初始状态的文字 */
        currentView.textColor = self.segmentStyle.selectedTitleColor;
        currentView.selected = YES;
    }
    
}

- (void)setupScrollLine {
    
    LTSegmentTitleView *firstTitleView = self.titleViews[0];
    
    CGFloat coverX = firstTitleView.x;
    CGFloat coverW = firstTitleView.width;
    //滚动条
    if (self.scrollLine) {
        if (self.segmentStyle.isScrollTitle) {
            self.scrollLine.frame = CGRectMake(coverX, self.height - self.segmentStyle.scrollLineHeight, coverW, self.segmentStyle.scrollLineHeight);
        } else {
            if (self.segmentStyle.isAdjustCoverOrLineWidth) {
                coverW = [self.titleViewWidths[_currentIndex] floatValue] + wGap;
                coverX = (firstTitleView.width - coverW) * 0.5;
            }
            self.scrollLine.frame = CGRectMake(coverX, self.height - self.segmentStyle.scrollLineHeight, coverW, self.segmentStyle.scrollLineHeight);
        }
    }
}

#pragma mark - button action
- (void)titleLabelOnClick:(UITapGestureRecognizer *)tapGes {
    LTSegmentTitleView *currentLabel = (LTSegmentTitleView *)tapGes.view;
    
    if (!currentLabel) {
        return;
    }
    
    _currentIndex = currentLabel.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:YES taped:YES];
}

#pragma mark - public helper
- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated taped:(BOOL)taped {
    
    if (_currentIndex == _oldIndex && taped) return;
    
    LTSegmentTitleView *currentTitleView = (LTSegmentTitleView *)self.titleViews[_currentIndex];
    LTSegmentTitleView *oldTitleView = (LTSegmentTitleView *)self.titleViews[_oldIndex];
    
    CGFloat animatedTime = animated ? 0.30 : 0;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:animatedTime animations:^{
        /** 文字选中和未选中更换 */
        oldTitleView.textColor = weakSelf.segmentStyle.normalTitleColor;
        currentTitleView.textColor = weakSelf.segmentStyle.selectedTitleColor;
        /** 标题选中和未选中更换 */
        oldTitleView.selected = NO;
        currentTitleView.selected = YES;
        
        //滚动条
        if (weakSelf.scrollLine) {
            if (weakSelf.segmentStyle.isScrollTitle) {
                weakSelf.scrollLine.x = currentTitleView.x;
                weakSelf.scrollLine.width = currentTitleView.width;
            } else {
                if (weakSelf.segmentStyle.isAdjustCoverOrLineWidth) {
                    CGFloat scrollLineW = [weakSelf.titleViewWidths[self->_currentIndex] floatValue] + wGap;
                    CGFloat scrollLineX = currentTitleView.x + (currentTitleView.width - scrollLineW)*0.5;
                    weakSelf.scrollLine.x = scrollLineX;
                    weakSelf.scrollLine.width = scrollLineW;
                } else {
                    weakSelf.scrollLine.x = currentTitleView.x;
                    weakSelf.scrollLine.width = currentTitleView.width;
                }
            }
        }
    } completion:^(BOOL finished) {
        [self adjustTitleOffsetToCurrentIndex:self->_currentIndex];
    }];
    
    /** 覆盖数据 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:oldTitleView:currentTitleView:oldIndex:currentIndex:)]) {
        [self.delegate segmentView:self oldTitleView:oldTitleView currentTitleView:currentTitleView oldIndex:_oldIndex currentIndex:_currentIndex];
    }
    _oldIndex = _currentIndex;
}

- (void)adjustTitleOffsetToCurrentIndex:(NSInteger)currentIndex {
    _oldIndex = currentIndex;
    int index = 0;
    for (LTSegmentTitleView *titleView in self.titleViews) {
        if (index != currentIndex) {
            titleView.textColor = self.segmentStyle.normalTitleColor;
            titleView.selected = NO;
        } else {
            titleView.textColor = self.segmentStyle.selectedTitleColor;
            titleView.selected = YES;
        }
        
        index ++;
    }
    
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + contentSizeXoffset) {//需要滚动
        LTSegmentTitleView *currentTitleView = (LTSegmentTitleView *)self.titleViews[currentIndex];
        
        CGFloat offSetx = currentTitleView.center.x - _currentWidth * 0.5;
        if (offSetx < 0) {
            offSetx = 0;
        }
        
        CGFloat maxOffSetX = self.scrollView.contentSize.width - _currentWidth;
        if (maxOffSetX < 0) {
            maxOffSetX = 0;
        }
        
        if (offSetx > maxOffSetX) {
            offSetx = maxOffSetX;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];
        
    }
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated taped:NO];
}

- (void)reloadTitlesWithNewTitles:(NSArray *)titles {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _currentIndex = 0;
    _oldIndex = 0;
    self.titleViewWidths = nil;
    self.titleViews = nil;
    self.titles = nil;
    self.titles = [titles copy];
    if (self.titles.count == 0) return;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self setupSubviews];
    [self setupUI];
    [self setSelectedIndex:0 animated:YES];
    
}

#pragma mark - getter
- (UIView *)scrollLine {
    if (!_scrollLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = self.segmentStyle.scrollLineColor;
        _scrollLine = lineView;
    }
    
    return _scrollLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = NO;
        scrollView.scrollsToTop = NO;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (NSMutableArray *)titleViews {
    if (!_titleViews) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

- (NSMutableArray *)titleViewWidths {
    if (!_titleViewWidths) {
        _titleViewWidths = [NSMutableArray array];
    }
    return _titleViewWidths;
}

@end
