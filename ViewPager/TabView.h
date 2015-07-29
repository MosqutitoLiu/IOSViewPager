//
//  TabView.h
//  ViewPager
//
//  Created by liu zheng on 15/7/27.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabView : UIView

- (id)initWithFrame:(CGRect)frame text:(NSString *) text textSize:(CGSize) textSize font:(UIFont *) font;


@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;

- (void)setSelected:(BOOL)selected;
-(CGSize)getSize;
@end
