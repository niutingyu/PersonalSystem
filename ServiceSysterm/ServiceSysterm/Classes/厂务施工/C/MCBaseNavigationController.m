//
//  MCBaseNavigationController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/11/4.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCBaseNavigationController.h"

@interface MCBaseNavigationController ()

@end

@implementation MCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseNav];
    
}

-(void)setupBaseNav{
    //去除导航栏黑线
//    self.navigationBar.shadowImage = [[UIImage alloc]init];
//    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    //配置导航栏颜色
    self.navigationBar.backgroundColor = self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = YES;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
  
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed =YES;
    }
  //  viewController.hidesBottomBarWhenPushed  =YES;
    [super pushViewController:viewController animated:YES];
}

@end
