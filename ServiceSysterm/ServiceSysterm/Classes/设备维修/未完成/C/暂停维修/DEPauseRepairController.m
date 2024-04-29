//
//  DEPauseRepairController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/1.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPauseRepairController.h"
#import "DEPauseTableCell.h"

#import "ZHPickView.h"
#import "AppointAlertView.h"
#import "PauseContentTableCell.h"
#import "UITextView+Placeholder.h"

#import "DEUnfinishDetailModel.h"
@interface DEPauseRepairController ()<UITextFieldDelegate,ZHPickViewDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSMutableDictionary * mutableParms;
@property (nonatomic,strong)NSMutableArray * resopnObjectArray;
@property (nonatomic,assign)BOOL isSelectedAll;//是否全选
@end

@implementation DEPauseRepairController
-(NSMutableDictionary*)mutableParms{
    if (!_mutableParms) {
        _mutableParms =[NSMutableDictionary dictionary];
    }return _mutableParms;
}
-(NSMutableArray*)resopnObjectArray{
    if (!_resopnObjectArray) {
        _resopnObjectArray =[NSMutableArray array];
    }return _resopnObjectArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //点检暂停 维修暂停
    self.title = _comeFromController;
    NSArray * arr = @[@"暂停工程师",@"预计恢复时间",@""];
    [self.datasource addObjectsFromArray:arr];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DEPauseTableCell class] forCellReuseIdentifier:@"cellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PauseContentTableCell" bundle:nil] forCellReuseIdentifier:@"contentCellId"];
    self.tableView.rowHeight = 50.0f;
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitMessage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    debugLog(@"= = =%@",_comeFromController);
    
}
//提交
-(void)commitMessage{
    [self.view endEditing:YES];
    NSString * engineer = [self.mutableParms objectForKey:@"暂停工程师"];
    if (engineer.length == 0) {
        [Units showErrorStatusWithString:@"请选择暂停工程师"];
        return;
    }
    NSString * date = [self.mutableParms objectForKey:@"预计恢复时间"];
    if (_isSelectedAll == YES) {
        //q选中了全部工程师
        if (date.length == 0) {
            [Units showErrorStatusWithString:@"全选工程师时 预计恢复时间必填"];
            return;
        }
    }
    NSString * remark = [self.mutableParms objectForKey:@"Remark"];
    if (remark.length ==0) {
        [Units showErrorStatusWithString:@"请填写操作备注"];
        return;
    }
    if (self.passSecetedMutableParmsBlock) {
        self.passSecetedMutableParmsBlock(self.mutableParms);
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 80.0f;
    }else{
        return 50.0f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * tipString = self.datasource[indexPath.row];
    NSArray * placeholds =@[@"点击选择",@"点击选择",@"请输入操作备注"];
    if (indexPath.row ==2) {
        PauseContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contentCellId"];
        cell.contentText.placeholder = placeholds[indexPath.row];
        cell.contentText.text = self.mutableParms[@"Remark"];
        cell.contentText.delegate =self;
        cell.contentText.tag = indexPath.row;
        cell.contentText.inputAccessoryView = self.tool;
        return cell;
    }else{
        DEPauseTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
        cell.tipLab.text =[NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        cell.inputTextField.placeholder = placeholds[indexPath.row];
        cell.inputTextField.text = self.mutableParms[tipString];
        cell.inputTextField.delegate =self;
        cell.inputTextField.tag = indexPath.row;
        cell.inputTextField.textAlignment = NSTextAlignmentRight;
        cell.inputTextField.inputView =[UIView new];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"暂停工程师"]) {
        [self getEngineerWithTip:tipString];
    }else if ([tipString isEqualToString:@"预计恢复时间"]){
        ZHPickView * pickView =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        pickView.delegate = self;
        [pickView show];
        KWeakSelf
        pickView.cancelBlock = ^{
            [weakSelf.view endEditing:YES];
        };
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.tag ==2) {
     [self.mutableParms setObject:textView.text forKey:@"Remark"];
    }
    return YES;
}

-(void)getEngineerWithTip:(NSString*)tip{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    if ([_maintainType isEqualToString:@"点检"]) {
        //点检暂停
        [parms setObject:@"10" forKey:@"Type"];
    }else{
        //维修保养
       [parms setObject:@"6" forKey:@"Type"];
    }
    [parms setObject:self.maintainId forKey:@"MaintainTaskId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
      /*  --{
            busKey = "<null>";
            data = "[{\"FName\":\"\U5b81\U667a\U4f1f\",\"UserName\":\"GZ7096\",\"UserId\":\"2fea8a9cdd1447b7bbab4ce99dc76cb2\"}]";
            info = "\U64cd\U4f5c\U6210\U529f";
            status = 0;
            time = "2019-06-14 08:45:01";
        }*/
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            //转为model
            NSMutableArray *models = [DetailMemberModel mj_objectArrayWithKeyValuesArray:arr];
            
            
            if (arr.count ==0) {
                [Units showErrorStatusWithString:@"没有工程师选择"];
                return ;
            }

            for (DetailMemberModel *model in models) {
                model.selectedType =@"多选";
            }
            [AppointAlertView showAlertWithDatasource:models itemCallbackBlock:^(DetailMemberModel * _Nullable detailModel, NSMutableArray * _Nullable mutableArray) {
                if (mutableArray.count == models.count) {
                    //全部选择了工程师
                    weakSelf.isSelectedAll = YES;
    
                }else{
                    
                    weakSelf.isSelectedAll =NO;
                    
                }
                NSMutableDictionary * mutableIds = [NSMutableDictionary dictionary];
                NSMutableArray * ids = [NSMutableArray array];
             for (DetailMemberModel *mModel in mutableArray) {
                 [self.mutableParms setObject:[NSString stringWithFormat:@"%@%@",mModel.FName,@""] forKey:tip];
                 [mutableIds setObject:mModel.UserId forKey:@"UserId"];
                 [ids addObject:mutableIds];
                 
            }
                [weakSelf.mutableParms setObject:[Units arrayToJson:ids] forKey:@"engineer"];
                [weakSelf.tableView reloadData];
            } dismissBlock:^{
                [weakSelf.view endEditing:YES];
            }];
            
        }
       
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
}

-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
//    //工程师
//    [self.mutableParms setObject:resultString forKey:@"暂停工程师"];
//    [self.mutableParms setObject:self.resopnObjectArray[resultIndex] forKey:@"engineerId"];
//    [self.tableView reloadData];
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    [self.mutableParms setObject:resultString forKey:@"预计恢复时间"];
    [self.tableView reloadData];
}
@end
