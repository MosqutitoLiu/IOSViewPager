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


@interface PagerViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *tabData;
@property (strong,atomic) UIPageViewController *pageView;
@property (strong ,nonatomic) UIView *contentView;
@property (strong ,nonatomic) TabContentView *tabView;
@property (strong ,nonatomic)  UIView *lineView;


@property (strong,nonatomic) NSMutableArray *tabs;
@property (strong,nonatomic) NSMutableArray *controllers;

@property (nonatomic) NSInteger activeContentIndex;
@property (nonatomic) NSInteger activeTabIndex;
@property (nonatomic) NSInteger lastTabIndex;

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
    
    _activeContentIndex = 0;
    _activeTabIndex =0;
    _lastTabIndex = 0;
    
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
        self.tabView = [[TabContentView alloc] initWithFrame:CGRectMake(0.0, startY, frameWidth, TabHeight)];
        self.tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabView.scrollsToTop = NO;
        self.tabView.showsHorizontalScrollIndicator = NO;
        self.tabView.showsVerticalScrollIndicator = NO;
        self.tabView.tag = tabsIdentity;
        self.tabView.delegate = self;
        
        contentSize = [self setupTabs:self.tabView width:TabWidth height:TabHeight];
        
        [self.view insertSubview:self.tabView atIndex:0];
        
        self.tabView.contentSize = CGSizeMake(contentSize, TabHeight);
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

-(NSInteger) setupTabs:(UIScrollView*)tabView width:(NSInteger)tabWidth height:(NSInteger) tabHeight {
    
    NSUInteger count = self.tabData.count;

    
    if(!self.tabs){
        self.tabs = [NSMutableArray arrayWithCapacity:count];
    }
    [self.tabs removeAllObjects];

    NSInteger contentSize = TabSpan;
    NSUInteger xp = TabSpan;
    
    for (int i=0; i<count; i++) {
        
        NSString *text = [self.tabData objectAtIndex:i];
        
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName :font}];
        CGRect frame = CGRectMake(xp, 0, textSize.width, tabHeight);
        xp += textSize.width + TabSpan;
        contentSize += textSize.width + TabSpan;
        
        TabView *subTab = [[TabView alloc]initWithFrame:frame text:text textSize:textSize font:font];
        if (i==0) {
            [subTab setSelected:YES];
            if(!_lineView){
                CGRect lineFrame = CGRectMake(subTab.frame.origin.x,subTab.frame.size.height-1, subTab.frame.size.width,1);
                _lineView = [[UIView alloc] initWithFrame:lineFrame];
                _lineView.backgroundColor = [UIColor colorWithRed:42.0/255 green: 136.0/255 blue: 204.0/255 alpha: 1];
                [tabView addSubview:_lineView];
            }
        }

        [tabView addSubview:subTab];
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [subTab addGestureRecognizer:tapGestureRecognizer];
        
        
        [self.tabs addObject:subTab];
    }
    
    return contentSize;
    
}

#pragma mark - IBAction
- (IBAction)handleTapGesture:(id)sender {
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    
    NSUInteger index = [self.tabs indexOfObject:tabView];
    
    if (self.activeTabIndex != index) {
        [self selectTabAtIndex:index];
        [self setClickTabController:index];
    }
}

- (void) selectTabAtIndex:(NSInteger) index {
    
    //lastTag
    _lastTabIndex = self.activeTabIndex;
    
    // Select the tab
    self.activeTabIndex = index;
    
    // Set activeContentIndex
    self.activeContentIndex = index;
    
    TabView *lastTabView = [self.tabs objectAtIndex:_lastTabIndex];
    [lastTabView setSelected:NO];
    
    TabView *tabView = [self.tabs objectAtIndex:index];
    [tabView setSelected:YES];
    
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

-(void) moveTag {
    
    
    CGRect frame;
    
    if (self.lastTabIndex<self.activeTabIndex) {
        
        if (self.activeTabIndex>=self.tabData.count) {
            return;
        }
        
        TabView *tabView = [self.tabs objectAtIndex:self.activeTabIndex];
        if (tabView) {
            frame = tabView.frame;
            //center top
            frame.origin.x+=self.view.frame.size.width/2 - TabSpan;
        }
    } else {
        
        NSInteger index = self.activeTabIndex;
        if (index<0) {
            index = 0;
        }
        TabView *tabView = [self.tabs objectAtIndex:index];
        frame = tabView.frame;
        //center top
        frame.origin.x -= self.view.frame.size.width/2 - TabSpan;
    }
    
    [self.tabView scrollRectToVisible:frame animated:YES];
    [self moveTagLine];
}

-(void) moveTagLine{
    
    TabView *tabView = [self.tabs objectAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    frame.origin.y = frame.size.height - 1;
    frame.size.height = 1;
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [_lineView setFrame:frame];
                     }
                     completion:nil];
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
    [self selectTabAtIndex: index];
    [self moveTag];
}



#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
