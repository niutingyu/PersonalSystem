//
//  CECheckUnFinishChildController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CECheckUnFinishChildController.h"
#import "CECheckListTableCell.h"
#import "CEUnFinishModel.h"

#import "DEUnfinishDetailController.h"
@interface CECheckUnFinishChildController ()
@property (nonatomic,strong)NSMutableArray * filterDataArray;
@end

@implementation CECheckUnFinishChildController

-(NSMutableArray*)filterDataArray{
    if (!_filterDataArray) {
        _filterDataArray =[NSMutableArray array];
    }return _filterDataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refeshTable) name:@"refreshTableView" object:nil];
  
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"CECheckListTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
 
   //筛选数据 d获取每个分类的具体数据
    for (CEUnFinishModel *model in self.dataArray) {
      
        if ([_tipTitleString isEqualToString:model.TaskStatusName]) {
            if (![self.filterDataArray containsObject:model]) {
              [self.filterDataArray addObject:model];
            }
            
        }if ([_tipTitleString isEqualToString:@"所有"]) {
            if (![self.filterDataArray containsObject:model]) {
              self.filterDataArray  = self.dataArray;
            }
            
        }
    }
    
   
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[self.filterDataArray removeAllObjects];
}
-(void)refeshTable{
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filterDataArray.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CECheckListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    CEUnFinishModel * model = self.filterDataArray[indexPath.row];
    
    [cell confiugeCell:self.filterDataArray rowIdx:indexPath.row model:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUnfinishDetailController * controller =[DEUnfinishDetailController new];
    controller.controllerType =@"设备点检保养";
    CEUnFinishModel *model = self.filterDataArray[indexPath.row];
    controller.maintainId =model.MaintainDjbyId;
    [self.navigationController pushViewController:controller animated:YES];
    KWeakSelf
    controller.sucessInternetBlock = ^{
        [weakSelf.filterDataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    };
}
@end
