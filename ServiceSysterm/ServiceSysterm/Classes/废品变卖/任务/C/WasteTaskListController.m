//
//  WasteTaskListController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/20.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasteTaskListController.h"
#import "WasterTaskListModel.h"
#import "WasterTaskListTableCell.h"
#import "WasterDetailListController.h"
@interface WasteTaskListController ()

@end

NSString *const TaskCellReuserId =@"TaskCellReuserId";

@implementation WasteTaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"任务";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"WasterTaskListTableCell" bundle:nil] forCellReuseIdentifier:TaskCellReuserId];
    self.tableView.estimatedRowHeight  =120.f;
    [self getTaskListData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WasterTaskListTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:TaskCellReuserId];
    WasterTaskListModel *model  =self.datasource[indexPath.row];
    [cell configureTaskListCellWithModel:model idx:indexPath.row count:self.datasource.count];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WasterTaskListModel *model  = self.datasource[indexPath.row];
    WasterDetailListController *controller  =[[WasterDetailListController alloc]init];
    controller.taskId  = model.Id;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)getTaskListData{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(JOBNUM) forKey:@"loginName"];
    NSString *url  =@"app/WasteSale/getTaskList";
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray *jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray  =[WasterTaskListModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:modelArray];
        }
        [weakSelf.tableView reloadData];
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
    
}
@end
