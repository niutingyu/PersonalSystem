//
//  DeviceRepairTabController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceRepairTabController.h"
#import "DENewOrderController.h"
#import "DEUnfinishController.h"
#import "DEMyTaskViewController.h"

#import "DEMemberController.h"
#import "DEPickViewController.h"
#import "DeviceNavController.h"
#import "BaseNavViewController.h"
#import "DESearchController.h"


#import "DeviceModel.h"


@interface DeviceRepairTabController ()<UINavigationControllerDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong)NSMutableArray * moudleArray;

@property (nonatomic,strong)NSMutableArray *tabbarControllers;

@end


@implementation DeviceRepairTabController

-(NSMutableArray*)moudleArray{
    if (!_moudleArray) {
        _moudleArray = [NSMutableArray array];
    }
    return _moudleArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    KWeakSelf
    self.moudleArrayBlock = ^(NSMutableArray * _Nonnull moudleArray) {
        [weakSelf setupTabarWithArray:moudleArray];
    };
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:2.0];
    _tabbarControllers = [NSMutableArray array];
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [[UITabBar appearance] setTintColor:RGBA(31, 120, 255, 1)];
    
    self.moreNavigationController.delegate = self;
    self.delegate = self;
   
    UIViewController * moreController = self.moreNavigationController.topViewController;
    
    if ([moreController.view isKindOfClass:[UITableView class]]) {
        UITableView * moreTableView = (UITableView*)moreController.view;
        moreTableView.tableFooterView = [UIView new];
    }
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ios-arrow-back"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [btn addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.moreNavigationController.navigationBar.topItem.leftBarButtonItem = leftItem;
    
}
-(void)backController{
    //[Units translateTabbarController:self];
}
-(void)setupTabarWithArray:(NSMutableArray*)moudleArray{
   
    DENewOrderController * newController = [DENewOrderController new];
    newController.tabBarItem.title = @"开单";
    newController.tabBarItem.image = [UIImage imageNamed:@"zonghekaidan"];
    DeviceNavController * orderNav = [[DeviceNavController alloc]initWithRootViewController:newController];
    DEMyTaskViewController * taskController = [DEMyTaskViewController new];
    taskController.tabBarItem.title = @"我的任务";
    taskController.tabBarItem.image = [UIImage imageNamed:@"gougao-h"];
    DeviceNavController * taskNav = [[DeviceNavController alloc]initWithRootViewController:taskController];
    DEUnfinishController * finishController = [DEUnfinishController new];
    finishController.tabBarItem.title = @"未完成";
    finishController.tabBarItem.image = [UIImage imageNamed:@"jilu"];
    DeviceNavController * finishNav = [[DeviceNavController alloc]initWithRootViewController:finishController];
//    DEHistoryController * historyController = [DEHistoryController new];
//    historyController.tabBarItem.title = @"历史";
//    historyController.tabBarItem.image = [UIImage imageNamed:@"gougao-h"];
//    DeviceNavController * historyNav = [[DeviceNavController alloc]initWithRootViewController:historyController];
    DEMemberController * memberController = [DEMemberController new];
    memberController.tabBarItem.title = @"人员";
    memberController.tabBarItem.image = [UIImage imageNamed:@"huaban"];
    DeviceNavController * memberNav = [[DeviceNavController alloc]initWithRootViewController:memberController];
    DEPickViewController * pickC = [DEPickViewController new];
    pickC.tabBarItem.title = @"领料";
    pickC.tabBarItem.image = [UIImage imageNamed:@"zonghekaidan"];
    DeviceNavController * pickNav = [[DeviceNavController alloc]initWithRootViewController:pickC];
    DESearchController * searchC = [DESearchController new];
    searchC.tabBarItem.title = @"查询";
    searchC.tabBarItem.image = [UIImage imageNamed:@"chaxun"];
    DeviceNavController * searchNav = [[DeviceNavController alloc]initWithRootViewController:searchC];
    

    [moudleArray enumerateObjectsUsingBlock:^(DeviceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.RtName isEqualToString:@"开单"]&&![self.tabbarControllers containsObject:orderNav]) {
            [self->_tabbarControllers addObject:orderNav];
        }if ([obj.RtName isEqualToString:@"任务"]&&![self.tabbarControllers containsObject:taskNav]) {
            [self->_tabbarControllers addObject:taskNav];
        }
        if ([obj.RtName isEqualToString:@"未完成"]&&![self.tabbarControllers containsObject:finishNav]) {
            [self->_tabbarControllers addObject:finishNav];
        }
//        if ([obj.RtName isEqualToString:@"历史"]&&![self.tabbarControllers containsObject:historyNav]) {
//            [self->_tabbarControllers addObject:historyNav];
//        }
        
        if ([obj.RtName isEqualToString:@"人员"]&&![self.tabbarControllers containsObject:memberNav]) {
            [self->_tabbarControllers addObject:memberNav];
        }
        if ([obj.RtName isEqualToString:@"领料"]&&![self.tabbarControllers containsObject:pickNav]) {
            [self->_tabbarControllers addObject:pickNav];
        }
    
    }];
    if ([[self.tabbarControllers firstObject] isKindOfClass:[searchNav class]]) {
      [self.tabbarControllers replaceObjectAtIndex:0 withObject:orderNav];
        [self.tabbarControllers addObject:searchNav];
    }
     [self setViewControllers:self.tabbarControllers animated:NO];
   //
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
   
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if ([[self.moreNavigationController.viewControllers firstObject] isKindOfClass:[viewController class]]) {
//        navigationController.hidesBottomBarWhenPushed = NO;
//       // [self showTabBar];
//    }else{
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[self.moreNavigationController class]]) {
        self.moreNavigationController.navigationBar.topItem.rightBarButtonItem =nil;
       
    }
   
    return YES;
}

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
