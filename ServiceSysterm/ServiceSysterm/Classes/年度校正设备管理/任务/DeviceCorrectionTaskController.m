//
//  DeviceCorrectionTaskController.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectionTaskController.h"
#import "DeviceCorrectionTaskListCell.h"
#import "DeviceCorrectionTaskListModel.h"
#import "DeviceCorrectDetailListController.h"
@interface DeviceCorrectionTaskController ()

@end

@implementation DeviceCorrectionTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"任务";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeviceCorrectionTaskListCell class]) bundle:nil] forCellReuseIdentifier:@"listCellReusedId"];
    self.tableView.estimatedRowHeight  =110.0f;
    [self getTaskDataList];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCorrectionTaskListCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"listCellReusedId"];
    DeviceCorrectionTaskListModel *model  = self.datasource[indexPath.row];
    [cell configureCellWithModel:model idx:[NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.datasource.count]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCorrectionTaskListModel *model  =self.datasource[indexPath.row];
    DeviceCorrectDetailListController *controller  =[[DeviceCorrectDetailListController alloc]init];
    controller.taskId  = model.OutCorrectionTaskId;
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**
 获取任务数据
 */

-(void)getTaskDataList{
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    NSString *url  =@"maint/outcorrectiontask/myTasks";
    [Units showStatusWithStutas:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray *jsonList = [Units jsonToArray:responseObject[@"data"]];
            //转为Model
            NSMutableArray *modelList  =[DeviceCorrectionTaskListModel mj_objectArrayWithKeyValuesArray:jsonList];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:modelList];
            [weakSelf.tableView reloadData];
        }
        debugLog(@"res %@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
}
@end
