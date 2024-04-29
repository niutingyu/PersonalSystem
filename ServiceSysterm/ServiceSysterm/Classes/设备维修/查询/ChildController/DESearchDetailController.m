//
//  DESearchDetailController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchDetailController.h"
#import "DESearchDetailTableCell.h"
#import "DESortDetailMessageModel.h"
#import "DEUnfinishDetailController.h"
@interface DESearchDetailController ()

@end

@implementation DESearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"积分明细";
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"DESearchDetailTableCell" bundle:nil] forCellReuseIdentifier:@"cellReusedId"];
    
    [self loadMessage];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DESearchDetailTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellReusedId"];
    DESortDetailMessageModel *model =self.datasource[indexPath.row];
    [cell confgiureCell:model rowIdx:indexPath.row datasource:self.datasource];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUnfinishDetailController * controller =[DEUnfinishDetailController new];
    DESortDetailMessageModel *model =self.datasource[indexPath.row];
    if ([model.TaskCode containsString:@"SLWX"]) {
        controller.controllerType = @"设备维修";
    }else{
        controller.controllerType =@"点检保养";
    }
    controller.maintainId =model.MaintainTaskId;
    
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)loadMessage{
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:_taskCodeString forKey:@"TaskCode"];
    [parms setObject:_checkProgramString forKey:@"CheckProgram"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:[DeviceSortDetailMessageURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue] ==0) {
            NSArray * arr =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[DESortDetailMessageModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
        }
        [self.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
}
@end
