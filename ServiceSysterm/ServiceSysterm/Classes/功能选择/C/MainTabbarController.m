//
//  MainTabbarController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MainTabbarController.h"

#import "FunctionChosController.h"
#import "MyDaiBanController.h"
#import "MyLanuchViewController.h"
#import "ProfileViewController.h"
#import "BaseNavViewController.h"
#import "MainChoseItemsController.h"
@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [[UITabBar appearance] setTintColor:RGBA(31, 120, 255, 1)];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9],
                                                        
                                                        NSForegroundColorAttributeName : RGBA(28, 103, 255, 1)
                                                        
                                                        } forState:UIControlStateSelected];
    
    UIView *img = [[UIView alloc]init];
    img.backgroundColor = [UIColor whiteColor];
    img.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    [self.tabBar insertSubview:img atIndex:0];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.tabBar);
//    }];
//    img.sd_layout
//    .topSpaceToView(self.tabBar,0)
//    .leftSpaceToView(self.tabBar,0)
//    .bottomSpaceToView(self.tabBar,0)
//    .rightSpaceToView(self.tabBar,0);
 //   [self setupTabbar];
   
}

-(void)setupTabbar{
    MainChoseItemsController * newController = [MainChoseItemsController new];
    newController.tabBarItem.title = @"功能选择";
    newController.tabBarItem.image = [UIImage imageNamed:@"tool-light."];
    BaseNavViewController * newNav = [[BaseNavViewController alloc]initWithRootViewController:newController];
    MyDaiBanController * taskController = [MyDaiBanController new];
    taskController.tabBarItem.title = @"我的待办";
    taskController.tabBarItem.image = [UIImage imageNamed:@"gougao-h"];
    BaseNavViewController * taskNav = [[BaseNavViewController alloc]initWithRootViewController:taskController];
    MyLanuchViewController * finishController = [MyLanuchViewController new];
    finishController.tabBarItem.title = @"我发起的";
    finishController.tabBarItem.image = [UIImage imageNamed:@"daikuan-wuse"];
    BaseNavViewController * finishNav = [[BaseNavViewController alloc]initWithRootViewController:finishController];
    
    ProfileViewController * profileController = [ProfileViewController new];
    profileController.tabBarItem.title = @"个人中心";
    profileController.tabBarItem.image = [UIImage imageNamed:@"me-light."];
    BaseNavViewController * profileNav = [[BaseNavViewController alloc]initWithRootViewController:profileController];
    [self setViewControllers:@[newNav,taskNav,finishNav,profileNav] animated:YES];
    
    
    
    
    
}

@end
