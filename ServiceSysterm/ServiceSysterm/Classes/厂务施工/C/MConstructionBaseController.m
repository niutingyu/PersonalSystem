//
//  MConstructionBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MConstructionBaseController.h"

#import "UITableView+AddForPlaceholder.h"
@interface MConstructionBaseController ()

@end

@implementation MConstructionBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.defaultNoDataText =@"暂无更多数据";
    
    UIButton * but  =[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"取消" forState:UIControlStateNormal];
    but.titleLabel.font  =[UIFont systemFontOfSize:15];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * left  =[[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.leftBarButtonItem  =left;
    
}

-(void)cancelMethod{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    if (cell  ==nil) {
        cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    }
    return cell;
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView  =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        
        _tableView.delegate  =self;
        
        _tableView.dataSource  =self;
        
        _tableView.tableFooterView  =[UIView new];
        
        _tableView.separatorStyle  =UITableViewCellSeparatorStyleNone;
        
        _tableView.autoresizingMask  =UIViewAutoresizingFlexibleHeight;
        
        
    }
    
    return _tableView;
}


-(NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource  =[NSMutableArray array];
    }
    return _datasource;
}
@end
