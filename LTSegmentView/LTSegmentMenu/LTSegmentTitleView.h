//
//  LTSegmentTitleView.h
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LTFrame.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TitleImagePosition) {
    TitleImagePositionTop,
    TitleImagePositionLeft,
    TitleImagePositionRight,
    TitleImagePositionCenter
};

@interface LTSegmentTitleView : UIView

@property (nonatomic, assign) TitleImagePosition imagePosition;
//!< 标题字体大小
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)adjustsubviewsFrame;
- (CGFloat)titleViewWidth;

@end

NS_ASSUME_NONNULL_END
