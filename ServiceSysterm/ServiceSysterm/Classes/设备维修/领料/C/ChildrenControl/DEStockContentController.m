//
//  DEStockContentController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEStockContentController.h"
#import "DEResotreListTableCell.h"
#import "DEStockModel.h"
#import "DEAlertFilterView.h"
#import "DEMaterialDetailModel.h"
#import "MoudleModel.h"


#import "DEBackStoreListDetailController.h"
#import "DEMaightBackStoreController.h"

@interface DEStockContentController ()
{
    NSInteger _flag;
}
@end

@implementation DEStockContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 105.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEResotreListTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTime:) name:[NSString stringWithFormat:@"%ld",self.controllerTag] object:nil];
}
-(void)getTime:(NSNotification*)notification{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEResotreListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DEMatrialListModel * model = self.datasource[indexPath.section];
    if (_flag ==1001||_flag ==1002) {
        //领料单 可回仓
    [cell configureCell:model idx:indexPath.section datasource:self.datasource];
    }else{
        //回仓表
        DEStockListModel * model = self.datasource[indexPath.section];
        [cell configStockCell:model idx:indexPath.section stockArray:self.datasource];
    }
    
   
    
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEMatrialListModel * model = self.datasource[indexPath.section];
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    NSString * url =nil;
    if (_flag ==1001) {
        //物料清单
        [parms setObject:model.MatRequisitionId forKey:@"mRId"];
        url = [DeviceMaterialListURL  getWholeUrl];
    }else if (_flag ==1002){
        //可回仓
        DEMaightBackStoreController * controller = [DEMaightBackStoreController new];
        controller.listModel =model;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }else{
        DEBackStoreListDetailController * controller =[DEBackStoreListDetailController new];
        DEStockListModel *stockModel = self.datasource[indexPath.section];
        controller.returnBillId =stockModel.ReturnBillId;
        [self.navigationController pushViewController:controller animated:YES];
        return;
        
    }
    [self reloadMaterialListWithUrl:url mutableParms:parms model:model];
  
}
#pragma mark == == = = = ==获取物料单详情

-(void)reloadMaterialListWithUrl:(NSString*)url mutableParms:(NSMutableDictionary*)mutableParms model:(DEMatrialListModel*)model{
   KWeakSelf
    [Units showHudWithText:@"请稍后..." view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:url param:mutableParms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue] ==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DEMaterialDetailModel mj_objectArrayWithKeyValuesArray:arr];
         
            [DEAlertFilterView showAlertViewDatasouce:arr1 flag:self->_flag timeBlock:^(NSMutableArray * _Nonnull mutableArray) {
                
            }];
        }
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:weakSelf.view];
    }];
}


-(void)reloadMessageWithUrl:(NSString*)url parms:(NSMutableDictionary*)parms flag:(NSInteger)flag{
    
    [self.datasource removeAllObjects];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:url param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            if (flag ==100) {
                NSDictionary * responIdctionary = [Units jsonToDictionary:responseObject[@"data"]];
                
                NSMutableArray * arr = [DEMatrialListModel mj_objectArrayWithKeyValuesArray:responIdctionary[@"list"]];
                [weakSelf.datasource addObjectsFromArray:arr];
                self->_flag =1001;
                
            }else if (flag ==101){
                NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
                NSMutableArray * arr1 = [DEMatrialListModel mj_objectArrayWithKeyValuesArray:arr];
                [weakSelf.datasource addObjectsFromArray:arr1];
                self->_flag =1002;
                
            }else if (flag ==102){
                NSDictionary * dict = [Units jsonToDictionary:responseObject[@"data"]];
                NSMutableArray * arr = [DEStockListModel mj_objectArrayWithKeyValuesArray:dict[@"list"]];
                [weakSelf.datasource addObjectsFromArray:arr];
                self->_flag =1003;
            }
        }
        [weakSelf.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        
    }];
}

// 获得当天的日期
- (NSString *)getNowDate:(NSInteger)mounth {
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    [adcomps setMonth:mounth];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *NewDate = [dateFormatter stringFromDate:newdate];
    
    return NewDate;
}


@end
