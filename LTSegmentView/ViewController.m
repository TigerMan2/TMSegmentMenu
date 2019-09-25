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
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic, strong) LTSegmentMenu *segmentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LTSegmentStyle *style = [[LTSegmentStyle alloc] init];
    style.imagePosition = TitleImagePositionLeft;
    style.autoAdjustTitlesWidth = YES;
    self.titles = @[@"股信",@"自选",@"产品",@"交易师",@"人工诊股"];
    LTSegmentMenu *segView = [[LTSegmentMenu alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 40) titles:self.titles segmentStyle:style delegate:self];
//    [segView setSelectedIndex:0 animated:YES];
    self.segmentView = segView;
    [self.view addSubview:segView];
}

- (void)segmentView:(LTSegmentMenu *)segmentView oldTitleView:(LTSegmentTitleView *)oldTitleView currentTitleView:(LTSegmentTitleView *)currentTitleView oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    NSLog(@"currentIndex----%ld",currentIndex);
}

- (void)setupTitleView:(LTSegmentTitleView *)titleView selectedIndex:(NSInteger)index {
//    if (index == 0) {
//        titleView.backgroundColor = [UIColor redColor];
//    } else if (index == 1) {
//        titleView.backgroundColor = [UIColor yellowColor];
//    } else if (index == 2) {
//        titleView.backgroundColor = [UIColor blackColor];
//    } else if (index == 3) {
//        titleView.backgroundColor = [UIColor greenColor];
//    } else if (index == 4) {
//        titleView.backgroundColor = [UIColor redColor];
//    }
    if (index == 4) {
        titleView.normalImage = [UIImage imageNamed:@"diagStock_icon"];
        titleView.selectedImage = [UIImage imageNamed:@"diagStock_icon"];
    }
}


@end
