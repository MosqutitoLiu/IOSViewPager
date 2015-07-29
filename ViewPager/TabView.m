//
//  TabView.m
//  ViewPager
//
//  Created by liu zheng on 15/7/27.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "TabView.h"
@interface TabView ()

@property (strong,nonatomic) NSString * text;
@property (strong,nonatomic) UILabel *label;
@property (nonatomic) CGSize textSize;
@property (strong,nonatomic) UIFont *font;
@end



@implementation TabView

- (id)initWithFrame:(CGRect)frame text:(NSString *) text textSize:(CGSize) textSize  font:(UIFont *) font {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.text = text;
        self.textSize = textSize;
        self.font = font;
    }
    return self;
}

-(CGSize) getSize {
    return self.textSize;
}

- (void) layoutSubviews{

    if(!_label){
    
        NSUInteger bottomLineHeight = 2;
        CGRect frame = CGRectMake(0, 0, _textSize.width, self.frame.size.height - bottomLineHeight);
        _label = [[UILabel alloc]initWithFrame:frame];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = self.font;
        [self setColor];
        _label.text = self.text;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_label];
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setColor];
    [self setNeedsDisplay];
}


-(void) setColor {
    if (_selected) {
        _label.textColor = [UIColor colorWithRed:42.0/255 green: 136.0/255 blue: 204.0/255 alpha: 1];
    } else {
        _label.textColor = [UIColor colorWithRed:60/255 green: 60/255 blue: 60/255 alpha: 1];
    }
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;

    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        // Draw the indicator
        [bezierPath moveToPoint:CGPointMake(0.0, CGRectGetHeight(rect) - 1.0)];
        [bezierPath addLineToPoint:CGPointMake(self.textSize.width, CGRectGetHeight(rect) - 1.0)];
        [bezierPath setLineWidth:1.0];
        UIColor *color = [UIColor colorWithRed:42.0/255 green: 136.0/255 blue: 204.0/255 alpha: 1];
        [color setStroke];
        [bezierPath stroke];
    }
}

@end
