//
//  LTSegmentTitleView.m
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import "LTSegmentTitleView.h"

@interface LTSegmentTitleView ()
{
    CGSize _titleSize;
    CGFloat _imageWidth;
    CGFloat _imageHeight;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation LTSegmentTitleView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
}

- (void)adjustsubviewsFrame {
    self.contentView.frame = self.bounds;
    self.contentView.width = [self titleViewWidth];
    self.contentView.x = (self.width - self.contentView.width) * 0.5;
    self.titleLabel.frame = self.contentView.bounds;
    
    [self addSubview:self.contentView];
    [self.titleLabel removeFromSuperview];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    
    switch (self.imagePosition) {
        case TitleImagePositionTop:
            {
                //!< 设置contentViewFrame
                self.contentView.height = _imageHeight + _titleSize.height;
                self.contentView.y = (self.height - self.contentView.height) * 0.5;
                
                //!< 设置imageViewFrame
                self.imageView.frame = CGRectMake(0, 0, _imageWidth, _imageHeight);
                self.imageView.centerX = self.titleLabel.centerX;
                
                //!< 设置titleLabelFrame
                self.titleLabel.y = _imageHeight;
                self.titleLabel.height = _titleSize.height;
            }
            break;
        case TitleImagePositionLeft:
            {
                //!< 设置LabelFrame
                self.titleLabel.x = _imageWidth;
                self.titleLabel.width = _titleSize.width;
                
                //!< 设置imageViewFrame
                self.imageView.frame = CGRectMake(0, 0, _imageWidth, _imageHeight);
                self.imageView.y = (self.contentView.height - _imageHeight) * 0.5;
            }
        break;
        case TitleImagePositionRight:
            {
                //!< 设置LabelFrame
                self.titleLabel.width = _titleSize.width;
                
                //!< 设置imageViewFrame
                self.imageView.frame = CGRectMake(0, 0, _imageWidth, _imageHeight);
                self.imageView.y = (self.contentView.height - _imageHeight) * 0.5;
                self.imageView.x = _titleSize.width;
            }
        break;
        case TitleImagePositionCenter:
            {
                //!< 设置imageFrame
                self.imageView.frame = self.contentView.bounds;
                //!< 移除label
                [self.titleLabel removeFromSuperview];
            }
        break;
            
        default:
            break;
    }
    
}

- (CGFloat)titleViewWidth {
    CGFloat width = 0.0f;
    switch (self.imagePosition) {
        case TitleImagePositionLeft:
        case TitleImagePositionRight:
            width = _titleSize.width + _imageWidth;
        break;
        case TitleImagePositionCenter:
            width = _imageWidth;
        break;
        default:
            width = _titleSize.width;
            break;
    }
    return width;
}

#pragma mark    -   privete
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(HUGE, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    _titleSize = bounds.size;
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    _imageWidth = normalImage.size.width;
    _imageHeight = normalImage.size.height;
    self.imageView.image = normalImage;
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    self.imageView.highlightedImage = selectedImage;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.imageView.highlighted = selected;
}

#pragma mark    -   getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
