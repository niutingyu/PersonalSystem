//
//  DEMemberController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMemberController.h"
#import "DEMemberTableViewCell.h"
#import "ZHPickView.h"
#import "DEMemberModel.h"
#import "ZHPickView+Category.h"
#import "YBPopupMenu.h"

#import "MoudleModel.h"


#import "DEMemberStatusController.h"
@interface DEMemberController ()<UITableViewDelegate,UITableViewDataSource,ZHPickViewDelegate,YBPopupMenuDelegate>
{
    NSString * _memberStatus;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * datasource;

@property (nonatomic,strong)NSMutableArray * sectionArray;
@property (nonatomic,strong)NSMutableArray * rowArray;

@property (nonatomic,copy)NSString *factoryId;//g所属工厂

@property (nonatomic,strong)NSMutableArray * factoryMutableArray;//工厂数组
@end

@implementation DEMemberController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"人员";
    [self.view addSubview:self.tableView];
    self.tableView.defaultNoDataText = @"暂无更多数据";
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self loadMessage];
    }];
    if (!_factoryMutableArray) {
        _factoryMutableArray =[NSMutableArray array];
    }
    //获取人员所属工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    if (moudleStatus.FactoryList.count >1) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"切换工厂" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(chosFactory:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem =rightItem;
        self.factoryId = moudleStatus.FactoryList[0][@"FactoryId"];
        [_factoryMutableArray removeAllObjects];
      
        
        [_factoryMutableArray addObjectsFromArray:moudleStatus.FactoryList];
        [_factoryMutableArray addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
        
    }else{
        self.factoryId  =moudleStatus.FactoryList[0][@"FactoryId"];
        self.navigationItem.rightBarButtonItem =nil;
    }
    
    [self loadMessage];
    
}
-(void)chosFactory:(UIButton*)sender{
    NSMutableArray * titles  =[NSMutableArray array];
    [titles removeAllObjects];
    for (NSDictionary *dict in _factoryMutableArray) {
        [titles addObject:dict[@"FactoryName"]];
    }
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf;
    
    for (int i =0; i<titles.count; i++) {
        [controller addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.factoryId  = weakSelf.factoryMutableArray[i][@"FactoryId"];
            [weakSelf loadMessage];
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rowArray[section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DEMemberModel *model = self.rowArray[indexPath.section][indexPath.row];
    cell.model =model;
    [cell.statusButton setTitle:model.TaskFlag forState:UIControlStateNormal];
    [cell.telphoneButton setTitle:model.ClassesName forState:UIControlStateNormal];
    cell.buttonBlock = ^(NSInteger idx) {
        if (idx == 1000) {
            DEMemberStatusController * controller =[DEMemberStatusController new];
            controller.maintainUserId =model.UserId;
           
            [self.navigationController pushViewController:controller animated:YES];
           
        }else if (idx ==1001){
           
            [self chosMemberStatus:indexPath.row section:indexPath.section];
        }else{
            [self callTel:indexPath.row section:indexPath.section];
        }
    };
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [UIView new];
    headView.frame = CGRectMake(0, 0, kScreenWidth, 40.0f);
    headView.backgroundColor = RGBA(30, 152, 255, 1);
    UILabel * titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(2, 14.5, headView.frame.size.width-4, 21);
    titleLab.text = self.sectionArray[section];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkTextColor];
    [headView addSubview:titleLab];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

#pragma mark == = = == 选择人员状态
-(void)chosMemberStatus:(NSInteger)idx section:(NSInteger)section{
    ZHPickView * pickView = [[ZHPickView alloc]initPickviewWithArray:@[@"调休",@"白班",@"晚班"] isHaveNavControler:NO];
    pickView.delegate = self;
    pickView.tag = idx;
    pickView.flag = section;
    debugLog(@"= = %ld",section);
    [pickView show];
}
-(void)onDoneBtnClick:(ZHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger)resultIndex{
   
    DEMemberModel *model = self.rowArray[pickView.flag][pickView.tag];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setObject:model.UsersExtendId forKey:@"UsersExtendId"];
    [dict setObject:[NSString stringWithFormat:@"%ld",resultIndex] forKey:@"Classes"];//type
    NSMutableArray * jsonArr = [NSMutableArray array];
    [jsonArr addObject:dict];
    //转为json
    NSString * jsonStr = [Units arrayToJson:jsonArr];
    
    //最终参数
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [parms setObject:jsonStr forKey:@"EngineerArray"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:_factoryId?:@"" forKey:@"FactoryId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:[DeviceUpdateMemberStatusURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [Units showHudWithText:responseObject[@"info"] view:self.view model:MBProgressHUDModeText];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            [self.tableView reloadData];

        }
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:self.view];
        [Units showErrorStatusWithString:error];
    }];
   
}

#pragma mark === = = ====打电话

-(void)callTel:(NSInteger)idx section:(NSInteger)section{
    DEMemberModel * model = self.rowArray[section][idx];
    debugLog(@"- - --%@",model.UserMobile);
    if ([model.UserMobile isEqualToString:@""]&&[model.UserShortMobile isEqualToString:@""]) {
        [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@未绑定手机号",model.FName]];
        return ;
    }
    UIAlertController * controller= [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"给%@打电话",model.FName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"长号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self callWithNumber:model.UserMobile andView:self.view];
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"短号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callWithNumber:model.UserShortMobile?:model.UserMobile andView:self.view];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:action3];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)callWithNumber:(NSString *)num andView:(UIView *)view {
   // UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]];//
    [[UIApplication sharedApplication]openURL:telURL];
    //[callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
   // [view addSubview:callWebview];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 50.0f;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DEMemberTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellId"];
        
    }
    return _tableView;
}
-(NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
-(void)loadMessage{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:@"7" forKey:@"Type"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:_factoryId?:@"" forKey:@"FactoryId"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POSTWithParms:[DeviceEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:self.view];
        [self.datasource removeAllObjects];
        [self.sectionArray removeAllObjects];
        [self.rowArray removeAllObjects];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 = [DEMemberModel mj_objectArrayWithKeyValuesArray:arr];
            [self.datasource addObjectsFromArray:arr1];
            
        }
        for (DEMemberModel *model in self.datasource) {
            if (![self.sectionArray containsObject:model.DistrictName]) {
                [self.sectionArray addObject:model.DistrictName];
            }
        }
        
        for (NSString * title in self.sectionArray) {
            NSMutableArray * childRowArray = [NSMutableArray array];
            for (DEMemberModel *model in self.datasource) {
                if ([model.DistrictName isEqualToString:title]) {
                    [childRowArray addObject:model];
                    
                }
            }
            [self.rowArray addObject:childRowArray];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        debugLog(@"- - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hiddenHudWithView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
   
}
-(NSMutableArray*)sectionArray{
    if (!_sectionArray) {
        _sectionArray =[NSMutableArray array];
    }
    return _sectionArray;
}
-(NSMutableArray*)rowArray{
    if (!_rowArray) {
        _rowArray =[NSMutableArray array];
    }return _rowArray;
}
@end
