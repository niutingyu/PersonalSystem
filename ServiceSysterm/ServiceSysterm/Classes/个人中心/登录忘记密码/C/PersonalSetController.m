//
//  PersonalSetController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/5.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PersonalSetController.h"
#import "DENewOrderTableCell.h"
@interface PersonalSetController ()<UITextFieldDelegate>
@property (strong,nonatomic)NSMutableArray * contentArray;
@end

@implementation PersonalSetController

-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i =0; i<self.datasource.count; i++) {
            [_contentArray addObject:@""];
        }
        [_contentArray replaceObjectAtIndex:0 withObject:USERDEFAULT_object(CodeName)];
        [_contentArray replaceObjectAtIndex:1 withObject:USERDEFAULT_object(JOBNUM)];
        [_contentArray replaceObjectAtIndex:3 withObject:USERDEFAULT_object(@"phone")?:@""];
    }return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"个人资料";
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSArray * arr = @[@"姓名",@"工号",@"邮箱",@"长号",@"短号"];
    [self.datasource addObjectsFromArray:arr];
    [self.tableView registerNib:[UINib nibWithNibName:@"DENewOrderTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitAction)];
    self.navigationItem.rightBarButtonItem =rightItem;
    
}

//确认修改
-(void)commitAction{
    [self.view endEditing:YES];
    __block NSString *email;
    __block NSString *mobile;
    __block NSString *shortMobile;
  
    [self.datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:@"邮箱"]) {
            email = self.contentArray[idx];
        }else if ([obj isEqualToString:@"长号"]){
            mobile = self.contentArray[idx];
        }else if ([obj isEqualToString:@"短号"]){
            shortMobile = self.contentArray[idx];
        }
    }];
    if (email.length ==0) {
        [Units showErrorStatusWithString:@"请输入邮箱"];
        return;
    }if (![email isEmail]) {
        [Units showErrorStatusWithString:@"请输入正确的邮箱"];
        return;
    }if (mobile.length ==0) {
        [Units showErrorStatusWithString:@"请输入电话号码"];
        return;
    }if (![mobile isPhoneNumber]) {
        [Units showErrorStatusWithString:@"请输入正确的电话号码"];
        return;
    }if (shortMobile.length ==0) {
        [Units showErrorStatusWithString:@"请输入短号"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@?jobNum=%@&userMobile=%@&userShortMobile=%@&emailAddress=%@",[UpdateMobile getWholeUrl], USERDEFAULT_object(JOBNUM),mobile,shortMobile,email];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool get:url parms:dict sucess:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"error"]integerValue]==0 ) {
            [Units showHudWithText:@"修改成功" view:weakSelf.view model:MBProgressHUDModeText];
            //保存修改之后的电话
            USERDEFAULT_SET_value(mobile, @"phone");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [Units showHudWithText:responseObject[@"info"] view:weakSelf.view model:MBProgressHUDModeText];
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units showHudWithText:error view:weakSelf.view model:MBProgressHUDModeText];
        [Units hiddenHudWithView:weakSelf.view];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DENewOrderTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.titleLab.text =[NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
    NSString * tipstring =self.datasource[indexPath.row];
    if ([tipstring isEqualToString:@"姓名"]||[tipstring isEqualToString:@"工号"]) {
        cell.contentTextField.enabled =NO;
    }else if ([tipstring isEqualToString:@"邮箱"]){
      cell.contentTextField.enabled =YES;
      cell.contentTextField.inputAccessoryView =self.tool;
    }
    else{
        cell.contentTextField.enabled =YES;
        cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTextField.inputAccessoryView =self.tool;
    }
    cell.contentTextField.delegate =self;
    cell.contentTextField.tag =indexPath.row;
    cell.contentTextField.text = self.contentArray[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"修改个人信息";
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * tipString =self.datasource[textField.tag];
    if ([tipString isEqualToString:@"邮箱"]) {
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }else if ([tipString isEqualToString:@"长号"]){
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }else if ([tipString isEqualToString:@"短号"]){
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    return YES;
}

@end
