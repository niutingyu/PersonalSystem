//
//  DESearchBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchBaseController.h"

#import "DESearchModel.h"
#import "MoudleModel.h"
#import "DESearchRankTableCell.h"
#import "DESearchSortTableCell.h"
#import "DEWholeChosFactoryTableCell.h"

#import "DESearchDetailController.h"

@interface DESearchBaseController ()
{
    NSInteger _selectedFlag;//选中的种类
    NSInteger _textFieldFlag;
    NSString * _selectedDistrictString;
    NSString * _factoryName;//工厂名称
   
}
@end

@implementation DESearchBaseController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight =60.0f;
   
    DETimeFilterView * headView =[[NSBundle mainBundle]loadNibNamed:@"DETimeFilterView" owner:self options:nil].firstObject;
    _filterTimeView = headView;
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    headView.beginTimeTextField.delegate = self;
    headView.endTimeTextField.delegate =self;
    headView.beginTimeTextField.inputView =[UIView new];
    headView.endTimeTextField.inputView = [UIView new];
    
 
    UIView * bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self.view addSubview:bottomView];
    [bottomView addSubview:headView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DESearchRankTableCell" bundle:nil] forCellReuseIdentifier:@"rankReusedId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DESearchSortTableCell" bundle:nil] forCellReuseIdentifier:@"sortReusedId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DEWholeChosFactoryTableCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
//    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(bottomView.frame), kScreenWidth, kScreenHeight-350);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(bottomView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(self.view);
       // make.height.mas_equalTo(self.view.frame.size.height-200);
    }];
    
    
   
  
   
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSArray * arr = [textField.text componentsSeparatedByString:@":"];
    if ([[arr firstObject] isEqualToString:@"开始时间"]) {
        _textFieldFlag =200;
    }if ([[arr firstObject]isEqualToString:@"结束时间"]) {
        _textFieldFlag =201;
    }
    
    ZHPickView * pickView =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pickView.delegate = self;
    [pickView show];
    
    KWeakSelf
    pickView.cancelBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    
   
    
    if (_textFieldFlag ==200) {
       
        _benginTimeString =[Units timeWithTime:resultString beforeFormat:@"yyyy-MM-dd HH:mm" andAfterFormat:@"yyyy-MM-dd"];//k选中的开始时间
        _filterTimeView.beginTimeTextField.text =[NSString stringWithFormat:@"开始时间:%@",_benginTimeString];
        
    }if (_textFieldFlag==201) {
       
        _endTimeString =[Units timeWithTime:resultString beforeFormat:@"yyyy-MM-dd HH:mm" andAfterFormat:@"yyyy-MM-dd"];//选中结束时间
        _filterTimeView.endTimeTextField.text =[NSString stringWithFormat:@"结束时间:%@",_endTimeString];
    }
    
   //判断时间
    //判断选中的时间不能大于当前时间
    NSDate *currentDate = [self.formatter dateFromString:[Units getNowDate:0]];
    if (_endTimeString.length) {
        NSDate *selectDate = [self.formatter dateFromString:_endTimeString];
        NSComparisonResult result = [selectDate compare:currentDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"结束时间不能大于当前时间"];
            return;
        }
    }
    //判断时间 结束时间不能小于结束时间
    if (_benginTimeString.length &&_endTimeString.length) {
        NSDate * startDate = [self.formatter dateFromString:_benginTimeString];
        NSDate * endDate = [self.formatter dateFromString:_endTimeString];
        NSComparisonResult result = [startDate compare:endDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"开始时间不能大于结束时间"];
            return;
        }
    }
    
    
    //重新设置参数
    switch (_selectedFlag) {
        case 0:
        {
           
            [self.mutableParms setObject:_benginTimeString?:@"" forKey:@"StartTime"];
            [self.mutableParms setObject:_endTimeString?:@"" forKey:@"EndTime"];
           //排除不限 选项
            if (![_selectedDistrictId isEqualToString:@"不限"]&&_selectedDistrictId.length >0) {
                [self.mutableParms setObject:_selectedDistrictId forKey:@"DistrictName"];
            }
          
        
            
            //重新请求网络
            [self reloadMessage:self.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:0];
            
        }
            break;
        case 1:{
            [self.mutableParms setObject:_benginTimeString?:[Units getNowDate:-4] forKey:@"StartTime"];
            [self.mutableParms setObject:_endTimeString?:[Units getNowDate:0] forKey:@"EndTime"];
            [self.mutableParms setObject:USERDEFAULT_object(@"fname") forKey:@"FName"];
            [self reloadMessage:self.mutableParms url:[DevicePushLogURL getWholeUrl] flag:1];
            
        }break;
        case 2:{
            [self.mutableParms setObject:[Units getNowDate:-4] forKey:@"StartTime"];
            [self.mutableParms setObject:[Units getNowDate:0] forKey:@"EndTime"];
            [self reloadMessage:self.mutableParms url:[DeviceErrorURL getWholeUrl] flag:2];
        }break;
            
        case 3:{
            
        }break;
        case 4:{
            [self.mutableParms setObject:_benginTimeString?:[Units getNowDate:0] forKey:@"StartTime"];
            [self.mutableParms setObject:_endTimeString?:[Units getNowDate:0] forKey:@"EndTime"];
            if (_selectedDistrictId.length) {
                [self.mutableParms setObject:_selectedDistrictId forKey:@"UserId"];
            }
            [self reloadMessage:self.mutableParms url:[DeviceSortURL getWholeUrl] flag:4];
        }
        default:
            break;
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_selectedFlag ==0) {
        return 2;
    }else{
        return 1;
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedFlag ==0) {
        if (section ==0) {
            return 1;
        }
    }
    return self.datasource.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_selectedFlag ==3) {
//        return 65.0f;
//    }else if (_selectedFlag ==4){
//        return 120.0f;
//    }
//    return 50.0f;
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //返回的key不同  ， 各自判断 S
    if (_selectedFlag ==0) {
        if (indexPath.section ==0) {
            //取出工厂
            NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
            MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
            [modleArchiver finishDecoding];
             if (moudleStatus.FactoryList.count >0) {
                 cell.textLabel.text =_factoryName?:moudleStatus.FactoryList[0][@"FactoryName"];
             }
             cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
             cell.textLabel.font  = [UIFont systemFontOfSize:16];
        
         }else{
             DESearchModel * model = self.datasource[indexPath.row];
             if (![model.CheckProgram containsString:@"率"]) {
               cell.textLabel.text =[NSString stringWithFormat:@"%@:%@",model.CheckProgram,model.SumMain?:@"0"];
             }else{
                 cell.textLabel.text =[NSString stringWithFormat:@"%@:百分之%@",model.CheckProgram,model.SumMain?:@"0"];
                 
             }
             cell.accessoryType =UITableViewCellAccessoryNone;
         }
         return cell;
       
    }else if (_selectedFlag ==1){
         DESearchModel * model = self.datasource[indexPath.row];
        if (![model.CheckProgram containsString:@"率"]) {
            cell.textLabel.text =[NSString stringWithFormat:@"%@:%@",model.CheckProgram,model.SumMain?:@"0"];
            }else{
                cell.textLabel.text =[NSString stringWithFormat:@"%@:百分之%@",model.CheckProgram,model.SumMain?:@"0"];
                
            }
        return cell;
                                     
    }else if (_selectedFlag ==2){
        //异常
        DEErrorModel * model = self.datasource[indexPath.row];
        cell.textLabel.text = model.FacilityException;
        cell.detailTextLabel.font =[UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor =[UIColor blueColor];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.datasource.count];
        
    }else if (_selectedFlag ==3){
        //排名
        DESearchRankTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"rankReusedId"];
        
        DERankModel * model = self.datasource[indexPath.row];
        cell.model =model;
        return cell;
        
    }else if (_selectedFlag ==4){
        DESearchSortTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"sortReusedId"];
        DESortModel *model =self.datasource[indexPath.row];
        [cell configureCell:model rowIdx:indexPath.row datasource:self.datasource];
        return cell;
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedFlag ==4) {
        //积分详细信息
        DESortModel * model = self.datasource[indexPath.row];
        DESearchDetailController * controller =[DESearchDetailController new];
        controller.taskCodeString = model.TaskCode;
        controller.checkProgramString = model.CheckProgram;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (_selectedFlag ==0){
        if (indexPath.section ==0) {
            [self chosFactory];
        }
    }
}

//选择工厂
-(void)chosFactory{
    //取出工厂
       NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
       MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
       [modleArchiver finishDecoding];
    if (moudleStatus.FactoryList.count ==1) {
        [Units showErrorStatusWithString:@"只属于一个工厂，没有更多选择的工厂"];
        return;
    }
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
   NSMutableArray * factories =[NSMutableArray array];
   [factories removeAllObjects];
   [factories addObjectsFromArray:moudleStatus.FactoryList];
   [factories addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
    for (int i =0; i<factories.count; i++) {
        NSString * title  =factories[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->_factoryName = title;
            self->_factoryId = factories[i][@"FactoryId"];
            //这里发个通知  通知选中的区域
            NSDictionary * dict =@{@"factoryId":self->_factoryId};
            [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"passParm-%d",0] object:dict];
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}
-(void)reloadMessage:(NSMutableDictionary*)parms url:(NSString*)urlString flag:(NSInteger)flag{
    _selectedFlag =flag;
    [self.datasource removeAllObjects];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:urlString param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        if ([[responseObject objectForKey:@"status"]integerValue ]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * responArr;
            if (flag == 0) {
             responArr =[DESearchModel mj_objectArrayWithKeyValuesArray:arr];
            }else if (flag ==1){
              responArr =[DESearchModel mj_objectArrayWithKeyValuesArray:arr];
            }else if (flag ==2){
                responArr =[DEErrorModel mj_objectArrayWithKeyValuesArray:arr];
            }
            else if (flag ==3){
                responArr =[DERankModel mj_objectArrayWithKeyValuesArray:arr];
            }else if (flag ==4){
                responArr =[DESortModel mj_objectArrayWithKeyValuesArray:arr];
            }
            
            
            [self.datasource addObjectsFromArray:responArr];
          
        }
        debugLog(@" = =%@",responseObject);
        [self.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
    }];
   
}

-(void)judgeTimeParms{
   
}
-(NSMutableDictionary*)mutableParms{
    if (!_mutableParms) {
        _mutableParms =[NSMutableDictionary dictionary];
    }return _mutableParms;
}
@end
