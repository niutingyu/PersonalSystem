//
//  WasterDetailListController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterDetailListController.h"
#import "WasterDetailListModel.h"
#import "GarbageListTableCell.h"
#import "YBPopupMenu.h"
@interface WasterDetailListController ()<YBPopupMenuDelegate>

@property (nonatomic,strong)NSMutableArray *basicMessageList;


@property (nonatomic,strong)NSArray *powerList;//权限
@end

NSString *const GarbageListReusedId =@"GarbageListReusedId";

@implementation WasterDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDetailData];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"GarbageListTableCell" bundle:nil] forCellReuseIdentifier:GarbageListReusedId];
    
    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDetailData];
    }];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  ==0) {
        
        return self.basicMessageList.count;
    }else{
        WasterDetailListModel *model  = [self.datasource firstObject];
        return model.GarbageList.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell  ==nil) {
            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        }
        cell.textLabel.font  =[UIFont systemFontOfSize:16];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:15];
        
        WasterBasicMessageModel *basicModel  = self.basicMessageList[indexPath.row];
        cell.textLabel.text  = basicModel.name;
        cell.detailTextLabel.text  =basicModel.content;
        return cell;
    }else{
        GarbageListTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:GarbageListReusedId];
        WasterDetailListModel *detailModel  = [self.datasource firstObject];
        
        cell.model =detailModel.GarbageList[indexPath.row];
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        return 48.f;
    }else{
        return 180.f;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titels  =@[@"基本信息",@"物品信息"];
    return titels[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}


//操作

-(void)onRightButtonItemClick:(UIButton*)sender{
    WasterDetailListModel *model  = [self.datasource firstObject];
    NSString *powerSr  =model.QuanXian;
    NSArray * powerArray  = [powerSr componentsSeparatedByString:@","];
    self.powerList = [powerArray copy];
    //下拉选择框
    [YBPopupMenu showRelyOnView:sender titles:self.powerList icons:nil menuWidth:140 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.backColor = [UIColor whiteColor];
        popupMenu.textColor = [UIColor blackColor];
        popupMenu.maxVisibleCount =10;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
}
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [self auditWithTitleStr:self.powerList[index]];
    [ybPopupMenu dismiss];
}


//审核
-(void)auditWithTitleStr:(NSString*)titleStr{
    if ([titleStr isEqualToString:@"废品组长审核"]||[titleStr isEqualToString:@"人政经理审核"]||[titleStr isEqualToString:@"门卫审核"]) {
        KWeakSelf
        NSString *urlStr  =@"app/WasteSale/audit";
        WasterDetailListModel *model  = [self.datasource firstObject];
        RecordEventModel *recordModel  = model.recordEvent;
        
        NSMutableDictionary *totalParms  =[NSMutableDictionary dictionary];
        UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:titleStr preferredStyle:UIAlertControllerStyleAlert];
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder  =@"请填写备注";
        }];
        [controller addAction:[UIAlertAction actionWithTitle:@"通过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textf  = controller.textFields.firstObject;
            [totalParms setObject:recordModel.Id forKey:@"Id"];
            NSMutableDictionary *modelParms  =[NSMutableDictionary dictionary];
            
            [modelParms setObject:recordModel.Id forKey:@"TaskId"];
            [modelParms setObject:recordModel.ProcessInstanceId forKey:@"ProcessInstanceId"];
            [modelParms setObject:USERDEFAULT_object(JOBNUM) forKey:@"Auditor"];
            [modelParms setObject:USERDEFAULT_object(USERID) forKey:@"AuditorId"];
            [modelParms setObject:@(YES) forKey:@"AuditResult"];
            [modelParms setObject:textf.text?:@"" forKey:@"Comment"];
            [totalParms setObject:[Units dictionaryToJson:modelParms] forKey:@"taskModel"];
            [weakSelf httpWithUrl:urlStr parms:totalParms];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"驳回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textf  = controller.textFields.firstObject;
            if (textf.text.length ==0) {
                [Units showErrorStatusWithString:@"驳回备注必填"];
                [weakSelf presentViewController:controller animated:YES completion:nil];
                return;
            }
            [totalParms setObject:recordModel.Id forKey:@"Id"];
            NSMutableDictionary *modelParms  =[NSMutableDictionary dictionary];
            
            [modelParms setObject:recordModel.Id forKey:@"TaskId"];
            [modelParms setObject:recordModel.ProcessInstanceId forKey:@"ProcessInstanceId"];
            [modelParms setObject:USERDEFAULT_object(JOBNUM) forKey:@"Auditor"];
            [modelParms setObject:USERDEFAULT_object(USERID) forKey:@"AuditorId"];
            [modelParms setObject:@(NO) forKey:@"AuditResult"];
            [modelParms setObject:textf.text forKey:@"Comment"];
            [totalParms setObject:[Units dictionaryToJson:modelParms] forKey:@"taskModel"];
            [weakSelf httpWithUrl:urlStr parms:totalParms];
            
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }else if ([titleStr isEqualToString:@"作废"]){
        NSString *url  =@"app/WasteSale/invalidActiviti";
        NSMutableDictionary *parms =[NSMutableDictionary dictionary];
        [self httpWithUrl:url parms:parms];
    }
}


-(void)httpWithUrl:(NSString*)url parms:(NSMutableDictionary*)parms{
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"stauts"]intValue]==0) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
        debugLog(@" -- -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        
    }];
}
-(void)getDetailData{
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(JOBNUM) forKey:@"UserName"];
    [parms setObject:_taskId forKey:@"Id"];
    NSString *url =@"app/WasteSale/getTaskDetail";
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSDictionary *jsonDict  = [Units jsonToDictionary:responseObject[@"data"]];
            WasterDetailListModel *model  = [WasterDetailListModel mj_objectWithKeyValues:jsonDict];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObject:model];
            [weakSelf getBasicMessageWithModel:model];
            //是否显示操作按钮
            [weakSelf oparationButWithModel:model];
            
        }
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
-(void)getBasicMessageWithModel:(WasterDetailListModel*)model{
    RecordEventModel *recordModel =model.recordEvent;
    if (!_basicMessageList) {
        _basicMessageList  =[NSMutableArray array];
    }
    
    [_basicMessageList removeAllObjects];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WasterMessage.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        
        NSMutableArray *modelArray  =[WasterBasicMessageModel mj_objectArrayWithKeyValuesArray:dataArray];
       
        [_basicMessageList addObjectsFromArray:modelArray];
    }
    for (int i =0; i<_basicMessageList.count; i++) {
        WasterBasicMessageModel *basicModel  = _basicMessageList[i];
        if (i ==0) {
            basicModel.content  =USERDEFAULT_object(CodeName);
        }else if (i ==1){
            basicModel.content  =recordModel.Code;//变卖单号
        }else if (i ==2){
            //开单时间
            basicModel.content  =recordModel.CreatedOn;
        }else if (i ==3){
            //单状态
            basicModel.content  =recordModel.flowStautsStr;
        }else if (i ==4){
            //回收商
            basicModel.content  =recordModel.Name;
        }else if (i ==5){
            //接收人
            basicModel.content  =recordModel.Recipient;
        }else if (i ==6){
            //付款方式
            basicModel.content  =recordModel.PayType;
        }else if (i ==7){
            //结算方式
            basicModel.content  = recordModel.SettleType;
        }else if (i ==8){
            //联系方式
            basicModel.content  =recordModel.PhoneNum;
        }
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}
//操作按钮
-(void)oparationButWithModel:(WasterDetailListModel*)model{
    if (model.QuanXian.length >0) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"操作" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 60, 35);
        [btn addTarget:self action:@selector(onRightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        self.navigationItem.rightBarButtonItem  =nil;
    }
    
}

@end
