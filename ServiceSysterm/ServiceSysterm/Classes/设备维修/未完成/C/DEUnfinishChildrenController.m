//
//  DEUnfinishChildrenController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishChildrenController.h"
#import "DEUnFinishTableCell.h"
#import "DEUnfinishDetailController.h"
@interface DEUnfinishChildrenController ()
@property (nonatomic,strong)NSMutableArray * filterArray;
@end

@implementation DEUnfinishChildrenController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(NSMutableArray*)filterArray{
    if (!_filterArray) {
        _filterArray =[NSMutableArray array];
    }return _filterArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEUnFinishTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];

    for (DEUnfinishModel * model in self.mouleArray) {
        if ([_selectedTypeString isEqualToString:model.TaskStatusName]) {
            if (![self.filterArray containsObject:model]) {
                [self.filterArray addObject:model];
            }
        }if ([_selectedTypeString isEqualToString:@"所有"]) {
            self.filterArray = self.mouleArray;
        }
    }
   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filterArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUnFinishTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DEUnfinishModel *model = self.filterArray[indexPath.section];
    [cell configureCell:model datasource:self.filterArray idx:indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUnfinishModel * model = self.filterArray[indexPath.section];
    DEUnfinishDetailController * controller = [[DEUnfinishDetailController alloc]init];
    controller.maintainId = model.MaintainTaskId;
    controller.controllerType =@"设备维修";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
