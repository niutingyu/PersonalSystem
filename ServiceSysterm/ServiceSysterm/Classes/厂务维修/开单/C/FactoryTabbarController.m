//
//  FactoryTabbarController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "FactoryTabbarController.h"
#import "AddNewOrderController.h"
#import "FFMyTaskController.h"
#import "FFUnfinishController.h"
#import "FFHistoryController.h"
#import "FFMoreViewController.h"
#import "BaseNavViewController.h"

#import "FactoryModel.h"

@interface FactoryTabbarController ()

@end

@implementation FactoryTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   // self.tabBar.translucent = NO;
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [[UITabBar appearance] setTintColor:RGBA(31, 120, 255, 1)];
    //[self setupTabbar];
    
}

-(void)setupTabbar{
   
    AddNewOrderController * newController = [AddNewOrderController new];
    newController.tabBarItem.title = @"开单";
    UINavigationController * newNav = [[UINavigationController alloc]initWithRootViewController:newController];
    FFMyTaskController * taskController = [FFMyTaskController new];
    taskController.tabBarItem.title = @"任务";
    UINavigationController * taskNav = [[UINavigationController alloc]initWithRootViewController:taskController];
    FFUnfinishController * finishController = [FFUnfinishController new];
    finishController.tabBarItem.title = @"未完成";
    UINavigationController * finishNav = [[UINavigationController alloc]initWithRootViewController:finishController];
    FFHistoryController * historyController = [FFHistoryController new];
    historyController.tabBarItem.title = @"历史";
    UINavigationController * historyNav = [[UINavigationController alloc]initWithRootViewController:historyController];
//    [self setViewControllers:@[newNav,taskNav,finishNav,historyNav] animated:YES];
    NSMutableArray * tabbarControlers = [NSMutableArray array];
    for (FactoryModel * model in self.moudleArray) {
        if ([model.RtName isEqualToString:@"开单"]) {
            [tabbarControlers addObject:newNav];
        }else if ([model.RtName isEqualToString:@"我的任务"]){
            [tabbarControlers addObject:taskNav];
        }else if ([model.RtName isEqualToString:@"未完成"]){
            [tabbarControlers addObject:finishNav];
        }else if ([model.RtName isEqualToString:@"历史"]){
            [tabbarControlers addObject:historyNav];
        }
    }
}

@end
