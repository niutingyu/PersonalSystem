//
//  IQCBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/1.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCBaseController.h"

@interface IQCBaseController ()

@end

@implementation IQCBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId0"];
    if (cell  ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId0"];
    }
    return cell;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView  =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate  =self;
        _tableView.dataSource  =self;
        _tableView.autoresizingMask  =UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle  =UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView  =[[UIView alloc]init];
        
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
