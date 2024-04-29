//
//  MCDetailChoseTimeController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailChoseTimeController.h"

#import "MCOperateChangeSchuleAlertView.h"

#import "MCOperateRemarkTableCell.h"

#import "ZHPickView.h"
@interface MCDetailChoseTimeController ()<ZHPickViewDelegate>
{
    NSDate *_beginDate;
    NSDate *_endDate;
    
}
@property (nonatomic,strong)MCOperateChangeSchuleAlertView * alertView;
@end

@implementation MCDetailChoseTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    self.title =@"选择时间";
    
   // [self setupUI];
    [self setupDatas];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MCOperateRemarkTableCell class]) bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    
    
    UIBarButtonItem * leftItem  =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelMethod)];
    self.navigationItem.leftBarButtonItem  =leftItem;
    
    UIBarButtonItem * rightItem  =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureMethod)];
    self.navigationItem.rightBarButtonItem  =rightItem;
    
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSDictionary * dic  = [self.datasource firstObject];
    
    NSArray * keys  =[dic allKeys];
    return keys.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   NSDictionary * dic  = [self.datasource firstObject];
    
    NSArray * keys  =[dic allKeys];
    NSArray * values  = dic[keys[section]];
    
    return values.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic  = [self.datasource firstObject];
    
    NSArray * keys  =[dic allKeys];
    NSString * tip  = keys[indexPath.section];
    if ([tip isEqualToString:@"备注"]) {
        MCOperateRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        return cell;
    }else{
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell  ==nil) {
            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font  =[UIFont systemFontOfSize:16];
        
        
        
        NSArray * titles  = dic[tip];
        cell.textLabel.text  = [NSString stringWithFormat:@"%@:",titles[indexPath.row]];
        
        
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic  = [self.datasource firstObject];
    
    NSArray * keys  =[dic allKeys];
    NSString * tip  =keys[indexPath.section];
    if ([tip isEqualToString:@"选择时间"]) {
        return 48.0f;
    }else{
        return 66.0f;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic  = [self.datasource firstObject];
    
    NSArray * keys  =[dic allKeys];
    return keys[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic  = [self.datasource firstObject];
       
    NSArray * keys  =[dic allKeys];
    NSString * tip  =keys[indexPath.section];
    if ([tip isEqualToString:@"选择时间"]) {
        NSArray * titles  = dic[tip];
        NSString * title  = titles[indexPath.row];
        [self.alertView show];
//        MCOperateChangeSchuleAlertView * alertView  =[[MCOperateChangeSchuleAlertView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime];
//        [alertView show];
        
//        ZHPickView * pickView =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
//        pickView.delegate = self;
//        pickView.tag  = [[title isEqualToString:@"预计开始"]?@"1":@"2" intValue];
//        [pickView show];
    }
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    debugLog(@" - -- %ld",pickView.tag);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
-(void)cancelMethod{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)sureMethod{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSDateFormatter * format  = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * beginTimeString  = [format stringFromDate:_beginDate];
    
    NSString * endTimeString = [format stringFromDate:_endDate];
    
    
//    [MCOperateChangeSchuleAlertView showSchuleAlertViewWithHeadString:@"" beginTime:beginTimeString endTime:endTimeString timeBlock:^(NSString * _Nonnull remark) {
//       
//        NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
//        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
//        
//        [parms setObject:@"1" forKey:@"Type"];
//        
//        [parms setObject:remark forKey:@"OperateDescribe"];
//        
//        
//        [parms setObject:beginTimeString forKey:@"PredictBeginTime"];
//        
//        [parms setObject:endTimeString forKey:@"PredictEndTime"];
//        
//        
//        
//        
//    }];
}


-(void)setupDatas{
    NSDictionary * dic  =@{@"选择时间":@[@"预计开始",@"预计结束"],@"备注":@[@"请填写备注"]};
    [self.datasource addObject:dic];
}

-(void)setupUI{
    
    UIView * beginView  =[[UIView alloc]init];
    beginView.backgroundColor  = RGBA(242, 242, 242, 1);
    [self.view addSubview:beginView];
    [beginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(48);
    }];
    UILabel * beginLab  =[[UILabel alloc]init];
    beginLab.font  =[UIFont systemFontOfSize:16];
    
    beginLab.textColor  =[UIColor blackColor];
    beginLab.text  =@"开始时间";
    
    [beginLab sizeToFit];
    
    [beginView addSubview:beginLab];
    [beginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(beginView);
        make.height.mas_equalTo(21);
    }];
    
    
    UIDatePicker * beginDatePicker =[[UIDatePicker alloc]init];
    beginDatePicker.date  =[NSDate date];
    beginDatePicker.datePickerMode  =UIDatePickerModeDateAndTime;
    [beginDatePicker addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
    beginDatePicker.locale  = [NSLocale localeWithLocaleIdentifier:@"zh"];
    beginDatePicker.tag  =1000;
    _beginDate  = beginDatePicker.date;
    [self.view addSubview:beginDatePicker];
    [beginDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(beginView.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(160);
    }];
    
    
    UIView * endTimeView  =[[UIView alloc]init];
    endTimeView.backgroundColor  = RGBA(242, 242, 242, 1);
    [self.view addSubview:endTimeView];
    [endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(beginDatePicker.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(48);
    }];
    
    UILabel * endLab  =[[UILabel alloc]init];
    endLab.font  =[UIFont systemFontOfSize:16];
    [endLab sizeToFit];
    endLab.text  = @"结束时间";
    
    [self.view addSubview:endLab];
    [endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(endTimeView);
        make.height.mas_equalTo(21);
    }];
    
    UIDatePicker * endDatePicker  =[[UIDatePicker alloc]init];
    endDatePicker.date  =[NSDate date];
    endDatePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    [endDatePicker addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
    endDatePicker.tag  = 9999;
    
    _endDate  = endDatePicker.date;
    
    endDatePicker.locale  =[NSLocale localeWithLocaleIdentifier:@"zh"];
    
    [self.view addSubview:endDatePicker];
    [endDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(endTimeView.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(160);
    }];
    
}


-(void)changeTime:(UIDatePicker*)dataPick{

    if (dataPick.tag  ==1000) {
        _beginDate = dataPick.date;
    }else{
        _endDate  = dataPick.date;
    }
}

-(MCOperateChangeSchuleAlertView*)alertView{
    if (!_alertView) {
        _alertView  =[[MCOperateChangeSchuleAlertView alloc]init];
        [self.view.window addSubview:_alertView];
    }
    return _alertView;
}
@end
