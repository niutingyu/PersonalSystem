//
//  DEMaightBackStoreController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/19.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMaightBackStoreController.h"
#import "DEBackStockAlertTableCell.h"
#import "DEMaterialDetailModel.h"

#import "MoudleModel.h"
@interface DEMaightBackStoreController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation DEMaightBackStoreController

-(void)getMessage{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:self.listModel.MatRequisitionId forKey:@"MatReqId"];
    [parms setObject:self.listModel.FactoryId forKey:@"FactoryId"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceMaightBackStockDetailURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue] ==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DEMaterialDetailModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource addObjectsFromArray:arr1];
        }
        [weakSelf.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"回仓申请";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DEBackStockAlertTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.tableView.estimatedRowHeight = 200.0f;
    [self getMessage];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)sure{
    //提交UI仓申请
    [self.view endEditing:YES];
    NSMutableArray *ReturnBillDetailList =[NSMutableArray array];
    for (DEMaterialDetailModel *model in self.datasource) {
        if ([model.backStoreCount integerValue] >[model.StockCount integerValue]) {
            [Units showErrorStatusWithString:@"回仓个数不能大于出库个数"];
            return;
        }if (model.backStoreCount.length == 0) {
            [Units showErrorStatusWithString:@"回仓个数不能为零"];
            return;
        }if (model.backStoreReason.length == 0) {
            [Units showErrorStatusWithString:@"请填写回仓原因"];
            return;
        }
        NSMutableDictionary *ReturnBillDict =[NSMutableDictionary dictionary];
        [ReturnBillDict setObject:model.MaterialCode forKey:@"MaterialCode"];
        [ReturnBillDict setObject:model.MaterialName forKey:@"MaterialName"];
        [ReturnBillDict setObject:model.MaterialInfo forKey:@"MaterialInfo"];
        [ReturnBillDict setObject:[NSString stringWithFormat:@"%@/%@",model.MaterialName,model.MaterialInfo] forKey:@"MaterialRecord"];
        [ReturnBillDict setObject:model.UnitName forKey:@"StockUnit"];
        [ReturnBillDict setObject:model.StockOutRecordId forKey:@"StockRecordId"];
        [ReturnBillDict setObject:model.StockCount forKey:@"StockCount"];
        
        [ReturnBillDict setObject:model.backStoreCount forKey:@"ReturnCount"];
        [ReturnBillDict setObject:model.StockCount forKey:@"ActCount"];
        [ReturnBillDict setObject:model.StockUnitId forKey:@"StockUnitId"];
        [ReturnBillDict setObject:model.MaterialId forKey:@"MaterialId"];
        [ReturnBillDict setObject:model.backStoreReason forKey:@"Reason"];
        [ReturnBillDict setObject:model.Barcode forKey:@"Barcode"];
        [ReturnBillDict setObject:model.BarcodeId forKey:@"BarcodeId"];
        [ReturnBillDict setObject:@1 forKey:@"ListOperation"];
        
        [ReturnBillDetailList addObject:ReturnBillDict];
    }
    NSMutableDictionary * childremParms = [NSMutableDictionary dictionary];
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    
    NSDictionary * dict = moudleStatus.BaseMsg;
    NSString * orderId = dict[@"OrId"];
    
    [childremParms setObject:self.listModel.MatRequisitionCode forKey:@"MatRequisitionCode"];
    [childremParms setObject:self.listModel.MatRequisitionId forKey:@"MatRequisitionId"];
    [childremParms setObject:self.listModel.FactoryId forKey:@"FactoryId"];
    [childremParms setObject:orderId forKey:@"DepId"];
    [childremParms setObject:USERDEFAULT_object(USERID) forKey:@"ReturnBy"];
    [childremParms setObject:[Units getNowDate:0] forKey:@"ReturnOn"];
    [childremParms setObject:@0 forKey:@"Status"];
    [childremParms setObject:@1 forKey:@"ListOperation"];
    [childremParms setObject:ReturnBillDetailList forKey:@"ReturnBillDetailList"];
    //转化为string
    [parms setObject:[Units dictionaryToJson:childremParms] forKey:@"model"];
    [parms setObject:[Units arrayToJson:ReturnBillDetailList] forKey:@"ReturnBillDetailList"];
    
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[DeviceCommitbackStoreURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            [Units showHudWithText:@"回仓成功" view:weakSelf.view model:MBProgressHUDModeText];
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:weakSelf.view];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEBackStockAlertTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DEMaterialDetailModel *model = self.datasource[indexPath.row];
    cell.model =model;
    cell.backStockTextField.delegate = self;
    cell.backStockReasonTextField.delegate = self;
    cell.backStockTextField.tag = indexPath.row;
    cell.backStockReasonTextField.tag = indexPath.row;
    cell.backStockTextField.keyboardType =UIKeyboardTypeNumberPad;
    cell.backStockTextField.inputAccessoryView = self.tool;
    cell.backStockReasonTextField.inputAccessoryView = self.tool;
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSIndexPath *indexpath =[NSIndexPath indexPathForRow:textField.tag inSection:0];
    DEMaterialDetailModel * model = self.datasource[indexpath.row];
    model.backStoreCount =textField.text;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSIndexPath *indexpath =[NSIndexPath indexPathForRow:textView.tag inSection:0];
    DEMaterialDetailModel * model = self.datasource[indexpath.row];
    model.backStoreReason = textView.text;
    return YES;
}
@end
