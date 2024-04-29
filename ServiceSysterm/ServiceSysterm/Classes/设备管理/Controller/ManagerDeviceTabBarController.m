//
//  ManagerDeviceTabBarController.m
//  ServiceSysterm
//
//  Created by Andy on 2023/3/30.
//  Copyright © 2023 SLPCB. All rights reserved.
//

#import "ManagerDeviceTabBarController.h"

#import "DMHistoryViewController.h"
#import "DMTaskViewController.h"
#import "DMUnfinishViewController.h"
#import "MCBaseNavigationController.h"
@interface ManagerDeviceTabBarController ()

@end

@implementation ManagerDeviceTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTababr];
}

-(void)setupTababr{
    
    [UITabBar appearance].translucent = NO;//不透明
    // 去掉tab黑色分割线
    self.tabBar.barStyle = UIBarStyleDefault;
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
    
    //任务
    DMTaskViewController * taskController  =[DMTaskViewController new];
    
    //未完成
    DMUnfinishViewController * unfinishController  =[DMUnfinishViewController new];
    
    //历史
    DMHistoryViewController * historyController  =[DMHistoryViewController new];
    //@"chaxun",@"zonghekaidan",@"gougao-h",@"jilu",@"gougao-h",@"huaban",@"zonghekaidan"
    MCBaseNavigationController * nav  =[[MCBaseNavigationController alloc]initWithRootViewController:taskController];
    [self addChildVC:nav title:@"任务" image:@"gougao-h" selectedImage:@"gougao-h"];

    MCBaseNavigationController * nav1  =[[MCBaseNavigationController alloc]initWithRootViewController:unfinishController];
    [self addChildVC:nav1 title:@"未完成" image:@"jilu" selectedImage:@"jilu"];

    
    MCBaseNavigationController * nav2  =[[MCBaseNavigationController alloc]initWithRootViewController:historyController];
    [self addChildVC:nav2 title:@"历史" image:@"huaban" selectedImage:@"huaban"];
    

}

-(void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    childVC.tabBarItem.title = title;
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    [self selectedTapTabBarItems:childVC.tabBarItem];
    [self unSelectedTapTabBarItems:childVC.tabBarItem];
    [self addChildViewController:childVC];
}
//tab字体颜色
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,RGBA(27, 93, 244, 1),NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  =YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  =NO;
}
@end
