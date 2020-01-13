//
//  ViewController.m
//  LTSegmentView
//
//  Created by Luther on 2019/9/24.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "ViewController.h"
#import "LTSegmentMenu.h"

@interface ViewController () <LTSegmentMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LTSegmentStyle *style = [LTSegmentStyle defaultConfig];
    style.scrollViewBackgroundColor = [UIColor yellowColor];
    style.showScrollLine = YES;
    style.aligmentModeCenter = NO;
    style.scrollMenu = NO;
    style.showConver = YES;
    style.lineWidthEqualFontWidth = YES;
    
    LTSegmentMenu *menu = [LTSegmentMenu menuViewWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100) titles:@[@"系统偏好设置",@"网易云音乐",@"有道词典",@"系统偏好设置",@"网易云音乐",@"有道词典",@"系统偏好设置",@"网易云音乐",@"有道词典"].mutableCopy segmentStyle:style delegate:self currentIndex:0];
    [self.view addSubview:menu];
    
}

@end
