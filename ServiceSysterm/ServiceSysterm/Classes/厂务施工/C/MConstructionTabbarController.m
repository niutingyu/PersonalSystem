//
//  MConstructionTabbarController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MConstructionTabbarController.h"
#import "BaseNavViewController.h"

#import "MCNewOrderController.h"
#import "MCHistoryListController.h"
#import "MCMyTaskListViewController.h"
#import "MCUnfinshListViewController.h"
#import "MSearchController.h"
#import "MCBaseNavigationController.h"
@interface MConstructionTabbarController ()

@end

@implementation MConstructionTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveRights:) name:@"construction" object:nil];
    
}

-(void)receiveRights:(NSNotification*)notification{
    NSDictionary * dic  =[notification object];
    
    NSArray * models = dic[@"rights"];
    //[self setupTababrWithArray:models];
    
    NSMutableArray * titles  =[NSMutableArray array];
    
    [titles removeAllObjects];
    
    for (DeviceModel * model in models) {
        debugLog(@" - -= = %@",model.RtName);
        if ([model.RtName isEqualToString:@"开单"]) {
            [titles insertObject:model atIndex:0];
        }else if ([model.RtName isEqualToString:@"任务"]){
            [titles addObject:model];
        }else if ([model.RtName isEqualToString:@"未完成"]){
            [titles addObject:model];
        }else if ([model.RtName isEqualToString:@"历史"]){
            [titles addObject:model];
        }
        else if ([model.RtName isEqualToString:@"查询"]){
            [titles addObject:model];
        }
    }
    [self setupTababrWithArray:titles];
}

-(void)setupTababrWithArray:(NSArray*)array{
    
    [UITabBar appearance].translucent = NO;//不透明
    // 去掉tab黑色分割线
    self.tabBar.barStyle = UIBarStyleDefault;
    self.tabBar.shadowImage = [[UIImage alloc]init];
    //开单
     MCNewOrderController * controller  =[MCNewOrderController new];
    
    //查询
    MSearchController * searchCtrl  =[MSearchController new];
    
    //任务
    MCMyTaskListViewController * taskController  =[MCMyTaskListViewController new];
    
    //未完成
    MCUnfinshListViewController * unfinishController  =[MCUnfinshListViewController new];
    
    //历史
    MCHistoryListController * historyController  =[MCHistoryListController new];
    //@"chaxun",@"zonghekaidan",@"gougao-h",@"jilu",@"gougao-h",@"huaban",@"zonghekaidan"
    for (DeviceModel * model in array) {
        if ([model.RtName isEqualToString:@"开单"]) {
            
            MCBaseNavigationController * nav  = [[MCBaseNavigationController alloc]initWithRootViewController:controller];
            [self addChildVC:nav title:@"开单" image:@"zonghekaidan" selectedImage:@"zonghekaidan"];
            
        }else if ([model.RtName isEqualToString:@"任务"]){
            
            MCBaseNavigationController * nav  =[[MCBaseNavigationController alloc]initWithRootViewController:taskController];
            [self addChildVC:nav title:@"任务" image:@"gougao-h" selectedImage:@"gougao-h"];
        }else if ([model.RtName isEqualToString:@"未完成"]){
            
            MCBaseNavigationController * nav  =[[MCBaseNavigationController alloc]initWithRootViewController:unfinishController];
            [self addChildVC:nav title:@"未完成" image:@"jilu" selectedImage:@"jilu"];
        }else if ([model.RtName isEqualToString:@"历史"]){
            
            MCBaseNavigationController * nav  =[[MCBaseNavigationController alloc]initWithRootViewController:historyController];
            [self addChildVC:nav title:@"历史" image:@"huaban" selectedImage:@"huaban"];
            
        }
        else if ([model.RtName isEqualToString:@"查询"]){
            
            MCBaseNavigationController * nav  =[[MCBaseNavigationController alloc]initWithRootViewController:searchCtrl];
            [self addChildVC:nav title:@"查询" image:@"chaxun" selectedImage:@"chaxun"];
        }
    }
    
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
