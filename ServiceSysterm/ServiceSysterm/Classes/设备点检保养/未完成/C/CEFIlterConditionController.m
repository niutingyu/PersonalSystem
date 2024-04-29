//
//  CEFIlterConditionController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/28.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CEFIlterConditionController.h"
#import "DEConditionTableCell.h"
#import "ZHPickView.h"


#import "DEChosMessageController.h"//设备名称
@interface CEFIlterConditionController ()<UITextFieldDelegate,ZHPickViewDelegate>
{
    NSInteger _selectedIdx;//选中标识
 
    
}
@property (nonatomic,strong)NSMutableArray * typeArray;
@property (nonatomic,strong)NSMutableArray * contentArray;
@property (nonatomic,strong)NSMutableDictionary * mutableDictionary;
@property (nonatomic,strong)NSMutableArray * typeIdArray;
@property (nonatomic,strong)NSMutableArray * typeModelArray;
@end

@implementation CEFIlterConditionController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"筛选条件";
    NSArray * arr = @[@"开始时间",@"结束时间",@"区域名称",@"维修工程师",@"部门名称",@"设备名称",@"维修单号"];
    //作为转化的model的key值
    NSArray * arr1 = @[@"startTime",@"endTime",@"districtId",@"maintainEngineerId",@"departmentId",@"deviceId",@"maintainCode"];
    if (!_typeModelArray) {
        _typeModelArray =[NSMutableArray array];
        [_typeModelArray addObjectsFromArray:arr1];
    }
    [self.datasource addObjectsFromArray:arr];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEConditionTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.tableView.rowHeight = 50.0f;
    
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureSelected)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)sureSelected{
    [self.view endEditing:YES];
    //字典转为自定义model传值
    CEChosTypeModel * model = [CEChosTypeModel mj_objectWithKeyValues:self.mutableDictionary];
    if (self.passTypeBlock) {
        self.passTypeBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEConditionTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.tipLab.text =[NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
    NSString * tipString = self.datasource[indexPath.row];
    NSArray * placeholds =@[@"点击选择",@"点击选择",@"点击选择",@"点击选择",@"点击选择",@"点击选择",@"请输入单号"];
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = indexPath.row;
    cell.inputTextField.placeholder = placeholds[indexPath.row];
    cell.inputTextField.text = self.contentArray[indexPath.row];
    if ([tipString isEqualToString:@"维修单号"]) {
        cell.inputTextField.textAlignment = NSTextAlignmentLeft;
        cell.inputTextField.inputAccessoryView = self.tool;
    }else{
        cell.inputTextField.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.inputTextField.inputView =[UIView new];
    }
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectedIdx = textField.tag;
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"开始时间"]) {
        [self selectedTime];
    }else if ([tipString isEqualToString:@"结束时间"]){
        [self selectedTime];
    }else if ([tipString isEqualToString:@"区域名称"]){
        [parms setObject:@"0" forKey:@"Type"];
        [self getTypeData:tipString parms:parms urlString:[DeviceAreaURL getWholeUrl]];
       
    }else if ([tipString isEqualToString:@"维修工程师"]){
        [parms setObject:@"1" forKey:@"Type"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [self getTypeData:tipString parms:parms urlString:[DeviceEngineerURL getWholeUrl]];
        
    }else if ([tipString isEqualToString:@"部门名称"]){
        [self getTypeData:tipString parms:parms urlString:[DeviceDepartmentURL getWholeUrl]];
       
    }else if ([tipString isEqualToString:@"设备名称"]){
        DEChosMessageController * controller = [DEChosMessageController new];
        controller.chosIdx =9999;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
            [weakSelf.contentArray replaceObjectAtIndex:textField.tag withObject:messageModel.FacilityName];
            [weakSelf.mutableDictionary setObject:messageModel.FacilityId forKey:weakSelf.typeModelArray[textField.tag]];
            [weakSelf.tableView reloadData];
        };
    }else if ([tipString isEqualToString:@"维修单号"]){
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"维修单号"]) {
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
        [self.mutableDictionary setObject:textField.text forKey:self.typeModelArray[textField.tag]];
    }
}
//时间选择器
-(void)selectedTime{
    ZHPickView * pickView = [[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}

//创建pickView
-(void)setupPickView{
    ZHPickView * pickView =[[ZHPickView alloc]initPickviewWithArray:self.typeArray isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}

//请求网络获取数据
-(void)getTypeData:(NSString*)type parms:(NSMutableDictionary*)parm urlString:(NSString*)url{
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:url param:parm success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            
            [self.typeIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            
            NSMutableArray * arr1 =[CEConditionModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self.typeArray addObject:@"不限"];
            [self.typeIdArray addObject:@""];
            
            for (CEConditionModel *model in arr1) {
                if ([type isEqualToString:@"区域名称"]) {
                    [self.typeArray addObject:model.DistrictName];
                    
                    [self.typeIdArray addObject:model.MaintainDistrictId];
                    
                }else if ([type isEqualToString:@"维修工程师"]){
                    
                    [self.typeArray addObject:[NSString stringWithFormat:@"%@(%@)",model.FName,model.UserName]];
                    
                    [self.typeIdArray addObject:model.UserId];
                    
                }else if ([type isEqualToString:@"部门名称"]){
                    
                    [self.typeArray addObject:model.DepName];
                    
                    [self.typeIdArray addObject:model.OrId];
                }
            }
            [self setupPickView];
        }
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:self.view];
    }];
}

#pragma mark pickdelegate

-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    [self.contentArray replaceObjectAtIndex:_selectedIdx withObject:resultString];
    [self.mutableDictionary setObject:self.typeIdArray[resultIndex] forKey:self.typeModelArray[_selectedIdx]];
    [self.tableView reloadData];
    
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    [self.contentArray replaceObjectAtIndex:_selectedIdx withObject:resultString];
    [self.mutableDictionary setObject:resultString forKey:self.typeModelArray[_selectedIdx]];
    [self.tableView reloadData];
}
-(NSMutableArray*)typeArray{
    if (!_typeArray) {
        _typeArray =[NSMutableArray array];
    }return _typeArray;
}
-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray =[[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i = 0; i<self.datasource.count; i++) {
            [_contentArray addObject:@""];
        }
    }return _contentArray;
}
-(NSMutableDictionary*)mutableDictionary{
    if (!_mutableDictionary) {
        _mutableDictionary =[NSMutableDictionary dictionary];
    }return _mutableDictionary;
}
-(NSMutableArray*)typeIdArray{
    if (!_typeIdArray) {
        _typeIdArray =[NSMutableArray array];
    }return _typeIdArray;
}
@end
