//
//  DEFilterMaterialController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEFilterMaterialController.h"

#import "DEConditionTableCell.h"
#import "DECommitTableCell.h"
#import "ZHPickView.h"
@interface DEFilterMaterialController ()<UITextFieldDelegate,ZHPickViewDelegate>
{
    NSString * _materialNumber;//领单单号
    NSString * _materialCode;//物料编码
    NSString * _orderState;//单状态
    NSString * _backStockNumber;//回仓单号
    NSString * _materialName;//物料名称
    NSString * _materialType;//物料规格
    
}
@property (nonatomic,copy)NSArray * pickTitles;
@end

@implementation DEFilterMaterialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选条件";
    NSArray * titles =nil;
    if (_flag ==100) {
        titles = @[@"领料单号",@"物料编码"];
    }else{
        titles =@[@"领料单号",@"物料编码",@"单状态",@"回仓单号",@"物料名称",@"物料规格"];
    }
    [self.datasource addObjectsFromArray:titles];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEConditionTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self.tableView registerClass:[DECommitTableCell class] forCellReuseIdentifier:@"commitReusedId"];
    _pickTitles = [NSArray arrayWithObjects:@"作废",@"待提交",@"退回",@"待部门审核",@"待仓管核实",@"待IQC",@"待入库",@"回仓成功",@"回仓失败", nil];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.datasource.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50.0f;
    }else{
        return 100.0f;
    }
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
    if (indexPath.section ==0) {
        DEConditionTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        
        cell.tipLab.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        NSArray * contents = @[@"请输入领料单号",@"请输入物料编码",@"点击选择单状态",@"请输入回仓单号",@"请输入物料名称",@"请输入物料规格"];
        cell.inputTextField.placeholder = contents[indexPath.row];
        NSString * tipString = self.datasource[indexPath.row];
        if ([tipString isEqualToString:@"单状态"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.inputTextField.delegate = self;
            cell.inputTextField.inputView = [UIView new];
            cell.inputTextField.inputAccessoryView = nil;
            cell.inputTextField.text = _orderState?:@"";
        }else{
          cell.inputTextField.inputAccessoryView = self.tool;
        }
        cell.inputTextField.tag = indexPath.row;
       
        return cell;
    }else{
        DECommitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commitReusedId"];
        
        return cell;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"领单单号"]) {
        _materialNumber = textField.text;
    }else if ([tipString isEqualToString:@"物料编码"]){
        _materialCode = textField.text;
    }else if ([tipString isEqualToString:@"单状态"]){
        [self chosOrderState];
    }
    else if ([tipString isEqualToString:@"回仓单号"]){
        _backStockNumber = textField.text;
    }else if ([tipString isEqualToString:@"物料名称"]){
        _materialName = textField.text;
    }else if ([tipString isEqualToString:@"物料规格"]){
        _materialType = textField.text;
    }
    
}

//选择单状态
-(void)chosOrderState{
  
    ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:_pickTitles isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    
}

-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    [self.view endEditing:YES];
    _orderState = _pickTitles[resultIndex];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
}
@end
