//
//  LTSegmentStyle.m
//  DeXun
//
//  Created by Luther on 2019/9/25.
//  Copyright © 2019 com.sirstock. All rights reserved.
//

#import "LTSegmentStyle.h"

@implementation LTSegmentStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue {
    _scrollTitle = YES;
    _adjustCoverOrLineWidth = NO;
    _autoAdjustTitlesWidth = NO;
    _scrollLineHeight = 2.0;
    _scrollLineColor = [UIColor brownColor];
    _titleMargin = 15.0;
    _titleFont = [UIFont systemFontOfSize:14.0];
    _normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75/255.0 alpha:1.0];
    _selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:121/255.0 alpha:1.0];
}

@end
