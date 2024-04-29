//
//  MyDaiBanController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MyDaiBanController.h"
#import "HandleTableViewCell.h"

#import "HandleTaskModel.h"

@interface MyDaiBanController ()
@property (nonatomic,strong)NSMutableArray * sectionMutableArray;
@end

static NSString *const handleCelledId =@"cellId";

@implementation MyDaiBanController


-(void)loadMessage{
    NSString * url = [NSString stringWithFormat:@"%@%@",[HandleTaskURL getWholeUrl],USERDEFAULT_object(JOBNUM)];
    NSDictionary * dict = [NSDictionary dictionary];
    KWeakSelf
    [HttpTool get:url parms:dict sucess:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"error"]integerValue]==0) {
            NSMutableDictionary * totalDictionary = responseObject[@"rows"];
            NSArray * titleArray = [totalDictionary allValues];
            
            NSMutableArray * sectionArray = [NSMutableArray array];
            NSMutableArray * modelsArray = [NSMutableArray array];
            //指定 顺序数组
            NSArray *orderArray = @[@"来访流程",@"考勤薪资",@"物品转出",@"出差单据",@"厂车管理",@"轮休加班",@"客户来访",@"新客户开发",@"设备排水",@"设备维修",@"点检保养",@"厂务维修",@"厂务施工",@"厂务点检",@"技术服务",@"潜在客户管理",@"最新客户开发",@"拜访客户",@"新客户来访"];
            for (NSString * titleStr in orderArray) {
                for (NSDictionary * responDictionary in titleArray) {
                    if ([[responDictionary objectForKey:@"privilegeName"]isEqualToString:titleStr]) {
                        [sectionArray addObject:responDictionary];
                    }
                }
            }
            for (NSDictionary * sectionDictionary in sectionArray) {
                [modelsArray addObject:sectionDictionary[@"task"]];
                [weakSelf.sectionMutableArray addObject:sectionDictionary[@"privilegeName"]];
            }
            
            NSMutableArray * models = [HandleTaskModel mj_objectArrayWithKeyValuesArray:modelsArray];
            [weakSelf.datasource addObject:models];
        }
       
        [weakSelf.listView.mj_header endRefreshing];
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [weakSelf.listView.mj_header endRefreshing];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的待办";
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     // [self loadMessage];
    }];
  //  [self.listView.mj_header beginRefreshing];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.listView.estimatedRowHeight = 100.0f;
    [self.view addSubview:self.listView];
    [self.listView registerNib:[UINib nibWithNibName:@"HandleTableViewCell" bundle:nil] forCellReuseIdentifier:handleCelledId];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionMutableArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datasource[section]count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HandleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:handleCelledId];
    HandleTaskModel *model = self.datasource[indexPath.section][indexPath.row];
    [cell congigureCellContent:model rows:indexPath.row models:self.datasource];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSMutableArray*)sectionMutableArray{
    if (!_sectionMutableArray) {
        _sectionMutableArray =[NSMutableArray array];
    }return _sectionMutableArray;
}
@end
