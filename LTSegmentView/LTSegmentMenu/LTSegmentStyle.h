//
//  LTSegmentStyle.h
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTSegmentTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSegmentStyle : NSObject

@property (nonatomic, assign) TitleImagePosition imagePosition;
//!< 标题是否可以滚动
@property (nonatomic, assign, getter=isScrollTitle) BOOL scrollTitle;
//!< 是否自动调整下划线的宽度 默认是NO
@property (assign, nonatomic, getter=isAdjustCoverOrLineWidth) BOOL adjustCoverOrLineWidth;
/** 是否自动调整标题的宽度, 当设置为YES的时候 如果所有的标题的宽度之和小于segmentView的宽度的时候, 会自动调整title的位置, 达到类似"平分"的效果 默认为NO*/
@property (assign, nonatomic, getter=isAutoAdjustTitlesWidth) BOOL autoAdjustTitlesWidth;
//!< 滚动条颜色
@property (nonatomic, strong) UIColor *scrollLineColor;
//!< 标题间距
@property (nonatomic, assign) CGFloat titleMargin;
//!< 标题文字大小
@property (nonatomic, strong) UIFont *titleFont;
//!< 标题默认颜色
@property (nonatomic, strong) UIColor *normalTitleColor;
//!< 标题选中颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;
//!< 滚动条的高度 默认是2
@property (nonatomic, assign) CGFloat scrollLineHeight;

@end

NS_ASSUME_NONNULL_END
