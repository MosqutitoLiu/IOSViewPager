//
//  ViewController.h
//  ViewPager
//
//  Created by liu zheng on 15/7/27.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"
#import "TabContentView.h"

#pragma mark dataSource
@protocol ViewPagerDataSource <NSObject>

/**
 * The content for any tab. Return a view controller and ViewPager will use its view to show as content.
 *
 * @param viewPager The viewPager that's subject to
 * @param index The index of the content whose view is asked
 *
 * @return A viewController whose view will be shown as content
 */
- (UIViewController *)viewPager:(UIViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;

@end



@interface PagerViewController : UIViewController

@property (nonatomic) BOOL animatePager;

@property (weak) id <ViewPagerDataSource> dataSource;


-(void) setTabData:(NSArray *)tabData;
- (void) reloadData;

@end

