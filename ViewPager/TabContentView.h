//
//  TabContentView.h
//  ViewPager
//
//  Created by liu zheng on 15/7/29.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark dataSource
@protocol TagClickDelegate <NSObject>

/**
 * The content for any tab. Return a view controller and ViewPager will use its view to show as content.
 *
 * @param viewPager The viewPager that's subject to
 * @param index The index of the content whose view is asked
 *
 * @return A viewController whose view will be shown as content
 */
- (void)setClickTabController:(NSInteger) index;

@end


@interface TabContentView : UIScrollView


@property (nonatomic) NSInteger activeTabIndex;
@property (nonatomic) NSInteger lastTabIndex;
@property (strong ,nonatomic)  UIView *lineView;
@property (strong,nonatomic) NSMutableArray *tabs;
@property (strong, nonatomic) NSArray *tabData;

@property (weak) id <TagClickDelegate> controllerDelegte;

- (id)initWithFrame:(CGRect)frame tabData:(NSArray *) tabData;
- (void) selectTabAtIndex:(NSInteger) index;
- (NSUInteger) getTabIndex;
- (NSUInteger) getLastTabIndex;
-(void) setupTabs;
@end
