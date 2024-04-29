//
//  ApplayAcceptanceController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ApplayAcceptanceController.h"

#import "ApplyAcceptanceModel.h"

#import "DevicePartAlertView.h"
#import "ApplyAcceptanceTypeTableCell.h"
#import "ApplyAcceptanceProgressTableCell.h"

#import "ZHPickView.h"
@interface ApplayAcceptanceController ()<ZHPickViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSMutableArray * troubles;//故障

@property (nonatomic,strong)NSMutableArray * deviceParts;//设备配件

@property (nonatomic,strong)NSMutableArray * typeOfParts;//配件类型

@property (nonatomic,strong)NSMutableDictionary * mutableDictionary;//选中内容

@property (nonatomic,strong)NSMutableDictionary * idsMutableDictionary;//选中配件id

@end

static NSString * const typeCellId = @"typeCellId";
static NSString * const progressCellId =@"progressCellId";

@implementation ApplayAcceptanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyAcceptanceTypeTableCell" bundle:nil] forCellReuseIdentifier:typeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyAcceptanceProgressTableCell" bundle:nil] forCellReuseIdentifier:progressCellId];
    self.title = @"申请验收";
  
   
    NSArray * titles = @[@"是否人为",@"处理过程",@"故障原因",@"设备配件",@"配件类型",@"设备状态",@"是否更换配件",@"上次更换日期"];
    [self.datasource addObjectsFromArray:titles];
    
    //提交
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitObjs)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)commitObjs{
    //[self.view endEditing:YES];
    NSArray * tipObjs = [self.mutableDictionary allKeys];
    
   
    for (NSString * obj in self.datasource) {
        if (![tipObjs containsObject:obj]) {
            [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@不能为空",obj]];
            return;
        }
        
    }
   
    //分别取出值
    //是否人为
    NSString * human = [self.mutableDictionary objectForKey:@"是否人为"];
    //处理过程
    NSString * progress = [self.mutableDictionary objectForKey:@"处理过程"];
    //故障原因
    NSString * trouble = [self.mutableDictionary objectForKey:@"故障原因"];
    //设备配件
    NSString * deviceParts = [self.idsMutableDictionary objectForKey:@"设备配件"];
    //配件类型
    NSString * typeOfParts = [self.idsMutableDictionary objectForKey:@"配件类型"];
    //设备状态
    NSString * statusOfDevice = [self.mutableDictionary objectForKey:@"设备状态"];
    //是否更换配件
    NSString * changeDeviceParts = [self.mutableDictionary objectForKey:@"是否更换配件"];
    //上次更换日期
    NSString * changDate = [self.mutableDictionary objectForKey:@"上次更换日期"];
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:_taskId forKey:@"MaintainTaskId"];
    [parms setObject:[human isEqualToString:@"非人为"]?@"0":@"1" forKey:@"HumanFlag"];
    [parms setObject:progress forKey:@"TreatmentProcess"];
    [parms setObject:trouble forKey:@"FaultReasonId"];
    if (deviceParts.length == 0) {
        [parms setObject:typeOfParts forKey:@"PartsTypeId"];
        
    }else{
        [parms setObject:deviceParts forKey:@"MaintainFacilityPartsId"];
    }
    [parms setObject:[statusOfDevice isEqualToString:@"带病作业"]?@"1":@"2" forKey:@"FacilityStatus"];
    [parms setObject:changeDeviceParts forKey:@"IsReplace"];
    [parms setObject:changDate forKey:@"LastChangeTime"];
    debugLog(@"parms === %@",parms);
    //转为joson
    NSMutableDictionary * jsonParms = [NSMutableDictionary dictionary];
    [jsonParms setObject:[Units dictionaryToJson:parms] forKey:@"Model"];
    [jsonParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[AppyAcceptanceURL getWholeUrl] param:jsonParms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        }
     
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
       
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tip= self.datasource[indexPath.row];
    if ([tip isEqualToString:@"处理过程"]||[tip isEqualToString:@"故障原因"]) {
        return 80.0f;
    }else{
        return 50.0f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * placeholds = @[@"点击选择",@"请输入处理过程",@"请输入故障原因",@"点击选择",@"点击选择",@"点击选择",@"点击选择",@"点击选择",@"点击选择"];
    NSString * tipString = self.datasource[indexPath.row];
    if ([tipString isEqualToString:@"处理过程"]||[tipString isEqualToString:@"故障原因"]) {
        ApplyAcceptanceProgressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:progressCellId];
        cell.headTitle.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        cell.contentTextView.placeholder =placeholds[indexPath.row];
        cell.contentTextView.text = self.mutableDictionary[tipString];
        cell.contentTextView.delegate = self;
        cell.contentTextView.tag = indexPath.row+100;
        cell.contentTextView.inputAccessoryView = self.tool;
        return cell;
    }else{
        ApplyAcceptanceTypeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:typeCellId];
        cell.tipLabel.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        cell.contentText.placeholder = placeholds[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentText.inputView = [UIView new];
        cell.contentText.delegate = self;
        cell.contentText.tag = indexPath.row;
        NSString * contentName = self.mutableDictionary[tipString];
        cell.contentText.text = contentName;
        
        return cell;
    }
}



#pragma mark ---输入框
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSString * tip = self.datasource[textField.tag];
    if ([tip isEqualToString:@"是否人为"]) {
        NSArray * titles = @[@"非人为",@"人为"];
        [self pickViewWithdatasource:titles idx:textField.tag tip:tip];
    }else if ([tip isEqualToString:@"设备配件"]){
        [self dataOfdeviceParts];
    }else if ([tip isEqualToString:@"配件类型"]){
        [self typeOfdevicepartsWithIdx:textField.tag tip:tip];
    }else if ([tip isEqualToString:@"设备状态"]){
        NSArray * titles = @[@"带病作业",@"设备停机"];
        [self pickViewWithdatasource:titles idx:textField.tag tip:tip];
    }else if ([tip isEqualToString:@"是否更换配件"]){
        NSArray * titles = @[@"是",@"否"];
        [self pickViewWithdatasource:titles idx:textField.tag tip:tip];
    }else if ([tip isEqualToString:@"上次更换日期"]){
        ZHPickView  * pickview = [[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        pickview.delegate = self;
        [pickview show];
        KWeakSelf
        pickview.cancelBlock = ^{
            [weakSelf.view endEditing:YES];
        };
        pickview.tag = textField.tag;
    }
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.tag  ==101) {
        //处理过程
        [self.mutableDictionary setObject:textView.text forKey:@"处理过程"];
        
    }else{
        [self.mutableDictionary setObject:textView.text forKey:@"故障原因"];
    }
    
    
    return YES;
}

#pragma mark ---- PickView

-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
   //100 是否人为。102 故障原因  104 配件类型。105 设备状态 106 是否更换配件。
    NSString *tip = self.datasource[pickView.tag];
    [self.mutableDictionary setObject:resultString forKey:tip];
    if ([tip isEqualToString:@"故障原因"]) {
        DeviceErrorsModel *model = self.troubles[resultIndex];
        [self.idsMutableDictionary setObject:model.FaultReasonId forKey:tip];
        
    }else if ([tip isEqualToString:@"设备配件"]){
        DevicePartsModel * model = self.deviceParts[resultIndex];
        [self.idsMutableDictionary setObject:model.MaintainFacilityPartsId forKey:tip];
    }else if ([tip isEqualToString:@"配件类型"]){
        TypeOfPartModel *model = self.typeOfParts[resultIndex];
        [self.idsMutableDictionary setObject:model.PartsTypeId forKey:tip];
    }
        
    [self.tableView reloadData];
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSString * tip = self.datasource[pickView.tag];
    [self.mutableDictionary setObject:resultString forKey:tip];
    [self.tableView reloadData];
}
-(void)pickViewWithdatasource:(NSArray*)dateasource idx:(NSInteger)idx tip:(NSString*)tip{
    ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:dateasource isHaveNavControler:NO];
    pickView.delegate = self;
    pickView.tag = idx;
    [pickView show];
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}

//废弃
#pragma mark ---获取故障
-(void)dataOfEnginesFailWithIdx:(NSInteger)idx tip:(NSString*)tip{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[MaintainEnginesFailURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray *jsons = [Units jsonToArray:responseObject[@"data"]];
            //转model
            NSMutableArray * models = [DeviceErrorsModel mj_objectArrayWithKeyValuesArray:jsons];
            //遍历model数组
            NSMutableArray *objs = [NSMutableArray array];
            [objs removeAllObjects];
            for (DeviceErrorsModel * model in models) {
                [weakSelf.troubles addObject:model];
                [objs addObject:model.FaultReasonName];
            }
            [weakSelf pickViewWithdatasource:objs idx:idx tip:tip];
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
    }];
}
#pragma mark ---设备配件
-(void)dataOfdeviceParts{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:_facilityId forKey:@"FacilityId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[DevicePartsURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * jsons = [Units jsonToArray:responseObject[@"data"]];
            //转为model
            NSMutableArray * models = [DevicePartsModel mj_objectArrayWithKeyValuesArray:jsons];
            [weakSelf.deviceParts addObjectsFromArray:models];
       
            if (jsons.count ==0) {
                [Units showStatusWithStutas:@"暂无配件信息"];
                //这个地方比较特殊 无配件信息就删除了这条信息 数据源改变了
                [weakSelf.datasource removeObject:@"设备配件"];
            }else{
                [DevicePartAlertView showAlertViewWithdatsource:jsons partBlock:^(NSString * _Nonnull devicePartId, NSString * _Nonnull devicePartName) {
                    
                }];
            }
            [weakSelf.tableView reloadData];
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
    }];
}

//配件类型
-(void)typeOfdevicepartsWithIdx:(NSInteger)idx tip:(NSString*)tip{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[TypeOfDevicePartURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * jsons = [Units jsonToArray:responseObject[@"data"]];
            //转为model
            NSMutableArray * models = [TypeOfPartModel mj_objectArrayWithKeyValuesArray:jsons];
            //遍历models
            NSMutableArray * objs = [NSMutableArray array];
            [objs removeAllObjects];
            for (TypeOfPartModel *model in models) {
                [weakSelf.typeOfParts addObject:model];
                [objs addObject:model.PartsTypeName];
            }
            
            [weakSelf pickViewWithdatasource:objs idx:idx tip:tip];
        }
       
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
    }];
}
-(NSMutableArray*)troubles{
    if (!_troubles) {
        _troubles = [NSMutableArray array];
    }return _troubles;
}


-(NSMutableArray*)deviceParts{
    if (!_deviceParts) {
        _deviceParts = [NSMutableArray array];
    }return _deviceParts;
}
-(NSMutableArray*)typeOfParts{
    if (!_typeOfParts) {
        _typeOfParts = [NSMutableArray array];
    }return _typeOfParts;
}


-(NSMutableDictionary*)mutableDictionary{
    if (!_mutableDictionary) {
        _mutableDictionary = [NSMutableDictionary dictionary];
    }return _mutableDictionary;
}

-(NSMutableDictionary*)idsMutableDictionary{
    if (!_idsMutableDictionary) {
        _idsMutableDictionary = [NSMutableDictionary dictionary];
    }return _idsMutableDictionary;
}
@end
