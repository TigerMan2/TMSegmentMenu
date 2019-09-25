//
//  LTSegmentMenu.h
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSegmentStyle.h"
@class LTSegmentMenu;

NS_ASSUME_NONNULL_BEGIN

@protocol LTSegmentMenuDelegate <NSObject>

@optional;
- (void)setupTitleView:(LTSegmentTitleView *)titleView selectedIndex:(NSInteger)index;

- (void)segmentView:(LTSegmentMenu *)segmentView oldTitleView:(LTSegmentTitleView *)oldTitleView currentTitleView:(LTSegmentTitleView *)currentTitleView oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;

@end

@interface LTSegmentMenu : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles segmentStyle:(LTSegmentStyle *)segmentStyle delegate:(id<LTSegmentMenuDelegate>)delegate;

- (void)reloadTitlesWithNewTitles:(NSArray *)titles;
/** 设置选中的下标 */
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
/** 让选中的标题居中 */
- (void)adjustTitleOffsetToCurrentIndex:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
