//
//  DetailPageViewController.m
//  ViewPager
//
//  Created by liu zheng on 15/7/27.
//  Copyright (c) 2015年 liu zheng. All rights reserved.
//

#import "DetailPageViewController.h"

@interface DetailPageViewController ()
@property NSUInteger index;
@end

@implementation DetailPageViewController

- (instancetype)init:(NSUInteger) index
{
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect r = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/3, 30, 30 );
    UILabel *label = [[UILabel alloc] initWithFrame:r];
    
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.index];
    label.font = [UIFont fontWithName:nil size:30];
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor yellowColor];
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
