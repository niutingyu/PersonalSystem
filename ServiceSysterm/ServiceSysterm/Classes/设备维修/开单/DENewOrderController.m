//
//  DENewOrderController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DENewOrderController.h"
#import "DEChosMessageController.h"

#import "DENewOrderTableCell.h"
#import "PutTextFieldTableCell.h"
#import "ZHPickView.h"
#import "NSString+PinYin.h"

#import "MoudleModel.h"

@interface DENewOrderController ()<ZHPickViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray * tipArray;

@property (nonatomic,strong)NSMutableArray * contentArray;

@property (nonatomic,strong)NSMutableDictionary * mutableParms;

@property (nonatomic,strong)NSMutableArray *factoryMutableArray;//工厂

@property (nonatomic,copy)NSString * factoryId;//工厂Id

@end

static NSString * const reusedIdtifire = @"cellId";
@implementation DENewOrderController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_mutableParms) {
        _mutableParms =[NSMutableDictionary dictionary];
    }
    self.title = @"开单";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"DENewOrderTableCell" bundle:nil] forCellReuseIdentifier:reusedIdtifire];
    [self.tableView registerClass:[PutTextFieldTableCell class] forCellReuseIdentifier:@"pReusedId"];
    /***
     **提交按钮
     ***/
    UIBarButtonItem * commitButon = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(orderCommit)];
    self.navigationItem.rightBarButtonItem = commitButon;
    
    
    
}

/***
 *提交
 ***/

-(void)orderCommit{
  
    [self commitOrder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.tipArray.count;
  
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        DENewOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:reusedIdtifire];
        cell.titleLab.text = [NSString stringWithFormat:@"%@:",self.tipArray[indexPath.row]];
        cell.contentTextField.tag = indexPath.row;
        
        cell.contentTextField.text = self.contentArray[indexPath.row];
        NSString * tipString = self.tipArray[indexPath.row];
        if ([tipString isEqualToString:@"设备编号"]) {
            cell.contentTextField.placeholder = @"点击选择设备";
            
            cell.contentTextField.delegate = self;
            
            cell.contentTextField.inputView = [UIView new];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.enabled =YES;
            
        }else if ([tipString isEqualToString:@"设备名称"]||[tipString isEqualToString:@"所在区域"]||[tipString isEqualToString:@"设备等级"]||[tipString isEqualToString:@"开单人"]||[tipString isEqualToString:@"部门工序"]){
            cell.contentTextField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if ([tipString isEqualToString:@"备注"]){
            cell.contentTextField.placeholder = @"请输入备注";
            
            cell.contentTextField.inputView = nil;
            
            cell.contentTextField.inputAccessoryView = self.tool;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentTextField.delegate = self;
            cell.contentTextField.enabled =YES;
            
        }else if ([tipString isEqualToString:@"设备状态"]){
            cell.contentTextField.placeholder = @"点击选择类型";
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.contentTextField.inputView = [UIView new];
            cell.contentTextField.inputAccessoryView =nil;
            
            cell.contentTextField.delegate = self;
            cell.contentTextField.enabled  =YES;
        }else if ([tipString isEqualToString:@"所属工厂"]){
          
            cell.contentTextField.placeholder =@"点击选择工厂";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.contentTextField.inputView = [UIView new];
            
            cell.contentTextField.delegate = self;
            
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentTextField.inputView = [UIView new];
        }
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
   
}

#pragma mark ==== == =textfield

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * tipString = self.tipArray[textField.tag];
    if ([tipString isEqualToString:@"设备编号"]) {
        DEChosMessageController * controller = [DEChosMessageController new];
        controller.chosIdx = 9999;
        self.hidesBottomBarWhenPushed = YES;
        controller.factoryId  =_factoryId;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
          
            //遍历数组
            [weakSelf.mutableParms setObject:messageModel.FacilityId forKey:@"facilityId"];//设备id
            [weakSelf.tipArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    }else if ([tipString isEqualToString:@"设备状态"]){
        [self alertPickView];
    }else if ([tipString isEqualToString:@"备注"]){
      //  [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
      
    }else if ([tipString isEqualToString:@"所属工厂"]){
       //判断工厂是不是只有一个
        if (self.factoryMutableArray.count ==1) {
           
            return;
        }else{
            [self chosFactoryWithTag:textField.tag];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * tipString = self.tipArray[textField.tag];
    if ([tipString isEqualToString:@"备注"]) {
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
          [self.mutableParms setObject:textField.text forKey:@"remark"];
        
    }
}
#pragma  mark == = = = = ===pickview
-(void)alertPickView{
    NSArray * arr =@[@"带病作业",@"设备停机"];
    ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    NSString * status =nil;
    if ([resultString isEqualToString:@"带病作业"]) {
        status = @"1";
    }else{
        status =@"2";
    }
    [self.mutableParms setObject:status forKey:@"status"];
    [_tipArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"设备状态"]) {
            [self.contentArray replaceObjectAtIndex:idx withObject:resultString];
        }
    }];
    
    [self.tableView reloadData];
}

//选择工厂
-(void)chosFactoryWithTag:(NSInteger)tag{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.factoryMutableArray.count >0) {
        KWeakSelf;
        for (int i = 0; i<_factoryMutableArray.count; i++) {
            NSString * title  = _factoryMutableArray[i][@"FactoryName"];
            [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.contentArray replaceObjectAtIndex:tag withObject:action.title];
                weakSelf.factoryId  = weakSelf.factoryMutableArray[i][@"FactoryId"];
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
}
-(void)commitOrder{
    [self.view endEditing:YES];
    debugLog(@" - -%@",_factoryId);
    NSString * facilityId = [self.mutableParms objectForKey:@"facilityId"];
    NSString * deviceStatus = [self.mutableParms objectForKey:@"status"];
    NSString * remark = [self.mutableParms objectForKey:@"remark"];
    
    if (facilityId.length == 0) {
        [Units showErrorStatusWithString:@"请选择设备"];
        return;
    }if (deviceStatus.length == 0) {
        [Units showErrorStatusWithString:@"请选择设备状态"];
        return;
    }if (remark.length == 0) {
        [Units showErrorStatusWithString:@"请输入备注"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [dict setObject:USERDEFAULT_object(USERID) forKey:@"OperCreateUser"];//orderId
    [dict setObject:USERDEFAULT_object(@"orderId") forKey:@"OrId"];
    [dict setObject:deviceStatus forKey:@"FacilityStatus"];//设备状态
    [dict setObject:remark forKey:@"Remark"];//备注
    [dict setObject:facilityId forKey:@"FacilityId"];//设备id
    [dict setObject:_factoryId?:@"" forKey:@"FactoryId"];
    
    [parms setObject:[Units dictionaryToJson:dict] forKey:@"model"];
   
    [Units showHudWithText:@"正在提交" view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    
    [HttpTool POST:[DeviceNewOrder  getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"error"]integerValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:self.view];
        [Units showErrorStatusWithString:error];
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(NSMutableArray*)tipArray{
    if (!_tipArray) {
        //取出工厂
        NSArray * arr ;
        NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
        MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
        [modleArchiver finishDecoding];
        if (moudleStatus.FactoryList.count ==1) {
         arr =@[@"开单人",@"设备编号",@"设备名称",@"所在区域",@"部门工序",@"设备等级",@"设备状态",@"备注"];
            _factoryId = moudleStatus.FactoryList[0][@"FactoryId"];
        }else{
            arr =@[@"开单人",@"所属工厂",@"设备编号",@"设备名称",@"所在区域",@"部门工序",@"设备等级",@"设备状态",@"备注"];
            _factoryMutableArray  =[NSMutableArray array];
            [_factoryMutableArray removeAllObjects];
            [_factoryMutableArray addObjectsFromArray:moudleStatus.FactoryList];
        }
       
        _tipArray = [NSMutableArray array];
        [_tipArray addObjectsFromArray:arr];
    }
    return _tipArray;
}

-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc]initWithCapacity:self.tipArray.count];
        for (NSInteger i =0; i<self.tipArray.count; i++) {
            [_contentArray addObject:@""];
        }
        [_contentArray replaceObjectAtIndex:0 withObject:USERDEFAULT_object(CodeName)];
        //取出工厂
       
        NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
        MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
        [modleArchiver finishDecoding];
        if (moudleStatus.FactoryList.count >1) {
            //默认选中第一个工厂
            [_contentArray replaceObjectAtIndex:1 withObject:moudleStatus.FactoryList[0][@"FactoryName"]];
            _factoryId  =moudleStatus.FactoryList[0][@"FactoryId"];
        }
        
        
    }
    return _contentArray;
}

- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
@end
