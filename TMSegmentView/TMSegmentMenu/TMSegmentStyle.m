//
//  TMSegmentStyle.m
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import "TMSegmentStyle.h"

@interface TMSegmentStyle ()

@property (nonatomic, strong) NSArray *normalColorArrays;

@property (nonatomic, strong) NSArray *selectedColorArrays;

@property (nonatomic, strong) NSArray *deltaColorArrays;

@end

@implementation TMSegmentStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue {
    
    _showConver = NO;
    _showScrollLine = YES;
    _showBottomLine = NO;
    _showGradientColor = YES;
    _showAddButton = NO;
    _scrollMenu = YES;
    _bounces = YES;
    _aligmentModeCenter = YES;
    _lineWidthEqualFontWidth = NO;
    
    _lineColor = [UIColor redColor];
    _coverColor = [UIColor groupTableViewBackgroundColor];
    _addButtonBackgroundColor = [UIColor whiteColor];
    _bottomLineColor = [UIColor greenColor];
    _scrollViewBackgroundColor = [UIColor whiteColor];
    _normalItemColor = [UIColor grayColor];
    _selectedItemColor = [UIColor blackColor];
    
    _lineHeight = 2;
    _converHeight = 28;
    _coverCornerRadius = 14;
    _menuHeight = 44;
    _menuWidth = [UIScreen mainScreen].bounds.size.width;
    _itemMargin = 15;
    _itemLeftAndRightMargin = 15;
    _itemFont = [UIFont systemFontOfSize:14];
    _selectedItemFont = _itemFont;
    _itemMaxScale = 0;
    _lineBottomMargin = 0;
    _lineLeftAndRightMargin = 0;
    _lineLeftAndRightAddWidth = 0;
    _bottomLineHeight = 2;
}

- (void)setRGBWithProgress:(CGFloat)progress {
    _deltaSelR = [self.normalColorArrays[0] floatValue] + [self.deltaColorArrays[0] floatValue] * progress;
    _deltaSelG = [self.normalColorArrays[1] floatValue] + [self.deltaColorArrays[1] floatValue] * progress;
    _deltaSelB = [self.normalColorArrays[2] floatValue] + [self.deltaColorArrays[2] floatValue] * progress;
    _deltaNorR = [self.selectedColorArrays[0] floatValue] + [self.deltaColorArrays[0] floatValue] * progress;
    _deltaNorG = [self.selectedColorArrays[1] floatValue] + [self.deltaColorArrays[1] floatValue] * progress;
    _deltaNorB = [self.selectedColorArrays[2] floatValue] + [self.deltaColorArrays[2] floatValue] * progress;
}

- (CGFloat)lineHeight {
    return _showScrollLine ? _lineHeight : 0;
}

- (CGFloat)deltaScale {
    return _deltaScale = _itemMaxScale - 1.0;
}

- (NSArray *)getRGBArrayWithColor:(UIColor *)color {
    CGFloat r, g, b, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return @[@(r),@(g),@(b)];
}

- (NSArray *)normalColorArrays {
    if (!_normalColorArrays) {
        _normalColorArrays = [self getRGBArrayWithColor:_normalItemColor];
    }
    return _normalColorArrays;
}

- (NSArray *)selectedColorArrays {
    if (!_selectedColorArrays) {
        _selectedColorArrays = [self getRGBArrayWithColor:_selectedItemColor];
    }
    return _selectedColorArrays;
}

- (NSArray *)deltaColorArrays {
    if (!_deltaColorArrays) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:self.normalColorArrays.count];
        [self.normalColorArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayM addObject:@([self.selectedColorArrays[idx] floatValue] - [obj floatValue])];
        }];
        _deltaColorArrays = [arrayM copy];
    }
    return _deltaColorArrays;
}

+ (instancetype)defaultConfig {
    return [[self alloc] init];
}

@end
