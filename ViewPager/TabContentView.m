//
//  TabContentView.m
//  ViewPager
//
//  Created by liu zheng on 15/7/29.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "TabContentView.h"

@implementation TabContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
    // Draw top line
    UIColor *color = [UIColor colorWithWhite:197.0/255.0 alpha:0.75];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0.0)];
    [color setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    // Draw bottom line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [color setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

}



@end
