//
//  DeviceBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "MainTabbarController.h"

@interface DeviceBaseController ()

@end

@implementation DeviceBaseController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self showTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    self.tableView.defaultNoDataText = @"暂无更多数据";
    
}

-(void)backController{
    UIStoryboard * stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabbarController * tabController = [stroyboard instantiateViewControllerWithIdentifier:@"tabar"];
    [Units translateTabbarController:tabController];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reusedIDtifire = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reusedIDtifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIDtifire];
    }
    return cell;
    
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}
#pragma mark - 键盘' 完成按键'
- (ToolBar *)tool{
    if (!_tool) {
        _tool = [ToolBar toolBar];
        
        __weak typeof(self) weakself = self;
        _tool.finishBlock = ^(){
            [weakself.view endEditing:YES];
        };
    }
    return _tool;
}

-(NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}
-(void)dealloc{
    [HttpTool CancelRequest];
}
@end
