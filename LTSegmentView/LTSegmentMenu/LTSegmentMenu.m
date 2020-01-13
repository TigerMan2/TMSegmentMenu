//
//  LTSegmentMenu.m
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import "LTSegmentMenu.h"
#import "LTScrollView.h"
#import "UIView+LTFrame.h"

#define kLTSegmentCoverMarginX 5
#define kLTSegmentCoverMarginW 10

@interface LTSegmentMenu ()
/// line指示器
@property (nonatomic, strong) UIView *lineView;
/// 蒙层
@property (nonatomic, strong) UIView *converView;
/// ScrollView
@property (nonatomic, strong) LTScrollView *scrollView;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 配置信息
@property (nonatomic, strong) LTSegmentStyle *segmentStyle;
/// 代理
@property (nonatomic, weak) id <LTSegmentMenuDelegate> delegate;
/// 上次index
@property (nonatomic, assign) NSInteger lastIndex;
/// 当前index
@property (nonatomic, assign) NSInteger currentIndex;
/// items
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArrayM;
/// item宽度
@property (nonatomic, strong) NSMutableArray *itemsWidthArrayM;

@end

@implementation LTSegmentMenu

#pragma mark  Init
+ (instancetype)menuViewWithFrame:(CGRect)frame
                       titles:(NSMutableArray *)titles
                 segmentStyle:(LTSegmentStyle *)segmentStyle
                     delegate:(id<LTSegmentMenuDelegate>)delegate
                 currentIndex:(NSInteger)currentIndex
{
    frame.size.height = segmentStyle.menuHeight;
    frame.size.width = segmentStyle.menuWidth;
    
    LTSegmentMenu *menu = [[LTSegmentMenu alloc] initWithFrame:frame];
    menu.titles = titles;
    menu.segmentStyle = segmentStyle;
    menu.delegate = delegate;
    menu.currentIndex = currentIndex;
    menu.itemsArrayM = @[].mutableCopy;
    menu.itemsWidthArrayM = @[].mutableCopy;
    [menu setupSubviews];
    return menu;
}

#pragma mark  Private
- (void)setupSubviews {
    self.backgroundColor = self.segmentStyle.scrollViewBackgroundColor;
    [self setupItems];
    [self setupOtherViews];
}

- (void)setupItems {
    if (self.segmentStyle.buttonArray.count > 0 && self.titles.count == self.segmentStyle.buttonArray.count) {
        [self.segmentStyle.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull itemButton, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setupButton:itemButton title:self.titles[idx] idx:idx];
        }];
    } else {
        [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self setupButton:itemButton title:title idx:idx];
        }];
    }
}

- (void)setupButton:(UIButton *)itemButton title:(NSString *)title idx:(NSInteger)idx {
    itemButton.titleLabel.font = self.segmentStyle.selectedItemFont;
    [itemButton setTitleColor:self.segmentStyle.normalItemColor forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    itemButton.tag = idx;
    [itemButton addTarget:self action:@selector(itemButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton sizeToFit];
    [self.itemsWidthArrayM addObject:@(itemButton.width)];
    [self.itemsArrayM addObject:itemButton];
    [self.scrollView addSubview:itemButton];
}

- (void)setupOtherViews {
    self.scrollView.frame = CGRectMake(0, 0, self.segmentStyle.showAddButton ? self.width - self.height : self.width, self.height);
    [self addSubview:self.scrollView];
    if (self.segmentStyle.showAddButton) {
        self.addButton.frame = CGRectMake(0, 0, self.width - self.height, self.height);
        [self addSubview:self.addButton];
    }
    
    /// item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.height - self.segmentStyle.lineHeight;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            itemX += self.segmentStyle.itemLeftAndRightMargin;
        } else {
            itemX += self.segmentStyle.itemMargin + [self.itemsWidthArrayM[idx - 1] floatValue];
        }
        obj.frame = CGRectMake(itemX, itemY, [self.itemsWidthArrayM[idx] floatValue], itemH);
    }];
    
    CGFloat scrollSizeWidth = self.segmentStyle.itemLeftAndRightMargin + CGRectGetMaxX([self.itemsArrayM lastObject].frame);
    if (scrollSizeWidth < self.scrollView.width) {
        // 未超出宽度
        itemX = 0;
        itemY = 0;
        itemW = 0;
        CGFloat leftMargin = 0;
        for (NSNumber *width in self.itemsWidthArrayM) {
            leftMargin += [width floatValue];
        }
        
        leftMargin = (self.scrollView.width - leftMargin - self.segmentStyle.itemMargin * (self.itemsArrayM.count - 1)) * 0.5;
        
        if (self.segmentStyle.aligmentModeCenter && leftMargin >= 0) {
            // 居中且剩余间距
            [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    itemX += leftMargin;
                } else {
                    itemX += [self.itemsWidthArrayM[idx - 1] floatValue] + self.segmentStyle.itemMargin;
                }
                obj.frame = CGRectMake(itemX, itemY, [self.itemsWidthArrayM[idx] floatValue], itemH);
            }];
            
            self.scrollView.contentSize = CGSizeMake(leftMargin + CGRectGetMaxX([self.itemsArrayM lastObject].frame), self.scrollView.height);
            
        } else {
            if (!self.segmentStyle.scrollMenu) {
                // 不能滚动则平分
                [self.itemsArrayM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    itemW = self.scrollView.width / self.itemsArrayM.count;
                    itemX = itemW * idx;
                    obj.frame = CGRectMake(itemX, itemY, itemW, itemH);
                }];
                
                self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.itemsArrayM lastObject].frame), self.scrollView.height);
            } else {
                self.scrollView.contentSize = CGSizeMake(scrollSizeWidth, self.scrollView.height);
            }
        }
    } else {
        // 超出scrollView宽度
        self.scrollView.contentSize = CGSizeMake(scrollSizeWidth, self.scrollView.height);
    }
    
    CGFloat lineX = [(UIButton *)[self.itemsArrayM firstObject] x];
    CGFloat lineY = self.scrollView.height - self.segmentStyle.lineHeight;
    CGFloat lineW = [(UIButton *)[self.itemsArrayM firstObject] width];
    CGFloat lineH = self.segmentStyle.lineHeight;
    
    ///处理Line宽度等于字体宽度
    if (!self.segmentStyle.scrollMenu &&
        !self.segmentStyle.aligmentModeCenter &&
        self.segmentStyle.lineWidthEqualFontWidth) {
        lineX = [(UIButton *)[self.itemsArrayM firstObject] x] + ([(UIButton *)[self.itemsArrayM firstObject] width] - ([[self.itemsWidthArrayM firstObject] floatValue])) / 2;
        lineW = [[self.itemsWidthArrayM firstObject] floatValue];
    }
    
    /// scrollLine
    if (self.segmentStyle.showScrollLine) {
        self.lineView.frame = CGRectMake(lineX - self.segmentStyle.lineLeftAndRightAddWidth + self.segmentStyle.lineLeftAndRightMargin, lineY - self.segmentStyle.lineBottomMargin, lineW + self.segmentStyle.lineLeftAndRightAddWidth * 2 - self.segmentStyle.lineLeftAndRightMargin * 2, lineH);
        self.lineView.layer.cornerRadius = self.segmentStyle.lineCorner;
        [self.scrollView addSubview:self.lineView];
    }
    
    ///conver
    if (self.segmentStyle.showConver) {
        self.converView.frame = CGRectMake(lineX - kLTSegmentCoverMarginX, (self.scrollView.height - self.segmentStyle.converHeight - self.segmentStyle.lineHeight) * 0.5, lineW + kLTSegmentCoverMarginW, self.segmentStyle.converHeight);
        [self.scrollView insertSubview:self.converView atIndex:0];
    }
    
    ///bottomLine
    if (self.segmentStyle.showBottomLine) {
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = self.segmentStyle.bottomLineColor;
        self.bottomLine.frame = CGRectMake(self.segmentStyle.bottomLineLeftAndRightMargin, self.height - self.segmentStyle.bottomLineHeight, self.width - self.segmentStyle.bottomLineLeftAndRightMargin * 2, self.segmentStyle.bottomLineHeight);
        self.bottomLine.layer.cornerRadius = self.segmentStyle.bottomLineCorner;
        [self insertSubview:self.bottomLine atIndex:0];
    }
    
    if (self.segmentStyle.itemMaxScale > 1) {
        ((UIButton *)self.itemsArrayM[self.currentIndex]).transform = CGAffineTransformMakeScale(self.segmentStyle.itemMaxScale, self.segmentStyle.itemMaxScale);
    }
    [self setDefaultTheme];
    [self selectedItemIndex:self.currentIndex animated:NO];
}

- (void)setDefaultTheme {
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    // 缩放
    if (self.segmentStyle.itemMaxScale > 1) {
        currentButton.transform = CGAffineTransformMakeScale(self.segmentStyle.itemMaxScale, self.segmentStyle.itemMaxScale);
    }
    
    //颜色
    currentButton.selected = YES;
    [currentButton setTitleColor:self.segmentStyle.selectedItemColor forState:UIControlStateNormal];
    [currentButton.titleLabel setFont:self.segmentStyle.selectedItemFont];
    
    //线条
    if (self.segmentStyle.showScrollLine) {
        self.lineView.x = currentButton.x - self.segmentStyle.lineLeftAndRightAddWidth + self.segmentStyle.lineLeftAndRightMargin;
        self.lineView.width = currentButton.width + self.segmentStyle.lineLeftAndRightAddWidth * 2 - self.segmentStyle.lineLeftAndRightMargin * 2;
        //处理Line宽度等于字体宽度
        if (!self.segmentStyle.scrollMenu &&
            !self.segmentStyle.aligmentModeCenter &&
            self.segmentStyle.lineWidthEqualFontWidth) {
            self.lineView.x = currentButton.x - ([currentButton width] - [self.itemsWidthArrayM[currentButton.tag] floatValue]) / 2 - self.segmentStyle.lineLeftAndRightAddWidth;
            self.lineView.width = [self.itemsWidthArrayM[currentButton.tag] floatValue] + self.segmentStyle.lineLeftAndRightAddWidth * 2;
        }
    }
    
    //遮盖
    if (self.segmentStyle.showConver) {
        self.converView.x = currentButton.x - kLTSegmentCoverMarginX;
        self.converView.width = currentButton.width + kLTSegmentCoverMarginW;
        //处理Conver宽度等于字体宽度
        if (!self.segmentStyle.scrollMenu &&
            !self.segmentStyle.aligmentModeCenter &&
            self.segmentStyle.lineWidthEqualFontWidth) {
            self.converView.x = currentButton.x + ([currentButton width] - [self.itemsWidthArrayM[currentButton.tag] floatValue]) / 2 - kLTSegmentCoverMarginX;
            self.converView.width = [self.itemsWidthArrayM[currentButton.tag] floatValue] + kLTSegmentCoverMarginW;
        }
    }
    self.lastIndex = self.currentIndex;
}

- (void)adjustItemAnimate:(BOOL)animated {
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        //缩放
        if (self.segmentStyle.itemMaxScale > 1) {
            lastButton.transform = CGAffineTransformMakeScale(1, 1);
            currentButton.transform = CGAffineTransformMakeScale(self.segmentStyle.itemMaxScale, self.segmentStyle.itemMaxScale);
        }
        //颜色
        lastButton.selected = NO;
        currentButton.selected = YES;
        [lastButton setTitleColor:self.segmentStyle.normalItemColor forState:UIControlStateNormal];
        [currentButton setTitleColor:self.segmentStyle.selectedItemColor forState:UIControlStateNormal];
        lastButton.titleLabel.font = self.segmentStyle.itemFont;
        currentButton.titleLabel.font = self.segmentStyle.selectedItemFont;
        
        //线条
        if (self.segmentStyle.showScrollLine) {
            self.lineView.x = currentButton.x - self.segmentStyle.lineLeftAndRightAddWidth + self.segmentStyle.lineLeftAndRightMargin;
            self.lineView.width = currentButton.width + self.segmentStyle.lineLeftAndRightAddWidth * 2 - self.segmentStyle.lineLeftAndRightMargin * 2;
            //处理Line宽度等于字体宽度
            if (!self.segmentStyle.scrollMenu &&
                !self.segmentStyle.aligmentModeCenter &&
                self.segmentStyle.lineWidthEqualFontWidth) {
                self.lineView.x = currentButton.x + ([currentButton width] - [self.itemsWidthArrayM[currentButton.tag] floatValue]) / 2 - self.segmentStyle.lineLeftAndRightAddWidth;
                self.lineView.width = [self.itemsWidthArrayM[currentButton.tag] floatValue] + self.segmentStyle.lineLeftAndRightAddWidth * 2;
            }
        }
        
        //遮盖
        if (self.segmentStyle.showConver) {
            self.converView.x = currentButton.x - kLTSegmentCoverMarginX;
            self.converView.width = currentButton.width + kLTSegmentCoverMarginW;
            //处理Conver宽度等于字体宽度
            if (!self.segmentStyle.scrollMenu &&
                !self.segmentStyle.aligmentModeCenter &&
                self.segmentStyle.lineWidthEqualFontWidth) {
                self.converView.x = currentButton.x + ([currentButton width] - [self.itemsWidthArrayM[currentButton.tag] floatValue]) / 2 - kLTSegmentCoverMarginX;
                self.converView.width = [self.itemsWidthArrayM[currentButton.tag] floatValue] + kLTSegmentCoverMarginW;
            }
        }
        self.lastIndex = self.currentIndex;
    } completion:^(BOOL finished) {
        [self adjustItemPositionWidthCurrentIndex:self.currentIndex];
    }];
}

#pragma mark  public
- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (index < 0 || index > self.itemsArrayM.count - 1) return;
    if (title.length <= 0) return;
    [self reloadView];
}

- (void)updateTitles:(NSArray *)titles {
    if (titles.count != self.itemsArrayM.count) return;
    [self reloadView];
}

- (void)adjustItemPositionWidthCurrentIndex:(NSInteger)index {
    if (self.scrollView.contentSize.width != self.scrollView.width + 20) {
        UIButton *curButton = self.itemsArrayM[index];
        CGFloat offset = curButton.center.x - self.scrollView.width * 0.5;
        offset = offset > 0 ? offset : 0;
        CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.width;
        maxOffset = maxOffset > 0 ? maxOffset : 0;
        offset = offset > maxOffset ? maxOffset : offset;
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

- (void)adjustItemWidthProgress:(CGFloat)progress
                      lastIndex:(NSInteger)lastIndex
                   currentIndex:(NSInteger)currentIndex {
    self.lastIndex = lastIndex;
    self.currentIndex = currentIndex;
    if (lastIndex == currentIndex) return;
    
    UIButton *lastButton = self.itemsArrayM[self.lastIndex];
    UIButton *currentButton = self.itemsArrayM[self.currentIndex];
    
    //缩放
    if (self.segmentStyle.itemMaxScale > 1) {
        CGFloat scaleN = self.segmentStyle.itemMaxScale - self.segmentStyle.deltaScale * progress;
        CGFloat scaleS = 1 + self.segmentStyle.deltaScale * progress;
        lastButton.transform = CGAffineTransformMakeScale(scaleN, scaleN);
        currentButton.transform = CGAffineTransformMakeScale(scaleS, scaleS);
    }
    
    //颜色渐变
    if (self.segmentStyle.showGradientColor) {
        [self.segmentStyle setRGBWithProgress:progress];
        UIColor *norColor = [UIColor colorWithRed:self.segmentStyle.deltaNorR green:self.segmentStyle.deltaNorG blue:self.segmentStyle.deltaNorB alpha:1];
        UIColor *selColor = [UIColor colorWithRed:self.segmentStyle.deltaSelR green:self.segmentStyle.deltaSelG blue:self.segmentStyle.deltaSelB alpha:1];
        [lastButton setTitleColor:norColor forState:UIControlStateNormal];
        [currentButton setTitleColor:selColor forState:UIControlStateNormal];
    } else {
        if (progress > 0.5) {
            lastButton.selected = NO;
            currentButton.selected = YES;
            [lastButton setTitleColor:self.segmentStyle.normalItemColor forState:UIControlStateNormal];
            [currentButton setTitleColor:self.segmentStyle.selectedItemColor forState:UIControlStateNormal];
            lastButton.titleLabel.font = self.segmentStyle.itemFont;
            currentButton.titleLabel.font = self.segmentStyle.selectedItemFont;
        } else if (progress < 0.5 && progress > 0) {
            lastButton.selected = YES;
            currentButton.selected = NO;
            [lastButton setTitleColor:self.segmentStyle.selectedItemColor forState:UIControlStateNormal];
            [currentButton setTitleColor:self.segmentStyle.normalItemColor forState:UIControlStateNormal];
            lastButton.titleLabel.font = self.segmentStyle.selectedItemFont;
            currentButton.titleLabel.font = self.segmentStyle.itemFont;
        }
    }
    
    if (progress > 0.5) {
        lastButton.titleLabel.font = self.segmentStyle.itemFont;
        currentButton.titleLabel.font = self.segmentStyle.selectedItemFont;
    } else if (progress < 0.5 && progress > 0) {
        lastButton.titleLabel.font = self.segmentStyle.selectedItemFont;
        currentButton.titleLabel.font = self.segmentStyle.itemFont;
    }
    
    CGFloat xD = 0;
    CGFloat wD = 0;
    if (!self.segmentStyle.scrollMenu &&
        !self.segmentStyle.aligmentModeCenter &&
        self.segmentStyle.lineWidthEqualFontWidth) {
        xD = currentButton.titleLabel.x + currentButton.x - (lastButton.titleLabel.x + lastButton.x);
        wD = currentButton.titleLabel.width - lastButton.titleLabel.width;
    } else {
        xD = currentButton.x - lastButton.x;
        wD = currentButton.width - lastButton.width;
    }
    
    //线条
    if (self.segmentStyle.showScrollLine) {
        ///处理Line宽度等于字体宽度
        if (!self.segmentStyle.scrollMenu &&
            !self.segmentStyle.aligmentModeCenter &&
            self.segmentStyle.lineWidthEqualFontWidth) {
            self.lineView.x = lastButton.x + ([lastButton width] - [self.itemsWidthArrayM[lastButton.tag] floatValue])/2 + self.segmentStyle.lineLeftAndRightAddWidth + xD * progress;
            self.lineView.width = [self.itemsWidthArrayM[lastButton.tag] floatValue] + self.segmentStyle.lineLeftAndRightAddWidth + wD * progress;
        } else {
            self.lineView.x = lastButton.x + xD * progress - self.segmentStyle.lineLeftAndRightAddWidth + self.segmentStyle.lineLeftAndRightMargin;
            self.lineView.width = lastButton.width + wD * progress + self.segmentStyle.lineLeftAndRightAddWidth * 2 - self.segmentStyle.lineLeftAndRightMargin * 2;
        }
    }
    
    ///遮盖
    if (self.segmentStyle.showConver) {
        self.converView.x = lastButton.x + xD * progress - kLTSegmentCoverMarginX;
        self.converView.width = lastButton.width + wD * progress + kLTSegmentCoverMarginW;
        //处理Conver宽度等于字体宽度
        if (!self.segmentStyle.scrollMenu &&
            !self.segmentStyle.aligmentModeCenter &&
            self.segmentStyle.lineWidthEqualFontWidth) {
            self.converView.x = currentButton.x + ([currentButton width] - [self.itemsWidthArrayM[currentButton.tag] floatValue]) / 2 - kLTSegmentCoverMarginX + xD * progress;
            self.converView.width = [self.itemsWidthArrayM[currentButton.tag] floatValue] + kLTSegmentCoverMarginW + wD * progress;
        }
    }
}

- (void)selectedItemIndex:(NSInteger)index
                 animated:(BOOL)animated {
    self.currentIndex = index;
    [self adjustItemAnimate:animated];
}

- (void)adjustItemWithAnimated:(BOOL)animated {
    if (self.lastIndex == self.currentIndex) return;
    [self adjustItemAnimate:animated];
}

- (void)reloadView {
    ///重置数据
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemsArrayM removeAllObjects];
    [self.itemsWidthArrayM removeAllObjects];
    
    [self setupSubviews];
}

#pragma mark  getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = self.segmentStyle.lineColor;
    }
    return _lineView;
}

- (UIView *)converView {
    if (!_converView) {
        _converView = [[UIView alloc] init];
        _converView.layer.backgroundColor = self.segmentStyle.coverColor.CGColor;
        _converView.layer.cornerRadius = self.segmentStyle.coverCornerRadius;
        _converView.layer.masksToBounds = YES;
        _converView.userInteractionEnabled = NO;
    }
    return _converView;
}

- (LTScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[LTScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = self.segmentStyle.bounces;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = self.segmentStyle.scrollMenu;
    }
    return _scrollView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.segmentStyle.addButtonNormalImageName] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.segmentStyle.addButtonHightImageName] forState:UIControlStateHighlighted];
        _addButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(-1, 0);
        _addButton.layer.shadowOpacity = 0.5;
        _addButton.backgroundColor = self.segmentStyle.addButtonBackgroundColor;
        [_addButton addTarget:self action:@selector(addButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark  click
- (void)itemButtonOnClick:(UIButton *)sender {
    self.currentIndex = sender.tag;
    [self adjustItemWithAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuItemOnClick:index:)]) {
        [self.delegate menuItemOnClick:sender index:self.currentIndex];
    }
}

- (void)addButtonOnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuAddButtonOnClick:)]) {
        [self.delegate menuAddButtonOnClick:sender];
    }
}

@end
