//
//  ProfileViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ProfileViewController.h"

#import "ProfileTableHeadView.h"
#import "WXWaveView.h"
#import "LoginOutTableViewCell.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"
#import "OrganaztionViewController.h"
#import "PersonalSetController.h"
#import "PassWordReSetAlertView.h"
#import "PasswordSetController.h"
#import <IQKeyboardManager.h>
@interface ProfileViewController ()


@end

@implementation ProfileViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    [IQKeyboardManager sharedManager].enable =YES;
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    //self.edgesForExtendedLayout = UIRectEdgeTop;
    ProfileTableHeadView * headView = [[NSBundle mainBundle]loadNibNamed:@"ProfileTableHeadView" owner:self options:nil].firstObject;
    headView.frame = CGRectMake(0, 0, kScreenWidth, 240);
   
    [self.view addSubview:headView];
    
    //水波纹
    WXWaveView * waveView = [WXWaveView addToView:headView withFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)-85, CGRectGetWidth(self.view.frame), 6)];
    waveView.waveTime = 0.f;
    waveView.waveSpeed = 8.f;
    waveView.angularSpeed = 1.8f;
    waveView.waveColor = RGBA(239, 239, 244, 1);
    [waveView wave];
    [self.view addSubview:self.listView];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.listView.rowHeight = 50;
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([LoginOutTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"reusedId"];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(waveView).mas_offset(0);
        make.bottom.mas_equalTo(self.view);
        
    }];
   
    NSArray * arr =@[@"部门组织架构",@"个人设置",@"重置登录密码"];
    [self.datasource addObjectsFromArray:arr];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.datasource.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        static NSString *reusedIdtifire = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reusedIdtifire];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdtifire];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray * images =@[@"mine_icon8",@"mine_icon1",@"mine_icon3"];
        cell.textLabel.text = self.datasource[indexPath.row];
        cell.imageView.image =[UIImage imageNamed:images[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        LoginOutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reusedId"];
        KWeakSelf
        cell.loginout = ^{
            [weakSelf loginOutCode];
        };
        return cell;
    }
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        NSString * tipString = self.datasource[indexPath.row];
        if ([tipString isEqualToString:@"部门组织架构"]) {
            [self.navigationController pushViewController:[OrganaztionViewController new] animated:YES];
        }else if ([tipString isEqualToString:@"个人设置"]){
            [self.navigationController pushViewController:[PersonalSetController new] animated:YES];
        }else if ([tipString isEqualToString:@"重置登录密码"]){
            [self.navigationController pushViewController:[PasswordSetController new] animated:YES];
        }
    }
}
-(void)loginOutCode{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出当前账号吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [kUserDefaults removeObjectForKey:USERID];
        [kUserDefaults removeObjectForKey:JOBNUM];
        
        
        BaseNavViewController * nav = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:defaultAction];
    [controller addAction:cancelAction];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
}
@end
