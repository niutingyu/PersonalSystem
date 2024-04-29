//
//  DeviceNavController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceNavController.h"

@interface DeviceNavController ()
{
    NSString * _flag;
}
@end

@implementation DeviceNavController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self showTabBar];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.navigationBar.barTintColor = [UIColor whiteColor];
     self.navigationBar.translucent =NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
   
}


//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    debugLog(@" - - -%@",_flag);
//  
//
//    
//     // viewController.hidesBottomBarWhenPushed = YES;
//    [super pushViewController:viewController animated:YES];
//   
//
//    
//}
- (void)showTabBar

{
  
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
@end
