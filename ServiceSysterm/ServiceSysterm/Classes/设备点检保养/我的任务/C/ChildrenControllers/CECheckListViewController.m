//
//  CECheckListViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CECheckListViewController.h"
#import "CEMyTaskTableViewCell.h"
#import "CETaskModel.h"

#import "DEUnfinishDetailController.h"
@interface CECheckListViewController ()

@end

@implementation CECheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"CEMyTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CEMyTaskTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    CETaskModel *model =self.datasource[indexPath.row];
    [cell configureCell:self.datasource rowIdx:indexPath.row model:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CETaskModel * model = self.datasource[indexPath.row];
    DEUnfinishDetailController * controller =[DEUnfinishDetailController new];
    controller.controllerType =@"设备点检保养";
    controller.maintainId =model.MaintainDjbyId;
    [self.navigationController pushViewController:controller animated:YES];
    KWeakSelf
    controller.sucessInternetBlock = ^{
        [weakSelf.datasource removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    };
    
}
-(void)filert:(NSString *)filterKey{
 
    for (CETaskModel *model in self.itemsArray) {
        if ([model.MaintainFaultName isEqualToString:filterKey]) {
            [self.datasource addObject:model];
        }
    }
    
}
@end
