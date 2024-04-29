//
//  FactoryBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "FactoryBaseController.h"
#import "MainTabbarController.h"
@interface FactoryBaseController ()

@end

@implementation FactoryBaseController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(back)];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"ios-arrow-back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}


-(void)backController{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
 //   [self dismissViewControllerAnimated:YES completion:nil];
//    UIStoryboard * stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainTabbarController * tabController = [stroyboard instantiateViewControllerWithIdentifier:@"tabar"];
//
//    [UIApplication sharedApplication].delegate.window.rootViewController =tabController;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseInditifire = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseInditifire];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInditifire];
    }
    return cell;
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
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
