//
//  MCMyTaskListViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCMyTaskListViewController.h"
#import "MCMyTaskTableViewCell.h"

#import "MCListModel.h"

#import "MCDetailViewController.h"
@interface MCMyTaskListViewController ()

@end

@implementation MCMyTaskListViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的任务";
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MCMyTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    self.tableView.estimatedRowHeight  =140.0f;
    

    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDatas];
    }];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCMyTaskTableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    MCListModel * model  =self.datasource[indexPath.row];
    [cell setupCellWithModel:model idx:[NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.datasource.count]];
    
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v  =[UIView new];
    v.backgroundColor  = RGBA(242, 242, 242, 1);
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * v  =[UIView new];
    v.backgroundColor  = RGBA(242, 242, 242, 1);
    return v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCListModel * model  = self.datasource[indexPath.row];
    MCDetailViewController * controller  =[[MCDetailViewController alloc]init];
    controller.constructionId  =model.constructionTaskId;
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)getDatas{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    
    NSString * url  = @"maint/construstiontask/myTask";
    
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject  objectForKey:@"status"]integerValue]==0) {
            NSArray * arr  = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * jsonArr  = [MCListModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:jsonArr];
            
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
        debugLog(@" -- - - -%@",responseObject);
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
        [weakSelf.tableView .mj_header endRefreshing];
        
    }];
}
@end
