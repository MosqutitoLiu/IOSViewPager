//
//  ViewController.m
//  ViewPager
//
//  Created by liu zheng on 15/7/27.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "PagerViewController.h"

#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending
#define TabWidth  50
#define TabHeight  30
#define TabSpan  20


@interface PagerViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate , TagClickDelegate>
@property (strong, nonatomic) NSArray *tabData;
@property (strong,atomic) UIPageViewController *pageView;
@property (strong ,nonatomic) UIView *contentView;
@property (strong ,nonatomic) TabContentView *tabView;

@property (strong,nonatomic) NSMutableArray *controllers;

@end

@implementation PagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _animatePager = NO;
}

- (void) reloadData {
    if (self.tabData.count == 0) {
        return;
    }
    
    [self setupLayout];
    [self setupView];
}

-(void) setTabData:(NSArray *)tabData{
    _tabData = tabData;
    [self reloadData];
}

- (void)layoutSubviews {
    
}

-(void) setupLayout {
    
    
    NSUInteger count = self.tabData.count;
    if (count==0) {
        return;
    }
    
    if (!self.controllers) {
        self.controllers = [NSMutableArray arrayWithCapacity:count];
    }
    
    [self.controllers removeAllObjects];
    for (NSUInteger i = 0; i < count; i++) {
        [self.controllers addObject:[NSNull null]];
    }
    
    if (!_pageView) {
    
        _pageView = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                              options:nil];
    
        [self addChildViewController:_pageView];
    
        _pageView.dataSource = self;
        _pageView.delegate = self;
    
        UIViewController *startingViewController = [self viewControllerAtIndex:0];
    
        NSArray *viewControllers = @[startingViewController];
    
        [self.pageView setViewControllers:viewControllers
                            direction:UIPageViewControllerNavigationDirectionForward
                             animated:_animatePager
                           completion:nil];
    }
}

- (void) setupView {
    
    NSInteger startY = 0;
    if (IOS_VERSION_7) {
        startY = 20.0;
        if (self.navigationController && !self.navigationController.navigationBarHidden) {
            startY += self.navigationController.navigationBar.frame.size.height;
        }
    }
    
    NSInteger frameWidth = self.view.frame.size.width;
    NSInteger frameHeight = self.view.frame.size.height;
    
    NSInteger TagHeight = 30;
    NSInteger ContentHeight = frameHeight - TagHeight;
    
    
    NSInteger contentSize;
    static NSInteger tabsIdentity = 100;
    self.tabView = (TabContentView *)[self.view viewWithTag:tabsIdentity];
    
    if (!self.tabView) {
        self.tabView = [[TabContentView alloc] initWithFrame:CGRectMake(0.0, startY, frameWidth, TabHeight) tabData:self.tabData];
        self.tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabView.scrollsToTop = NO;
        self.tabView.showsHorizontalScrollIndicator = NO;
        self.tabView.showsVerticalScrollIndicator = NO;
        self.tabView.tag = tabsIdentity;
        self.tabView.delegate = self;
        self.tabView.controllerDelegte = self;
        [self.tabView setupTabs];
        
        [self.view insertSubview:self.tabView atIndex:0];
        
        //self.tabView.contentSize = CGSizeMake(contentSize, TabHeight);
    }
    
    
    static NSInteger contentIdentity = 200;
    self.contentView = [self.view viewWithTag:contentIdentity];
    
    if (!self.contentView) {
        self.contentView = self.pageView.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.tag = contentIdentity;
        CGRect contentFrame = CGRectMake(0, startY + TagHeight, frameWidth , ContentHeight);
        _contentView.frame = contentFrame;
        [self.view insertSubview:self.contentView atIndex:0];
    }
}



- (void)setClickTabController:(NSInteger) index {
    
    // Get the desired viewController
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    NSArray *viewControllers = @[viewController];
    
    NSInteger direct = UIPageViewControllerNavigationDirectionForward;
    if(index >=self.tabData.count){
        direct = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [self.pageView setViewControllers:viewControllers
                            direction:direct
                             animated:_animatePager
                           completion:nil];
    
}



-(UIViewController*) viewControllerAtIndex:(NSInteger) index {
    
    if ( index<0 || index>=self.tabData.count) {
        return nil;
    }
    
    UIViewController *controller = (UIViewController *)[self.controllers objectAtIndex:index];
    
    if ([controller isEqual:[NSNull null]]) {
        
        if([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)]){
            controller = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
            [self.controllers insertObject:controller atIndex:index];
        }
    }
    
    return controller;
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.controllers indexOfObject:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.controllers indexOfObject:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.tabData.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageView.viewControllers[0];
    NSInteger index = [self.controllers indexOfObject:viewController];
    [self.tabView selectTabAtIndex: index];
    
}


#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
