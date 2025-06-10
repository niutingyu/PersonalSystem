//
//  LoginViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabbarController.h"
#import "UserModel.h"
#import "MoudleModel.h"
#import "NetworkViewController.h"
#import "RevisePasswordController.h"
#import "PDKeyChain.h"
#import "NetMoudleListArray.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *PSDTextField;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *selecteNet;

@property (nonatomic,copy)NSString * netURL;
@property (nonatomic,copy)NSString * currentDeviceType;//当前设备
@property (weak, nonatomic) IBOutlet UILabel *VersionLab;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //只有账号后面加s3个0的情况选择网址按钮才显示 所以按钮默认是隐藏
   // self.selecteNet.hidden = YES;
    //ipad设备隐藏选择网址按钮 默认内网
  /*  NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        self.selecteNet.hidden = YES;
    }*/
    self.selecteNet.hidden  =YES;
    self.codeTextField.delegate  =self;
    
    
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.clipsToBounds = YES;
    self.PSDTextField.secureTextEntry = YES;
    //默认显示账号和密码
    NSString * codeStr = USERDEFAULT_object(@"code");
    NSString * PSDword = USERDEFAULT_object(PassWord);
    self.codeTextField.text =codeStr;
    self.PSDTextField.text = PSDword;
    
    
    //t网址通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getURL:) name:@"serverAddress" object:nil];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    self.VersionLab.text  =[NSString stringWithFormat:@"版本号:%@",versionNum];
    
   
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * codeStr;
    NSString * inputStr = textField.text;
    if (inputStr.length >5) {
      codeStr = [self.codeTextField.text substringFromIndex:textField.text.length-3];//从后三位开始切割
    }
    if ([codeStr isEqualToString:@"000"]) {
        self.selecteNet.hidden  =NO;
    }else{
        self.selecteNet.hidden  =YES;
    }
        
        
    return YES;
}
-(void)getURL:(NSNotification*)notification{
    NSDictionary * netDict = [notification object];
    _netURL = netDict[@"network"];
   
}
- (IBAction)login:(id)sender {
    if ([self.codeTextField.text isEqualToString:@"admin"]) {
        [self loginNet];
    }else{
#if TARGET_IPHONE_SIMULATOR
        [self loginNet];
#elif TARGET_OS_IPHONE
      [self registerJPush];
    
         #endif
    }
    
   
}

#pragma mark === === == == = = ===login
//登录
-(void)loginNet{
    
    if (self.codeTextField.text.length == 0) {
        [Units showStatusWithStutas:@"请输入账号"];
        return;
    }else if (self.PSDTextField.text.length == 0){
        [Units showStatusWithStutas:@"请输入密码"];
        return;
    }
    
    //在这里判断外网和内网,加三个零区分内网和外网 ，登录时把三个0去掉
    NSString * codeStr;
    NSString * inputStr = self.codeTextField.text;
    if (inputStr.length >5) {
      codeStr = [self.codeTextField.text substringFromIndex:self.codeTextField.text.length-3];//从后三位开始切割
    }
    
    
    if (_netURL.length == 0) {
        //没有选择网址 默认是外网
        _netURL = NetworkServerAddress;
        //判断账号
        if ([codeStr isEqualToString:@"000"]) {
            
            inputStr = [self.codeTextField.text substringToIndex:self.codeTextField.text.length -3];//去掉账号后面3个0
            [Units showStatusWithStutas:@"请选择正确的网址"];
            self.selecteNet.hidden =NO;
            return;
        }
        
    }else{
        //选择了网址
        //判断账号
       
        if ([codeStr isEqualToString:@"000"]) {
            //输入的账号是属于内网的账号,判断当前网址
            inputStr = [self.codeTextField.text substringToIndex:self.codeTextField.text.length -3];
            if ([_netURL isEqualToString:NetworkServerAddress]) {
                [Units showStatusWithStutas:@"请选择正确的网址"];
                return;
            }
            
        }
    }
    
    //选择完毕 保存网址
    //判断什么设备
//    NSString * deviceType = [UIDevice currentDevice].model;
//    if ([deviceType isEqualToString:@"iPad"]) {
//        USERDEFAULT_SET_value(ServerAddress,@"url");
//    }else{
//      USERDEFAULT_SET_value(_netURL, @"url");
//    }
    
    USERDEFAULT_SET_value(_netURL, @"url");
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    
    [parms setObject:self.PSDTextField.text forKey:@"Password"];
    [parms setObject:inputStr forKey:@"UserName"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    [parms setObject:versionNum forKey:@"NowVersion"];
    [parms setObject:@"ios" forKey:@"DeviceType"];
    
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    
    //苹果审核登录不上账号，在这里做个硬编码数据
    //测试
   
    NSDictionary * responseObj = @{
                                   @"BaseMsg" :@{
                                           @"DepName":@"IT信息部",
                                           @"FName":@"汪俊",
                                           @"OrId":@"EFD882A25516497D8CC05C0D35316E0F",
                                           @"UserId":@"47051ed7903f42b098e78ac0f4431417",
                                           @"UserName":@"WJ9094",
                                   },
                                   
                                   @"ModulesList" : @[
                                                      @{
                                                    @"ModuleId":@"ea349cc13a5a4ebda4354b2b2c444731",
                                                          @"ModuleName" : @"设备维修",
                                                          @"PrivilegeId":@"101",
                                                          },
                                                      @{
                                                          @"ModuleId": @"8b1733da3d2f407aaa3625640f465b3d",
                                                          @"ModuleName" : @"设备点检保养",
                                                          @"PrivilegeId" : @"102",
                                                      },
                                                      ]
                                   };
    
    if ([inputStr isEqualToString:@"admin"]) {
        [Units hideView];
        USERDEFAULT_SET_value(@"WJ9094", JOBNUM);
        USERDEFAULT_SET_value(@"admin", CodeName);
        USERDEFAULT_SET_value(@"47051ed7903f42b098e78ac0f4431417", USERID);
        USERDEFAULT_SET_value(@"EFD882A25516497D8CC05C0D35316E0F", @"orderId");
        
        MoudleModel * model = [MoudleModel mj_objectWithKeyValues:responseObj];
        
        [Units writeDataTodiskWithKeyStr:Function_WriteDisk path:@"functionModel" idObj:model];
        //跳转页面
        UIStoryboard * stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabbarController * tabController = [stroyboard instantiateViewControllerWithIdentifier:@"tabar"];
        tabController.modalPresentationStyle =UIModalPresentationFullScreen;
        [self presentViewController:tabController animated:YES completion:nil];
        
        
    }else{
        [HttpTool login:[LoginUrl getWholeUrl] parm:parms sucess:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
             debugLog(@"= = =%@",responseObject);
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 0 ) {
                
                //登录成功
                NSDictionary * responseDict = [Units jsonToDictionary:responseObject[@"data"]];
                
                USERDEFAULT_SET_value(responseDict[@"jobNum"], JOBNUM);
                USERDEFAULT_SET_value(responseDict[@"jobName"], CodeName);
                if ([responseDict[@"userMobile"] isKindOfClass:[NSNull class]]) {
                    USERDEFAULT_SET_value(@"", @"phone");
                    
                }else{
                    USERDEFAULT_SET_value(responseDict[@"userMobile"], @"phone");
                    
                }
                /**
                 保存短号
                 */
                USERDEFAULT_SET_value(responseDict[@"jobNum"], @"shortMobile");
                [weakSelf getmoudleDataWithMobile:responseDict[@"userMobile"] shortMobile:responseDict[@"UserShortMobile"] jobNum:responseDict[@"jobNum"]];
                
                
                
                
                //保存账号和密码
                BOOL isOn = weakSelf.switchButton.isOn;
                if (isOn  ==YES) {
                    [weakSelf holdLoginedCode];
                }
            }else if ([[responseObject objectForKey:@"status"]integerValue]==-3){
                
            }
        } error:^(NSString * _Nonnull error) {
            [Units showErrorStatusWithString:error];
            
        }];
    }
    

}


#pragma mark === = = = = ===获取权限模块
//获取登录之后展示的权限模块
-(void)getmoudleDataWithMobile:(NSString*)mobile shortMobile:(NSString*)shortMobile jobNum:(NSString*)jobNum{
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    [dict setObject:@"ios" forKey:@"DeviceType"];
    [dict setObject:mobile?:@"" forKey:@"UserMobile"];
    [dict setObject:shortMobile?:@"" forKey:@"UserShortMobile"];
    [dict setObject:versionNum forKey:@"NowVersion"];
    [dict setObject:[JPUSHService registrationID]?:@"iOS66666666666" forKey:@"Alias"];
    [params setObject:[Units dictionaryToJson:dict] forKey:@"model"];
    [params setObject:jobNum?:@"" forKey:@"jobNum"];
    KWeakSelf
    
    [HttpTool POST:[FunctionModleURL getWholeUrl] param:params success:^(id  _Nonnull responseObject) {
        //debugLog(@" - - -%@",responseObject);
        if ([[responseObject objectForKey:@"status"]integerValue] ==0) {
            NSDictionary * responseDict = [Units jsonToDictionary:responseObject[@"data"]];
            debugLog(@"-- - --=== =%@",responseDict[@"BaseMsg"]);
            for (NSDictionary * dict in responseDict[@"FactoryList"]) {
                debugLog(@"- --=== ===____%@",dict[@"FactoryName"]);
            }
        
            debugLog(@" == = = == = = = = =%@",responseDict);
            NSArray * arr  = responseDict[@"ModulesList"];
            for (NSDictionary * dic in arr) {
                debugLog(@" == = - - - - == = %@,%@,%@",dic[@"ModuleName"],dic[@"ModuleId"],dict[@"PrivilegeId"]);
            }
            NSString * userId = responseDict[@"BaseMsg"][@"UserId"];
            NSString * ordId = responseDict[@"BaseMsg"][@"OrId"];
            NSString * fName  =responseDict[@"BaseMsg"][@"FName"];
            //保存部门
            NSString * departmentStr  = responseDict[@"BaseMsg"][@"DepName"];
            
            USERDEFAULT_SET_value(userId, USERID);
            USERDEFAULT_SET_value(ordId, @"orderId");
            USERDEFAULT_SET_value(fName, @"fname");
            USERDEFAULT_SET_value(departmentStr, @"DEPARTMENT");
            
            MoudleModel * model = [MoudleModel mj_objectWithKeyValues:responseDict];
            
            [Units writeDataTodiskWithKeyStr:Function_WriteDisk path:@"functionModel" idObj:model];
            NetMoudleListArray * netMoudle =[[NetMoudleListArray alloc]init];
            [netMoudle initMoudleWithMoudleArray:arr];
            
            
        }
        
        //跳转页面
        UIStoryboard * stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabbarController * tabController = [stroyboard instantiateViewControllerWithIdentifier:@"tabar"];
        tabController.modalPresentationStyle =UIModalPresentationFullScreen;
        [weakSelf presentViewController:tabController animated:YES completion:nil];
        //debugLog(@"%ld",self.modalPresentationStyle);
    } error:^(NSString * _Nonnull error) {
        debugLog(@"= = =error%@",error);
    }];
}
- (IBAction)chosNetURL:(id)sender {
    
    [self.navigationController pushViewController:[NetworkViewController new] animated:YES];
}
#pragma mark === = = = == ===JPush
//注册推送

-(void)registerJPush{
    
    //判断下是否是iPad
    NSString * deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        [self loginNet];
    }else{
        [Units showLoadStatusWithString:@"绑定推送中..."];
        [JPUSHService setAlias:[JPUSHService registrationID] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            [Units hideView];
            if (iResCode != 0) {
                [self alertView];
            }else{
                //
                [self loginNet];
                
            }
        } seq:0];
    }
    
    
}

//弹框
-(void)alertView{
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"注册推送失败" message:@"继续登录推送消息功能将失效" preferredStyle:UIAlertControllerStyleAlert];
    KWeakSelf
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf loginNet];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:sureAction];
    [alertcontroller addAction:cancelAction];
    [self presentViewController:alertcontroller animated:YES completion:nil];
    
}


#pragma mark == == = = = = == 保存账号和密码

-(void)holdLoginedCode{
  //站好已经保存 换个key
    USERDEFAULT_SET_value(self.codeTextField.text, @"code");
    USERDEFAULT_SET_value(self.PSDTextField.text, PassWord);
    
    
}
- (IBAction)reviseButton:(id)sender {
    [self.navigationController pushViewController:[RevisePasswordController new] animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
