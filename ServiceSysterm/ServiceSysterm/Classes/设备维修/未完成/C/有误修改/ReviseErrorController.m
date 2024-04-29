//
//  ReviseErrorController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/12.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ReviseErrorController.h"
#import "PauseContentTableCell.h"
#import "MaintainErrorTableCell.h"
#import "ZHPickView.h"
#import "UITextView+Placeholder.h"

  NSString * const errorCellReusedIdtifire =@"errorCellReusedIdtifire";

@interface ReviseErrorController ()<ZHPickViewDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSMutableDictionary * selctedContents;//选中内容
@property (nonatomic,strong)NSMutableArray * errorIds;//故障id
@property (nonatomic,strong)NSMutableArray *errorReasons;//故障原因
@property (nonatomic,strong)NSMutableArray * typeOfParts;//配件类型
@end

@implementation ReviseErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"有误修改";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"PauseContentTableCell" bundle:nil] forCellReuseIdentifier:@"contentCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MaintainErrorTableCell" bundle:nil] forCellReuseIdentifier:errorCellReusedIdtifire];
    
  
    NSArray * titles = @[@"故障ID",@"故障原因",@"配件类型"];
    [self.datasource addObjectsFromArray:titles];
    //提交
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sureSelected)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)sureSelected{
    [self.view endEditing:YES];
   //检测操作备注
    NSString * remark = [self.selctedContents objectForKey:@"remark"];
    if (remark.length == 0) {
        [Units showErrorStatusWithString:@"操作备注不能为空"];
        return;
    }
    NSString * reason  = [self.selctedContents objectForKey:@"reason"];
    if (reason.length  ==0) {
        [Units showErrorStatusWithString:@"故障原因不能为空"];
        return;
    }
    //故障ID
    NSString * reasonId = [self.selctedContents objectForKey:@"reasonId"];

    //配件类型
    NSString * typeOfDevice = [self.selctedContents objectForKey:@"typeOfpart"];
    //操作备注
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * endParms = [NSMutableDictionary dictionary];
    [endParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [endParms  setObject:@"1" forKey:@"Type"];
    [endParms setObject:remark forKey:@"OperateDescribe"];
    [dict setObject:reasonId?:_model.MaintainFaultId forKey:@"MaintainFaultId"];
    [dict setObject:reason?:_model.FaultReasonId forKey:@"FaultReasonId"];
    [dict setObject:typeOfDevice?:_model.PartsTypeId?:@"" forKey:@"PartsTypeId"];
    [dict setObject:_model.MaintainTaskId forKey:@"MaintainTaskId"];
    [endParms setObject:[Units dictionaryToJson:dict] forKey:@"Model"];
   
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[DeviceReviseErrorUrl getWholeUrl] param:endParms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        }

        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];

    }];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.datasource.count;
    }return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (indexPath.row  ==1) {
            return 80;
        }
        return 50.0f;
    }else{
        return 80.0f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row  ==1) {
            //故障原因
            MaintainErrorTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:errorCellReusedIdtifire];
            
            cell.titleLab.text  = self.datasource[indexPath.row];
            cell.contentTextView.placeholder  = [NSString stringWithFormat:@"请输入%@",self.datasource[indexPath.row]];
            KWeakSelf
            cell.textBlock = ^(NSString * _Nonnull textString) {
                [weakSelf.selctedContents setObject:textString forKey:@"reason"];
                
            };
            
            return cell;
        }else{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (cell == nil) {
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
            }
            NSString * tip = self.datasource[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
            NSString * contentStr = [self.selctedContents objectForKey:tip];
            
            NSArray * contents = @[contentStr?: _model.MaintainFaultName?:@"无",contentStr?: _model.FaultReasonName?:@"无",contentStr?: _model.PartsTypeName?:@"无"];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = contents[indexPath.row];
            
            return cell;
        }

    }else{
        PauseContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contentCellId"];
        cell.contentText.placeholder =@"请输入操作备注";
        cell.contentText.delegate = self;
        cell.contentText.text = [self.selctedContents objectForKey:@"remark"]?:@"";
        cell.contentText.inputAccessoryView = self.tool;
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tip = self.datasource[indexPath.row];
    if ([tip isEqualToString:@"故障ID"]) {
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:_model.FacilityId forKey:@"FacilityId"];
        [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
        KWeakSelf
        [HttpTool POST:[CheckDeviceTypeURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
                NSArray * respons = [Units jsonToArray:responseObject[@"data"]];
                NSMutableArray * names = [NSMutableArray array];
                for (NSDictionary * jsonDictionary in respons) {
                    [names addObject:jsonDictionary[@"MaintainFaultName"]];
                    [weakSelf.errorIds addObject:jsonDictionary[@"MaintainFaultId"]];
                }
                [weakSelf pickViewWithSources:names idx:indexPath.row];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
    }else if ([tip isEqualToString:@"故障原因"]){
        //废弃
       /* NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
        KWeakSelf
        [HttpTool POST:[MaintainEnginesFailURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            if ([[responseObject objectForKey:@"status"]integerValue] == 0) {
                NSArray * respons = [Units jsonToArray:responseObject[@"data"]];
                NSMutableArray * names = [NSMutableArray array];
                for (NSDictionary * jsons in respons) {
                    [names addObject:jsons[@"FaultReasonName"]];
                    [weakSelf.errorReasons addObject:jsons[@"FaultReasonId"]];
                    
                }
                [weakSelf pickViewWithSources:names idx:indexPath.row];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];*/
    }else if ([tip isEqualToString:@"配件类型"]){
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
        KWeakSelf
        [HttpTool POST:[TypeOfDevicePartURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            if ([[responseObject objectForKey:@"status"]integerValue] == 0) {
                NSArray * responses = [Units jsonToArray:responseObject[@"data"]];
                if (responses.count == 0) {
                    [Units showErrorStatusWithString:@"暂无配件类型"];
                    
                }else{
                    NSMutableArray * names = [NSMutableArray array];
                    for (NSDictionary * jsons in responses) {
                        [names addObject:jsons[@"PartsTypeName"]];
                        [weakSelf.typeOfParts addObject:jsons[@"PartsTypeId"]];
                    }
                    [weakSelf pickViewWithSources:names idx:indexPath.row];
                }
            }
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
    }
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.selctedContents setObject:textView.text forKey:@"remark"];
    return YES;
}
-(void)pickViewWithSources:(NSArray*)source idx:(NSInteger)idx{
    ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:source isHaveNavControler:NO];
    pickView.delegate = self;
    pickView.tag = idx;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    NSString * tip = self.datasource[pickView.tag];
    [self.selctedContents setObject:resultString forKey:tip];
    if ([tip isEqualToString:@"故障ID"]) {
        [self.selctedContents setObject:self.errorIds[resultIndex] forKey:@"reasonId"];
    }else if ([tip isEqualToString:@"故障原因"]){
        [self.selctedContents setObject:self.errorReasons[resultIndex] forKey:@"reason"];
    }else if ([tip isEqualToString:@"配件类型"]){
        [self.selctedContents setObject:self.typeOfParts[resultIndex] forKey:@"typeOfpart"];
    }
    [self.tableView reloadData];
}

-(NSMutableDictionary*)selctedContents{
    if (!_selctedContents) {
        _selctedContents = [NSMutableDictionary dictionary];
    }return _selctedContents;
}
-(NSMutableArray*)errorIds{
    if (!_errorIds) {
        _errorIds = [NSMutableArray array];
    }return _errorIds;
}

-(NSMutableArray*)errorReasons{
    if (!_errorReasons) {
        _errorReasons = [NSMutableArray array];
    }return _errorReasons;
}
-(NSMutableArray*)typeOfParts{
    if (!_typeOfParts) {
        _typeOfParts = [NSMutableArray array];
    }return _typeOfParts;
}
@end
