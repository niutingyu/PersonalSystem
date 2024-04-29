//
//  ExpectFinishTimeController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ExpectFinishTimeController.h"

#import "ExpectFinishTimeTableCell.h"
#import "ZHPickView.h"

#import "CECheckUnFinishListController.h"
@interface ExpectFinishTimeController ()<ZHPickViewDelegate,UITextViewDelegate>
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * remark;
@end

@implementation ExpectFinishTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpectFinishTimeTableCell" bundle:nil] forCellReuseIdentifier:@"timeCellId"];
    
    //提交按钮
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitSelect)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

#pragma mark ----提交
-(void)commitSelect{
    [self.view endEditing:YES];
    if (self.time.length == 0) {
        [Units showErrorStatusWithString:[self.title isEqualToString:@"保养要求完成时间"]?@"请填写保养要求完成时间":@"请填写供应商保养完成时间"];
        return;
        
    }if (self.remark.length == 0) {
        [Units showErrorStatusWithString:@"请填写操作备注"];
        return;
    }
    //判断截止日期不能小于当前日期
//    NSDate *currentDate = [NSDate date];
//    NSDate * endDate = [self.formatter dateFromString:self.time];
//    NSComparisonResult  result = [endDate compare:currentDate];
//    if (result == NSOrderedAscending) {
//        [Units showErrorStatusWithString:@"不能小于当前日期"];
//        return;
//    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:_detailModel.MaintainDjbyId forKey:@"MaintainDjbyId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:[self.title isEqualToString:@"保养要求完成时间"]?@"1":@"2" forKey:@"Type"];
    [parms setObject:self.time forKey:@"ByFinishTime"];
    [parms setObject:self.remark forKey:@"OperateDescribe"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    debugLog(@"- - - %@ %@",[ChansgeEngineerURL getWholeUrl],parms);
    [HttpTool POST:[ChansgeEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UIViewController * controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[CECheckUnFinishListController class]]) {
                        CECheckUnFinishListController * c = (CECheckUnFinishListController*)controller;
                         [weakSelf.navigationController popToViewController:c animated:YES];
                        
                    }
                }
               
            });
        }
    } error:^(NSString * _Nonnull error) {
    
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50.0f;
    }else{
        return 80.0f;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.text =self.time?:@"请选择日期";
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = self.title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        return cell;
    }else{
        ExpectFinishTimeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"timeCellId"];
        NSString * objContent = [self.title isEqualToString:@"保养要求完成时间"]?@"请输入操作备注":@"请输入外包保养供应商";
        cell.contentText.placeholder = objContent;
        cell.contentText.delegate = self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        //选择时间
        NSDate *date = [NSDate date];
        
        ZHPickView * pickView = [[ZHPickView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        pickView.delegate = self;
        [pickView show];
    }
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    self.time = [Units timeWithTime:resultString beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark ---操作备注

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    self.remark = textView.text;
    return YES;
}

@end
