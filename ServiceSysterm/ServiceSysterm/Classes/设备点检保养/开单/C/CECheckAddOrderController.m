//
//  CECheckAddOrderController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CECheckAddOrderController.h"
#import "CEAddOrderTableCell.h"
#import "DEChosMessageController.h"
#import "ZHPickView.h"

#import "MoudleModel.h"
@interface CECheckAddOrderController ()<UITextFieldDelegate,ZHPickViewDelegate>
{
    NSString * _deviceId;//选择的设备id
    NSString * _errorType;//故障类型
    NSString * _remark;//备注
}
@property (nonatomic,strong)NSMutableArray * contentArray;

@property (nonatomic,strong)NSMutableArray * errorTypeArray;//故障类型

@property (nonatomic,copy)NSString *factoryId;

@property (nonatomic,strong)NSMutableArray *factoryMutableArray;

@end

@implementation CECheckAddOrderController

-(NSMutableArray*)errorTypeArray{
    if (!_errorTypeArray) {
        _errorTypeArray =[NSMutableArray array];
    }return _errorTypeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"开单";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"CEAddOrderTableCell" bundle:nil] forCellReuseIdentifier:@"orderReusedId"];
    
    if (!_factoryMutableArray) {
        _factoryMutableArray =[NSMutableArray array];
    }
    //获取工厂
      NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
      MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
      [modleArchiver finishDecoding];
    NSArray * arr;
    if (moudleStatus.FactoryList.count >1) {
       arr =@[@"开单人",@"所属工厂",@"故障类型",@"设备编号",@"设备名称",@"所在区域",@"部门工序",@"设备等级",@"备注"];
        [_factoryMutableArray removeAllObjects];
        [_factoryMutableArray addObjectsFromArray:moudleStatus.FactoryList];
        _factoryId =moudleStatus.FactoryList[0][@"FactoryId"];
    }else{
        arr =@[@"开单人",@"故障类型",@"设备编号",@"设备名称",@"所在区域",@"部门工序",@"设备等级",@"备注"];
        _factoryId  = moudleStatus.FactoryList[0][@"FactoryId"];
    }
   
    [self.datasource addObjectsFromArray:arr];
    /****
     *提交
     ***/
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(orderCommit)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)orderCommit{
    [self.view endEditing:YES];
    [self commitOrder];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.datasource.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 50.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CEAddOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderReusedId"];
        cell.tipLab.text =[NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        cell.inputTextField.tag = indexPath.row;
        cell.inputTextField.delegate = self;
        NSString * tipString = self.datasource[indexPath.row];
    NSArray *contents;
    if (_factoryMutableArray.count >1) {
       contents =@[@"",@"请选择工厂",@"请选择故障类型",@"请选择设备编号",@"",@"",@"",@"",@"请输入备注(选填)"];
    }else{
        contents =@[@"",@"请选择故障类型",@"请选择设备编号",@"",@"",@"",@"",@"请输入备注(选填)"];
    }
        
        cell.inputTextField.placeholder = contents[indexPath.row];
        cell.inputTextField.text = self.contentArray[indexPath.row]?:@"";
        if ([tipString isEqualToString:@"故障类型"]||[tipString isEqualToString:@"设备编号"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.inputTextField.inputView =[UIView new];
        }else if ([tipString isEqualToString:@"开单人"]||[tipString isEqualToString:@"设备名称"]||[tipString isEqualToString:@"所在区域"]||[tipString isEqualToString:@"部门工序"]||[tipString isEqualToString:@"设备等级"]){
            cell.inputTextField.enabled = NO;
        }else if ([tipString isEqualToString:@"备注"]){
            cell.inputTextField.inputAccessoryView = self.tool;
        }else if ([tipString isEqualToString:@"所属工厂"]){
            cell.inputTextField.placeholder =@"点击选择工厂";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.inputTextField.inputView = [UIView new];
            
           
        }
        else{
            
            cell.inputTextField.enabled = YES;
        }
        return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"故障类型"]) {
        [self alertBadReason];
    }else if ([tipString isEqualToString:@"设备编号"]){
        DEChosMessageController * controller =[DEChosMessageController new];
        controller.chosIdx = 1002;
        controller.factoryId  =_factoryId;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
            
            self->_deviceId = messageModel.FacilityId;
            //遍历数组
            [weakSelf.datasource enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:@"设备名称"]) {
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.FacilityName];
                }else if ([obj isEqualToString:@"设备编号"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.FacilityCode];
                }else if ([obj isEqualToString:@"所在区域"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.DistrictName];
                }else if ([obj isEqualToString:@"设备等级"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.Lev];
                }else if ([obj isEqualToString:@"部门工序"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.FacilityDpartName];
                }
            }];
            [weakSelf.tableView reloadData];
        };
    }else if ([tipString isEqualToString:@"所属工厂"]){
        if (_factoryMutableArray.count >1) {
            [self chosFactoryWithTag:textField.tag];
        }
    }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"备注"]) {
        _remark = textField.text;
    }
    
    return YES;
}
//故障类型
-(void)alertBadReason{
    NSDictionary * parms =@{@"Type":@"1"};
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[CheckDeviceTypeURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            [weakSelf.errorTypeArray addObjectsFromArray:arr];
            
            NSMutableArray * titleArray =[NSMutableArray array];
            [titleArray removeAllObjects];
            for (NSDictionary * dict in arr) {
                NSString * nameString = dict[@"MaintainFaultName"];
                [titleArray addObject:nameString];
                
            }
            
            ZHPickView * pickView =[[ZHPickView alloc]initPickviewWithArray:titleArray isHaveNavControler:NO];
            pickView.delegate = weakSelf;
            [pickView show];
            
            pickView.cancelBlock = ^{
                [weakSelf.view endEditing:YES];
            };
            
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
      
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
    
}

//所属工厂

-(void)chosFactoryWithTag:(NSInteger)tag{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf;
    for (int i =0; i<_factoryMutableArray.count; i++) {
        NSString * title  = _factoryMutableArray[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.contentArray replaceObjectAtIndex:tag withObject:title];
            weakSelf.factoryId = weakSelf.factoryMutableArray[i][@"FactoryId"];
            [weakSelf.tableView reloadData];
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.view endEditing:YES];
    }]];
    [self presentViewController:controller animated:YES completion:^{
        [weakSelf.view endEditing:YES];
    }];
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    KWeakSelf
    NSDictionary * selectedDict = self.errorTypeArray[resultIndex];
    _errorType = selectedDict[@"MaintainFaultId"];//取出故障类型id
    [self.datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"故障类型"]) {
            [weakSelf.contentArray replaceObjectAtIndex:idx withObject:resultString];
            
        }
    }];
    [self.tableView reloadData];
}


-(void)commitOrder{
    
    if (_errorType.length ==0) {
        [Units showErrorStatusWithString:@"请选择故障类型"];
        return;
    }if (_deviceId.length ==0) {
        [Units showErrorStatusWithString:@"请选择设备编号"];
        return;
    }
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"OperCreateUser"];
    [parms setObject:USERDEFAULT_object(@"orderId") forKey:@"OrId"];
    [parms setObject:_deviceId forKey:@"FacilityId"];
    [parms setObject:_errorType forKey:@"MaintainFaultId"];
    [parms setObject:_factoryId?:@"" forKey:@"FactoryId"];
    if (_remark.length) {
        [parms setObject:_remark forKey:@"Remark"];
    }
    NSMutableDictionary * childrenParms =[NSMutableDictionary dictionary];
    [childrenParms setObject:[Units dictionaryToJson:parms] forKey:@"model"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[CheckNewOrderURL getWholeUrl] param:childrenParms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            [Units showHudWithText:@"开单成功" view:weakSelf.view model:MBProgressHUDModeText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
        
    } error:^(NSString * _Nonnull error) {
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray =[[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i =0; i<self.datasource.count; i++) {
            [_contentArray addObject:@""];
        }
        [_contentArray replaceObjectAtIndex:0 withObject:USERDEFAULT_object(CodeName)];
        //获取工厂
             NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
             MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
             [modleArchiver finishDecoding];
        if (moudleStatus.FactoryList.count >1) {
            [_contentArray replaceObjectAtIndex:1 withObject:moudleStatus.FactoryList[0][@"FactoryName"]];
            
            
        }
    }return _contentArray;
}
@end
