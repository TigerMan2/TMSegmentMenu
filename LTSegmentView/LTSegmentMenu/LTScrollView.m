//
//  LTScrollView.m
//  LTSegmentView
//
//  Created by Luther on 2020/1/13.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "LTScrollView.h"
#import "UIView+LTFrame.h"
#import <objc/runtime.h>

@interface LTScrollView () <UIGestureRecognizerDelegate>

@end

@implementation LTScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    int location_X = 0.15 * [UIScreen mainScreen].bounds.size.width;
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            int temp1 = location.x;
            int temp2 = [UIScreen mainScreen].bounds.size.width;
            NSInteger XX = temp1 % temp2;
            if (point.x > 0 && XX < location_X) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

@end
