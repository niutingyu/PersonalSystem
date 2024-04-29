//
//  WasterUnfinishController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterUnfinishController.h"
#import "WasterTaskListModel.h"
#import "WasterTaskListTableCell.h"
#import "WasterDetailListController.h"
@interface WasterUnfinishController ()

@end


@implementation WasterUnfinishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"未完成";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"WasterTaskListTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.tableView.estimatedRowHeight  =120.f;
  
    [self getUnfinishTask];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WasterTaskListTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
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

-(void)getUnfinishTask{
    NSString *url =@"app/WasteSale/getNoDoneTask";
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [parms setObject:[NSString stringWithFormat:@"%@ 00:00:00",[Units getNowDate:-3]] forKey:@"StartTime"];
    [parms setObject:[NSString stringWithFormat:@"%@ 23:59:59",[Units getNowDate:0]] forKey:@"EndTime"];
    
    KWeakSelf
    [Units showLoadStatusWithString:Loading];
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
    }];
    
}

@end
