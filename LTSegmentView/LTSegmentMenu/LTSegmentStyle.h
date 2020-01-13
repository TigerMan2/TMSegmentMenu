//
//  LTSegmentStyle.h
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSegmentStyle : NSObject

#pragma mark  LTSegmentMenu Config
/// 是否显示遮盖，Default NO.
@property (nonatomic, assign) BOOL showConver;
/// 是否显示线条，Default YES.
@property (nonatomic, assign) BOOL showScrollLine;
/// 是否显示底部线条，Default NO.
@property (nonatomic, assign) BOOL showBottomLine;
/// 颜色是否渐变，Default YES.
@property (nonatomic, assign) BOOL showGradientColor;
/// 是否显示按钮，Default NO.
@property (nonatomic, assign) BOOL showAddButton;
/// 菜单是否滚动，Default YES.
@property (nonatomic, assign) BOOL scrollMenu;
/// 菜单弹簧效果，Default YES.
@property (nonatomic, assign) BOOL bounces;
/// 是否是居中，(当所有的Item+margin的宽度小于ScrollView宽度)  Default YES.
/// scrollMenu = NO,aligmentModeCenter = NO 会变成平分
@property (nonatomic, assign) BOOL aligmentModeCenter;
/// 当aligmentModeCenter 变为平分时 是否需要线条宽度等于字体宽度 Default NO.
@property (nonatomic, assign) BOOL lineWidthEqualFontWidth;
/// 自定义Item 加图片 图片间隙 ...
@property (nonatomic, copy) NSArray<UIButton *> *buttonArray;
/// 按钮默认图片
@property (nonatomic, copy) NSString *addButtonNormalImageName;
/// 按钮高亮图片
@property (nonatomic, copy) NSString *addButtonHightImageName;
/// 按钮背景
@property (nonatomic, strong) UIColor *addButtonBackgroundColor;
/// 线条Color
@property (nonatomic, strong) UIColor *lineColor;
/// 遮盖Color
@property (nonatomic, strong) UIColor *coverColor;
/// 菜单背景Color
@property (nonatomic, strong) UIColor *scrollViewBackgroundColor;
/// 选项正常Color
@property (nonatomic, strong) UIColor *normalItemColor;
/// 选项选中Color
@property (nonatomic, strong) UIColor *selectedItemColor;
/// 底部线条Color
@property (nonatomic, strong) UIColor *bottomLineColor;
/// 底部线条左右间距 Default 0.
@property (nonatomic, assign) CGFloat bottomLineLeftAndRightMargin;
/// 底部线条圆角 Default 0.
@property (nonatomic, assign) CGFloat bottomLineCorner;
/// 线height Default 2.
@property (nonatomic, assign) CGFloat lineHeight;
/// 线条底部距离 Default 0.
@property (nonatomic, assign) CGFloat lineBottomMargin;
/// 线条左右偏移量 Default 0.
@property (nonatomic, assign) CGFloat lineLeftAndRightMargin;
/// 线条圆角 Default 0.
@property (nonatomic, assign) CGFloat lineCorner;
/// 线条左右增加 Default 0.  默认线条宽度是等于 item宽度
@property (nonatomic, assign) CGFloat lineLeftAndRightAddWidth;
/// 底部线height Default 2.
@property (nonatomic, assign) CGFloat bottomLineHeight;
/// 遮盖height Default 28.
@property (nonatomic, assign) CGFloat converHeight;
/// 菜单height Default 44.
@property (nonatomic, assign) CGFloat menuHeight;
/// 菜单widht 默认是 屏幕宽度
@property (nonatomic, assign) CGFloat menuWidth;
/// 遮盖圆角 Default 14.
@property (nonatomic, assign) CGFloat coverCornerRadius;
/// 选项相邻间隙 Default 15.
@property (nonatomic, assign) CGFloat itemMargin;
/// 选项左边或者右边间隙 Default 15.
@property (nonatomic, assign) CGFloat itemLeftAndRightMargin;
/// 选项字体 Default 14.
@property (nonatomic, strong) UIFont *itemFont;
/// 选中字体
@property (nonatomic, strong) UIFont *selectedItemFont;
/// 缩放系数
@property (nonatomic, assign) CGFloat itemMaxScale;
/// 临时Top高度
@property (nonatomic, assign) CGFloat tempTopHeight;
/// 内容区域
@property (nonatomic, assign) CGFloat contentHeight;

+ (instancetype)defaultConfig;

#pragma mark  颜色和缩放
@property (nonatomic, assign) CGFloat deltaScale;

@property (nonatomic, assign) CGFloat deltaNorR;

@property (nonatomic, assign) CGFloat deltaNorG;

@property (nonatomic, assign) CGFloat deltaNorB;

@property (nonatomic, assign) CGFloat deltaSelR;

@property (nonatomic, assign) CGFloat deltaSelG;

@property (nonatomic, assign) CGFloat deltaSelB;

- (void)setRGBWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
