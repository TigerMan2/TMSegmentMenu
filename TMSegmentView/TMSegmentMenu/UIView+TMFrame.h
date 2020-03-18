//
//  UIView+TMFrame.h
//  TMScrollPageView
//
//  Created by wangpeng on 2018/12/6.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TMFrame)

@property (nonatomic, assign) CGFloat centerX;   //self.center.x
@property (nonatomic, assign) CGFloat centerY;   //self.center.y

@property (nonatomic, assign) CGFloat width;     //self.frame.size.width
@property (nonatomic, assign) CGFloat height;    //self.frame.size.height
@property (nonatomic, assign) CGFloat x;         //self.frame.origin.x
@property (nonatomic, assign) CGFloat y;         //self.frame.origin.y

@end
