//
//  TMSegmentMenu.h
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSegmentStyle.h"
@class TMSegmentMenu;

NS_ASSUME_NONNULL_BEGIN

@protocol TMSegmentMenuDelegate <NSObject>
@optional;

/// 点击item
/// @param button 点击的按钮
/// @param index 点击的索引
- (void)menuItemOnClick:(UIButton *)button index:(NSInteger)index;

/// 点击添加按钮
/// @param button 添加按钮
- (void)menuAddButtonOnClick:(UIButton *)button;
@end

@interface TMSegmentMenu : UIView
/// 添加按钮
@property (nonatomic, strong) UIButton *addButton;
/// 标题数组
@property (nonatomic, strong) NSMutableArray *titles;

/// 初始化方法
/// @param frame 大小
/// @param titles 标题
/// @param segmentStyle 配置信息
/// @param delegate 代理
/// @param currentIndex 默认选中
+ (instancetype)menuViewWithFrame:(CGRect)frame
                       titles:(NSMutableArray *)titles
                 segmentStyle:(TMSegmentStyle *)segmentStyle
                     delegate:(id<TMSegmentMenuDelegate>)delegate
                 currentIndex:(NSInteger)currentIndex;

/// 更新指定下标的标题
/// @param title 标题
/// @param index 下标
- (void)updateTitle:(NSString *)title index:(NSInteger)index;

/// 更新所有的标题
/// @param titles 标题数组
- (void)updateTitles:(NSArray *)titles;

/// 根据下标调整item位置
/// @param index 下标
- (void)adjustItemPositionWidthCurrentIndex:(NSInteger)index;

/// 根据上个下标和当前下标调整进度
/// @param progress 进度
/// @param lastIndex 上个下标
/// @param currentIndex 当前下标
- (void)adjustItemWidthProgress:(CGFloat)progress
                      lastIndex:(NSInteger)lastIndex
                   currentIndex:(NSInteger)currentIndex;

/// 选中下标
/// @param index 下标
/// @param animated 动画
- (void)selectedItemIndex:(NSInteger)index
                 animated:(BOOL)animated;

/// 调整item
/// @param animated 动画
- (void)adjustItemWithAnimated:(BOOL)animated;

/// 调整item
/// @param animated 动画
- (void)adjustItemAnimate:(BOOL)animated;

/// 刷新视图
- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
