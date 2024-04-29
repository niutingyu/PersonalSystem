//
//  DECheckProblemController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DECheckProblemController.h"
#import "DEProblemModel.h"
#import "DEProblemTableCell.h"
#import "ZHPickView.h"


@interface DECheckProblemController ()<UITextFieldDelegate,ZHPickViewDelegate>
@property (nonatomic,strong)NSMutableDictionary * mutableContentDictionary;
@property (nonatomic,strong)NSMutableDictionary *mutableEffectDictionary;
@end

@implementation DECheckProblemController


-(void)getMessage{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:_maintainTaskId forKey:@"MaintainDjbyId"];
    [parms setObject:@"2" forKey:@"Type"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[CheckProblemUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [ReviewProblemModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource addObjectsFromArray:arr1];
            
            
        }
        [weakSelf.tableView reloadData];
        debugLog(@" - -- -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        
    }];
}


//右边按钮
-(void)setrightBar{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 80, 20);
    btn.backgroundColor =[UIColor blueColor];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(operationBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点检问题";
    [self getMessage];
    [self setrightBar];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEProblemTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEProblemTableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    ReviewProblemModel * model = self.datasource[indexPath.section];
    
    NSArray * contents = @[[NSString stringWithFormat:@"%@(%@)",model.ContentName,[self transferFinishFlag:model]],model.PredictFinishTime,model.isSuerGood?:@"无"];
    NSArray * titles = @[@"异常问题",@"预计完成时间",@"效果确认"];
    cell.tipLabel.text = [NSString stringWithFormat:@"%@:",titles[indexPath.row]];
    cell.inputTextField.text = contents[indexPath.row];
    cell.inputTextField.flag =indexPath.section;
    if (indexPath.row ==2||indexPath.row ==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.inputTextField.enabled = YES;
        cell.inputTextField.delegate = self;
        cell.inputTextField.inputView = [UIView new];
        cell.inputTextField.tag = indexPath.row;
       
    }else{
        cell.inputTextField.enabled = NO;
    }
//    if (indexPath.row ==2){
//        cell.inputTextField.text =self.mutableEffectDictionary[@(indexPath.section)]?:model.isSuerGood?:@"无";
//    }if (indexPath.row ==1) {
//        cell.inputTextField.text = self.mutableContentDictionary[@(indexPath.row)]?:model.PredictFinishTime;
//    }
    
    return cell;
}
-(NSString *)transferFinishFlag:(ReviewProblemModel*)model{
    NSString * finishName ;
    if ([model.FinishFlag isEqualToString:@"0"]) {
        finishName = @"未完成";
    }else if ([model.FinishFlag isEqualToString:@"2"]){
        finishName = @"待复核";
    }else if ([model.FinishFlag isEqualToString:@"4"]){
        finishName = @"已完成";
    }
    return finishName;
}
-(void)operationBar{
   // NSArray * timeArray = [self.mutableContentDictionary allValues];
 //   NSArray * effcetArray = [self.mutableEffectDictionary allValues];
//    if (effcetArray.count <self.datasource.count) {
//        [Units showErrorStatusWithString:@"请确认完整效果"];
//        return;
//    }
    NSMutableArray * dictionaryArr =[NSMutableArray array];
    for (ReviewProblemModel *model in self.datasource) {
        if (model.isSuerGood.length <1) {
            
        }else{
            NSMutableDictionary * parms = [NSMutableDictionary dictionary];
            [parms setObject:model.PredictFinishTime forKey:@"PredictFinishTime"];
            [parms setObject:model.isSuerGood forKey:@"Verification"];
            [parms setObject:model.MaintenanceProblemId forKey:@"MaintenanceProblemId"];
            [dictionaryArr addObject:parms];
           
        }
        
    }

    if (dictionaryArr.count <1) {
        [Units showErrorStatusWithString:@"请至少确认一组异常效果"];
        return;
    }
    NSString * parmsString = [Units arrayToJson:dictionaryArr];
    NSMutableDictionary * endParms = [NSMutableDictionary dictionary];
    [endParms setObject:parmsString forKey:@"ProblemArray"];
    [endParms setObject:_maintainTaskId forKey:@"MaintainDjbyId"];
    [endParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [endParms setObject:@"1" forKey:@"Type"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    debugLog(@"== = =%@",endParms);
    [HttpTool POST:[CheckRecheckURL getWholeUrl] param:endParms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]boolValue]==NO) {
            [Units showStatusWithStutas:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });

        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
    }];
    
   
}
-(BOOL)textFieldShouldBeginEditing:(TextField *)textField{
     if (textField.tag ==2){
        NSArray * arr =@[@"合格",@"不合格"];
        ZHPickView * pickView =[[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
        pickView.delegate =self;
        pickView.tag = textField.flag;
        [pickView show];
         KWeakSelf
         pickView.cancelBlock = ^{
             [weakSelf.view endEditing:YES];
         };
     }else if (textField.tag ==1){
         ZHPickView * pickView = [[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
         pickView.delegate =self;
         pickView.tag = textField.flag;
         [pickView show];
         KWeakSelf
         pickView.cancelBlock = ^{
             [weakSelf.view endEditing:YES];
         };
     }
   
    return YES;
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
    [self.mutableEffectDictionary setObject:resultString forKey:@(pickView.tag)];
    ReviewProblemModel *model = self.datasource[pickView.tag];
    model.isSuerGood = resultString;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pickView.tag] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    //时间
    [self.mutableContentDictionary setObject:resultString forKey:@(pickView.tag)];
    ReviewProblemModel * model = self.datasource[pickView.tag];
    model.PredictFinishTime = resultString;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pickView.tag] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(NSMutableDictionary*)mutableContentDictionary{
    if (!_mutableContentDictionary) {
        _mutableContentDictionary =[NSMutableDictionary dictionary];
    }return _mutableContentDictionary;
}

-(NSMutableDictionary*)mutableEffectDictionary{
    if (!_mutableEffectDictionary) {
        _mutableEffectDictionary =[NSMutableDictionary dictionary];
    }return _mutableEffectDictionary;
}
@end
