//
//  DeviceCorrectDetailListController.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectDetailListController.h"
#import "DeviceCorrectionDetailListModel.h"
#import "DeviceCorrectionOperationArray.h"
#import "DeviceCorrectionUserLogCell.h"
#import "YBPopupMenu.h"
#import "CorrectionButAlertView.h"
@interface DeviceCorrectDetailListController ()<YBPopupMenuDelegate>
/**
 标题数组
 */
@property (nonatomic,strong)NSMutableArray *sectionList;

/**
 基础信息
 */
@property (nonatomic,strong)NSMutableArray *basicMsgList;

/**
 操作权限数组
 */

@property (nonatomic,strong)NSMutableArray *OperateArray;

@end

@implementation DeviceCorrectDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeviceCorrectionUserLogCell class]) bundle:nil] forCellReuseIdentifier:@"logCell"];
    self.tableView.estimatedRowHeight =100.0f;
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self getDetailList];
    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDetailList];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.basicMsgList.count;
    }else{
        DeviceCorrectionDetailListModel *model  =[self.datasource firstObject];
        
        return model.UserOperateArray.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"defaultCellId"];
        if (cell  ==nil) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCellId"];
        }
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        cell.textLabel.font =[UIFont systemFontOfSize:16];
        NSString *title =self.basicMsgList[indexPath.row];
        cell.textLabel.text  =title;
        return cell;
    }else{
        DeviceCorrectionUserLogCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"logCell"];
        DeviceCorrectionDetailListModel *model =[self.datasource firstObject];
        DeviceCorrectionUserLogModel*logModel  =model.UserOperateArray[indexPath.row];
        cell.model =logModel;
        return cell;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionList[section];
}

/**
 获取详情数据
 */
-(void)getDetailList{
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [parms setObject:self.taskId forKey:@"OutCorrectionTaskId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    NSString *url =@"maint/outcorrectiontask/detailMsg";
    [Units showStatusWithStutas:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSDictionary *jsonDict =[Units jsonToDictionary:responseObject[@"data"]];
            DeviceCorrectionDetailListModel *model  = [DeviceCorrectionDetailListModel mj_objectWithKeyValues:jsonDict];
            //基础信息
            [weakSelf setupBasicMsgWithModel:model];
            
            //权限
            [weakSelf setupOperationListWithModel:model];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObject:model];
            
            
        }
        debugLog(@"sucess %@",responseObject);
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

/**
 基础信息
 */

-(void)setupBasicMsgWithModel:(DeviceCorrectionDetailListModel*)model{
    NSString *taskCodeStr  =[NSString stringWithFormat:@"单据编码:%@",model.TaskCode?:@""];
    NSString *issueTimeStr  =[NSString stringWithFormat:@"开单时间:%@",model.IssueTime?:@""];
    NSString *assetCodeStr  =[NSString stringWithFormat:@"财务资产编码:%@",model.AssetCode?:@""];
    NSString *facilityStr  =[NSString stringWithFormat:@"设备名称:%@",model.FacilityName?:@""];
    NSString *typeStr  =[NSString stringWithFormat:@"规格型号:%@",model.Specifications?:@""];
    NSString *locationStr  =[NSString stringWithFormat:@"所属区域:%@",model.StorageLocation?:@""];
    NSString *remarkStr  =[NSString stringWithFormat:@"备注:%@",model.Remark];
    NSArray *list =@[taskCodeStr,issueTimeStr,assetCodeStr,facilityStr,typeStr,locationStr,remarkStr];
    [self.basicMsgList removeAllObjects];
    [self.basicMsgList addObjectsFromArray:list];
    [self.tableView reloadData];
}

/**
 操作权限数组
 */
-(void)setupOperationListWithModel:(DeviceCorrectionDetailListModel*)model{
    
    if (!_OperateArray) {
        _OperateArray  =[NSMutableArray array];
    }
    [_OperateArray removeAllObjects];
    for (DeviceCorrectionOperationArray *arrayModel in model.OperateArray) {
        NSString *operateStr  =[self getOperateStrWithPassFlag:arrayModel.PassFlag];
        if (![_OperateArray containsObject:operateStr]) {
            [_OperateArray addObject:operateStr];
        }
    }
    
    if (_OperateArray.count >0) {
        UIButton *rightBut  =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut setTitle:@"操作" forState:UIControlStateNormal];
        rightBut.titleLabel.font =[UIFont systemFontOfSize:16];
        [rightBut addTarget:self action:@selector(operateMethod:) forControlEvents:UIControlEventTouchUpInside];
        [rightBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightBut];
        self.navigationItem.rightBarButtonItem  =rightItem;
        
    }else{
        self.navigationItem.rightBarButtonItem =nil;
    }
    
}
/**
 权限中文
 */
-(NSString*)getOperateStrWithPassFlag:(NSInteger)passFlag{
    NSString *operateStr;
    switch (passFlag) {
        case 1:
            operateStr =@"接单";
            break;
        case 2:
            operateStr =@"申请复核";
            break;
        case 3:
            operateStr =@"通过";
            break;
        case 4:
            operateStr =@"退回";
            
        default:
            break;
    }
    return operateStr;
}

-(void)operateMethod:(UIButton*)but{
    //下拉选择框
    [YBPopupMenu showRelyOnView:but titles:_OperateArray icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
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
    NSString * operateStr  = _OperateArray[index];
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    NSString *url =@"maint/outcorrectiontask/acceptTask";
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:self.taskId forKey:@"OutCorrectionTaskId"];
    if ([operateStr isEqualToString:@"接单"]) {
        
        [parms setObject:@"1" forKey:@"Type"];
        [parms setObject:@"1" forKey:@"IsPass"];
      
    }else if ([operateStr isEqualToString:@"申请复核"]){
        [parms setObject:@"2" forKey:@"Type"];
        [parms setObject:@"1" forKey:@"IsPass"];
    }else if ([operateStr isEqualToString:@"通过"]){
        [parms setObject:@"3" forKey:@"Type"];
        
    }else if ([operateStr isEqualToString:@"退回"]){
        [parms setObject:@"4" forKey:@"Type"];
    }
    [self alertViewWithTipStr:operateStr parms:parms url:url];
    
    [ybPopupMenu dismiss];
}

/**
 弹框
 */
-(void)alertViewWithTipStr:(NSString*)tipStr parms:(NSMutableDictionary*)parms url:(NSString*)url{
    if ([tipStr isEqualToString:@"接单"]||[tipStr isEqualToString:@"退回"]||[tipStr isEqualToString:@"申请复核"]) {
        KWeakSelf
        UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",tipStr] preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textf  = controller.textFields.firstObject;
            [parms setObject:textf.text?:@"" forKey:@"OperateDescribe"];
            [Units showStatusWithStutas:Loading];
            [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
                [Units hideView];
                if ([[responseObject objectForKey:@"status"]intValue]==0) {
                    [Units showHudWithText:responseObject[@"info"] view:weakSelf.view model:MBProgressHUDModeText];
                }else{
                    [Units showErrorStatusWithString:responseObject[@"info"]];
                }
                [weakSelf.tableView .mj_header beginRefreshing];
                debugLog(@"sucess %@",responseObject[@"info"]);
            } error:^(NSString * _Nonnull error) {
                [Units hideView];
                [Units showErrorStatusWithString:error];
            }];
        }]];
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        KWeakSelf
        [CorrectionButAlertView showAlertViewWithTipStr:tipStr suBlock:^(NSString * _Nonnull passFlag, NSString * _Nonnull remark) {
            NSString *flagStr;
            if ([passFlag isEqualToString:@"0"]) {
                //通过
                flagStr =@"1";
            }else{
                flagStr  =@"0";
            }
            [parms setObject:flagStr forKey:@"IsPass"];
            [parms setObject:remark?:@"" forKey:@"OperateDescribe"];
            [Units showStatusWithStutas:Loading];
            [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
                [Units hideView];
                [Units hideView];
                if ([[responseObject objectForKey:@"status"]intValue]==0) {
                    [Units showHudWithText:responseObject[@"info"] view:weakSelf.view model:MBProgressHUDModeText];
                }else{
                    [Units showErrorStatusWithString:responseObject[@"info"]];
                }
                [weakSelf.tableView .mj_header beginRefreshing];
            } error:^(NSString * _Nonnull error) {
                [Units hideView];
                [Units showErrorStatusWithString:error];
            }];
           
        }];
        
    }
    
}
-(NSMutableArray*)sectionList{
    if (!_sectionList) {
        _sectionList  =[NSMutableArray array];
        NSArray *titles  =@[@"基础信息",@"操作日志"];
        [_sectionList addObjectsFromArray:titles];
    }
    return _sectionList;
}

-(NSMutableArray*)basicMsgList{
    if (!_basicMsgList) {
        _basicMsgList  =[NSMutableArray array];
    }return _basicMsgList;
}


@end
