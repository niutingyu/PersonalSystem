//
//  PasswordSetController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/19.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PasswordSetController.h"
#import "PasswordSetTableCell.h"

#define URL @"http://120.25.230.176:7070/hrpro/"
@interface PasswordSetController ()<UITextFieldDelegate>
{
    NSString * _jobNumber;
    NSString *_mobileString;
    NSString * _vertificaterString;
}
@property (nonatomic,copy)NSString *vertifyCode;//验证码
@end

@implementation PasswordSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置工资密码";
    NSArray * titles = @[@"工号",@"手机号",@"验证码"];
    [self.datasource addObjectsFromArray:titles];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"PasswordSetTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    
    //提交
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)sure{
    [self.view endEditing:YES];
   
    if (_jobNumber.length ==0) {
        [Units showErrorStatusWithString:@"请输入工号"];
        return;
    }if (![_vertificaterString isEqualToString:self.vertifyCode]) {
        [Units showErrorStatusWithString:@"请输入正确验证码"];
        return;
    }
    //请求网络
    NSString *urlString =[NSString stringWithFormat:@"%@userManger/resetPassword?jobNum=%@&state=%@",USERDEFAULT_object(@"url"),_jobNumber,@"1"];
    
    NSDictionary * dict = [NSDictionary dictionary];
    [Units showLoadStatusWithString:@"加载中..."];
    KWeakSelf
    [HttpTool get:urlString parms:dict sucess:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"msg"]];
        if ([[responseObject objectForKey:@"error"]integerValue]== 0 &&[responseObject objectForKey:@"msg"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PasswordSetTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    NSArray *contents =@[@"请输入工号",@"请输入手机号",@"请h输入验证码"];
    cell.titleLab.text = self.datasource[indexPath.row];
    NSString *tipString = self.datasource[indexPath.row];
    if ([tipString isEqualToString:@"工号"]||[tipString isEqualToString:@"手机号"]) {
        cell.vertifryButton.hidden = YES;
    }else{
        cell.vertifryButton.hidden =NO;
    }
    cell.contentTextField.tag = indexPath.row;
    cell.contentTextField.inputAccessoryView = self.tool;
    cell.contentTextField.placeholder = contents[indexPath.row];
    cell.contentTextField.delegate = self;
    KWeakSelf
    cell.vertifyBlock = ^(JKCountDownButton * _Nonnull sender) {
        [weakSelf.view endEditing:YES];
        if (self->_jobNumber.length ==0) {
            [Units showErrorStatusWithString:@"请输入工号"];
            return ;
        }
      if (self->_mobileString.length ==0) {
            [Units showErrorStatusWithString:@"请输入手机号"];
            return;
        }if (![self->_mobileString isPhoneNumber]) {
            [Units showErrorStatusWithString:@"请输入正确的手机号"];
            return;
        }
        [sender startCountDownWithSecond:60];
        NSString *urlString = [NSString stringWithFormat:@"%@userManger/getIdentifyingCode?jobNum=%@&userMobile=%@",URL,self->_jobNumber,self->_mobileString];
        
        NSDictionary * dict =[NSDictionary dictionary];
        [HttpTool get:urlString parms:dict sucess:^(id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"error"]integerValue]==0) {
                [Units showStatusWithStutas:@"验证码发送成功"];
                weakSelf.vertifyCode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"rows"]];
               
            }
            
        } error:^(NSString * _Nonnull error) {
            [Units showErrorStatusWithString:@"获取验证码失败"];
            
        }];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            countDownButton.enabled =NO;
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            
            return @"重新获取";
            
        }];
    };
    return cell;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"工号"]) {
        _jobNumber = textField.text;
    }else if ([tipString isEqualToString:@"手机号"]){
        _mobileString =textField.text;
    }else if ([tipString isEqualToString:@"验证码"]){
        _vertificaterString = textField.text;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
