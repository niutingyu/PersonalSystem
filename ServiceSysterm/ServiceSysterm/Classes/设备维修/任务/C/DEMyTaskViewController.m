//
//  DEMyTaskViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMyTaskViewController.h"
#import "DEUnfinishDetailController.h"

#import "DETaskModel.h"
#import "MoudleModel.h"
#import "DETaskTableCell.h"
@interface DEMyTaskViewController ()
@property (nonatomic,copy)NSString *factoryId;
@end

@implementation DEMyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的任务";
    [self loadMessage];
    self.tableView.rowHeight = 130.0f;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DETaskTableCell class]) bundle:nil] forCellReuseIdentifier:@"cellId"];
    
    self.tableView.mj_header= [MJRefreshHeader headerWithRefreshingBlock:^{
        [self loadMessage];
    }];
    //取出工厂
    
     NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
     MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
     [modleArchiver finishDecoding];
    debugLog(@"- - %ld",moudleStatus.FactoryList.count);
    if (moudleStatus.FactoryList.count >1) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"切换工厂" forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chosFactory:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}

-(void)chosFactory:(UIButton*)sender{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
      MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    KWeakSelf
    NSMutableArray * factories =[NSMutableArray array];
    [factories removeAllObjects];
    [factories addObjectsFromArray:moudleStatus.FactoryList];
    [factories addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
    for (int i =0; i<factories.count; i++) {
        NSString * title  =factories[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.factoryId = factories[i][@"FactoryId"];
            [weakSelf loadMessage];
            
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DETaskTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    [cell configureCell:self.datasource rowIdx:indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DETaskModel * model = self.datasource[indexPath.section];
    DEUnfinishDetailController * controller =[DEUnfinishDetailController new];
    controller.controllerType = @"设备维修";
    controller.maintainId = model.MaintainTaskId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)loadMessage{
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:@"1" forKey:@"Type"];
    NSString * factoryStr  =[NSString stringWithFormat:@"%@",_factoryId];
    if (factoryStr.length >0) {
      [parms setObject:_factoryId?:@"" forKey:@"FactoryId"];
    }
   
   // NSDictionary * dict = @{@"UserId":USERDEFAULT_object(USERID),@"Type":@"1"};
    [HttpTool POST:[DeviceTaskURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DETaskModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        debugLog(@"- - --%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:self.view];
        [Units showErrorStatusWithString:error];
        [self.tableView.mj_header endRefreshing];
    }];
}
@end
