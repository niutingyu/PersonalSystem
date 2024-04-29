//
//  RegisterOutStockController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "RegisterOutStockController.h"
#import "OutStockTableViewCell.h"
#import "OutStockAlertView.h"
#import "OutStockModel.h"
@interface RegisterOutStockController ()

@end

static NSString *const stockUsedId =@"reusedCellId";
@implementation RegisterOutStockController


-(void)webData{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    NSArray * sorts = @[@{@"Column":@"StockOutBillCode",@"Direction":@"Desc"}];
    [parms setObject:[Units arrayToJson:sorts] forKey:@"sorts"];
    KWeakSelf
    [self.datasource removeAllObjects];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[RegisterOutStockUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * responses = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * models = [OutStockModel mj_objectArrayWithKeyValuesArray:responses];
            [weakSelf.datasource addObjectsFromArray:models];
            
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        debugLog(@"- - - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登记出库";
    
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 124.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"OutStockTableViewCell" bundle:nil] forCellReuseIdentifier:stockUsedId];
    [self webData];
    //下拉刷新
    KWeakSelf
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf webData];
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutStockTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stockUsedId];
    OutStockModel *model = self.datasource[indexPath.row];
    NSString * index = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.datasource.count];
    [cell configureCellWithModel:model idx:index];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OutStockModel * model = self.datasource[indexPath.row];
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:model.StockOutBillId forKey:@"supDocId"];
    [parms setObject:@"2" forKey:@"stockType"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[OutstockDetailUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSArray * responseds = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * models = [StockDetailModel mj_objectArrayWithKeyValuesArray:responseds];
            //确认出库
            [OutStockAlertView showAlertWithDatasource:models stockBlock:^(NSMutableArray * _Nonnull mutableParms) {
                [weakSelf alertViewWithModel:model array:responseds];
            }];
            
        }
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
   
    
}

//确认出库
-(void)alertViewWithModel:(OutStockModel*)model array:(NSArray*)array{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要出库吗?" preferredStyle:UIAlertControllerStyleAlert];
    KWeakSelf
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //确定出库
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        NSMutableDictionary * totalPamrs = [NSMutableDictionary dictionary];
        [parms setObject:model.StockOutBillId forKey:@"StockOutBillId"];
        [parms setObject:model.SupDocId forKey:@"SupDocId"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"StockOutBy"];
        [parms setObject:@1 forKey:@"StockOutType"];
        [parms setObject:@"备注信息" forKey:@"Remark"];
        [parms setObject:model.FactoryId forKey:@"FactoryId"];
        [parms setObject:model.TaskModel[@"processInstanceId"] forKey:@"InstanceId"];
        //当前时间
        [parms setObject:[Units currentTimeWithFormat:@"YYYY-MM-dd HH:mm:ss"] forKey:@"StockOutOn"];
       
        
        
        NSMutableArray *details = [NSMutableArray array];
        
        for (NSMutableDictionary * dict in array) {
            [dict setObject:@"2" forKey:@"ListOperation"];
            [details addObject:dict];
        }
        
        [parms setObject:details forKey:@"DetailList"];
        BOOL istrue = true;
        NSMutableDictionary * secondParms = [NSMutableDictionary dictionary];
        [secondParms setObject:model.TaskModel[@"taskId"] forKey:@"TaskId"];
        [secondParms setObject:model.TaskModel[@"taskName"] forKey:@"TaskName"];
        [secondParms setObject:@(istrue) forKey:@"AuditResult"];
        [secondParms setObject:model.TaskModel[@"billStaus"] forKey:@"BillStaus"];
        [secondParms setObject:model.TaskModel[@"processInstanceId"] forKey:@"ProcessInstanceId"];
        [secondParms setObject:model.TaskModel[@"sign"] forKey:@"Sign"];
         //转为字符串
        [totalPamrs setObject:[Units dictionaryToJson:parms] forKey:@"model"];
        [totalPamrs setObject:[Units dictionaryToJson:secondParms] forKey:@"task"];
        
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        [HttpTool POST:[CommitStockUrl getWholeUrl] param:totalPamrs success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
                [weakSelf.tableView.mj_header beginRefreshing];

            }

        } error:^(NSString * _Nonnull error) {
            [Units showErrorStatusWithString:error];
        }];
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
