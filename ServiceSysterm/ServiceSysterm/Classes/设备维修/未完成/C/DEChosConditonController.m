//
//  DEChosConditonController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEChosConditonController.h"

#import "DEConditionTableCell.h"
#import "ZHPickView.h"
#import "DeviceModel.h"
#import "DEChosMessageController.h"
@interface DEChosConditonController ()<UITextFieldDelegate,ZHPickViewDelegate>{
    NSInteger _flag;
    NSString * flagString;
}
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,strong)NSMutableArray *typeArray;
@property (nonatomic,strong)NSMutableArray * contentArray;
@property (nonatomic,strong)NSMutableArray *typeIdArray;
@property (nonatomic,strong)FilterModel * filterModel;
@end

@implementation DEChosConditonController

-(FilterModel*)filterModel{
    if (!_filterModel) {
        _filterModel = [[FilterModel alloc]init];
    }
    return _filterModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //筛选条件
    self.title = @"筛选条件";
    NSArray * arr = @[@"开始时间",@"结束时间",@"区域名称",@"维修工程师",@"部门名称",@"设备名称",@"维修单号",@"开单人名称"];
    [self.datasource addObjectsFromArray:arr];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEConditionTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    //确定
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sureChos)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)sureChos{
    [self.view endEditing:YES];
    //block 传值
    if (self.passItemBlock) {
        self.passItemBlock(self.filterModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEConditionTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.tipLab.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
    NSString * tipString = self.datasource[indexPath.row];
    NSArray * contens = @[@"请选择开始时间",@"请选择结束时间",@"选择区域名称",@"选择维修工程师",@"选择部门名称",@"选择设备名称",@"请输入设备单号",@"请输入开单人名称"];
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = indexPath.row;
    cell.inputTextField.text = self.contentArray[indexPath.row]?:@"";
    cell.inputTextField.placeholder = contens[indexPath.row];
    if ([tipString isEqualToString:@"维修单号"]||[tipString isEqualToString:@"开单人名称"]) {
      
        cell.inputTextField.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.inputTextField.textAlignment = NSTextAlignmentRight;
        cell.inputTextField.inputView = [UIView new];
    }
    
    return cell;
}

#pragma mark = = = = textfielddelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"开始时间"]||[tipString isEqualToString:@"结束时间"]) {
       
        [self choseTime];
    }else if ([tipString isEqualToString:@"区域名称"]){
        [self loadDistrictMessage];
    }else if ([tipString isEqualToString:@"维修工程师"]){
        [self loadEngineerMessage];
    }else if ([tipString isEqualToString:@"部门名称"]){
        [self loadDepartmentMessage];
    }else if ([tipString isEqualToString:@"设备名称"]){
        DEChosMessageController * controller = [DEChosMessageController new];
        controller.chosIdx =1001;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        //设备名称回调
        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
            [weakSelf.contentArray replaceObjectAtIndex:textField.tag withObject:messageModel.Name];
            weakSelf.filterModel.deviceId =messageModel.OrId;//model赋值
            [weakSelf.tableView reloadData];
        };
    }
//    else if ([tipString isEqualToString:@"维修单号"]||[tipString isEqualToString:@"开单人名称"]){
//        if ([tipString isEqualToString:@"维修单号"]) {
//            self.filterModel.orderNumber = textField.text;
//        }else{
//            self.filterModel.orderName = textField.text;
//        }
//        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
//    }
    _flag = textField.tag;
    flagString = tipString;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"维修单号"]) {
        self.filterModel.orderNumber = textField.text;
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }if ([tipString isEqualToString:@"开单人名称"]) {
        self.filterModel.orderName = textField.text;
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    
}
//选择时间
-(void)choseTime{
    if (!_date) {
        _date =[NSDate date];
    }
    ZHPickView * pickView = [[ZHPickView alloc]initDatePickWithDate:self.date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    [self.view endEditing:YES];
    //model赋值
    NSString * idStr = self.typeIdArray[resultIndex];
    if ([flagString isEqualToString:@"区域名称"]) {
        self.filterModel.districtId = idStr;
    }else if ([flagString isEqualToString:@"维修工程师"]){
        self.filterModel.engineerId = idStr;
    }else if ([flagString isEqualToString:@"部门名称"]){
        self.filterModel.departmentId = idStr;
    }
    [self.contentArray replaceObjectAtIndex:_flag withObject:resultString];
    [self.tableView reloadData];
    
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    //选择时间
    if ([flagString isEqualToString:@"开始时间"]) {
        self.filterModel.startTime = resultString;
    }else if ([flagString isEqualToString:@"结束时间"]){
        self.filterModel.endTime = resultString;
    }
    [self.contentArray replaceObjectAtIndex:_flag withObject:resultString];
    [self.tableView reloadData];
}
#pragma mark === = = ===区域名称
-(void)loadDistrictMessage{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    [parm setObject:@"0" forKey:@"Type"];
    
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceAreaURL getWholeUrl] param:parm success:^(id  _Nonnull responseObject) {
        [self.typeIdArray removeAllObjects];
        [self.typeArray removeAllObjects];
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[DistrictModel mj_objectArrayWithKeyValuesArray:arr];
            for (DistrictModel * model in arr1) {
                if (![self.typeArray containsObject:model.DistrictName]) {
                    [self.typeArray addObject:model.DistrictName];//名称
                    [self.typeIdArray addObject:model.MaintainDistrictId];//id
                }
            }
            //弹出框
            [self setupPickView:self.typeArray];
        }
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
}

#pragma mark == = = ==维修工程师
-(void)loadEngineerMessage{
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:@"1" forKey:@"Type"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [self.typeArray removeAllObjects];
        [self.typeIdArray removeAllObjects];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[EngineerModel mj_objectArrayWithKeyValuesArray:arr];
            for (EngineerModel * model in arr1) {
                if (![self.typeArray containsObject:model.FName]) {
                    NSString * str = [NSString stringWithFormat:@"%@(%@)",model.FName,model.UserName];
                    [self.typeArray addObject:str];//名称
                    [self.typeIdArray addObject:model.UserId];//id
                    
                }
            }
            [self setupPickView:self.typeArray];
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
}
#pragma mark == = = ===部门数组
-(void)loadDepartmentMessage{
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceDepartmentURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [self.typeArray removeAllObjects];
        [self.typeIdArray removeAllObjects];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[DepartMentModel mj_objectArrayWithKeyValuesArray:arr];
            for (DepartMentModel * model in arr1) {
                if (![self.typeArray containsObject:model.DepName]) {
                    [self.typeArray addObject:model.DepName];
                    [self.typeIdArray addObject:model.OrId];//id
                }
            }
            [self setupPickView:self.typeArray];
        }
      
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
}
-(void)setupPickView:(NSMutableArray*)datasource{
    ZHPickView * pickView =[[ZHPickView alloc]initPickviewWithArray:datasource isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}
-(NSMutableArray*)typeArray{
    if (!_typeArray) {
        _typeArray =[NSMutableArray array];
    }
    return _typeArray;
}

-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray =[[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i =0; i<self.datasource.count; i++) {
            NSString * str = @"";
            [_contentArray addObject:str];
        }
    }
    return _contentArray;
}
-(NSMutableArray*)typeIdArray{
    if (!_typeIdArray) {
        _typeIdArray =[NSMutableArray array];
    }
    return _typeIdArray;
}
@end
