//
//  DEMemberStatusBaseController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMemberStatusBaseController.h"
#import "DEUnFinishTableCell.h"
#import "DEUnFinishModel.h"

#import "DEUnfinishDetailController.h"
@interface DEMemberStatusBaseController ()

@end

@implementation DEMemberStatusBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.tableView];
  
    self.tableView.estimatedRowHeight =100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEUnFinishTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUnFinishTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DEUnfinishModel * model = self.datasource[indexPath.section];
    [cell configureCell:model datasource:self.datasource idx:indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * typeStr =nil;
    DEUnfinishModel * model = self.datasource[indexPath.section];
    if ([model.MaintainFaultName isEqualToString:@"点检"]||[model.MaintainFaultName isEqualToString:@"保养"]) {
        typeStr = @"设备点检";
    }else{
        typeStr =@"设备维修";
    }
    DEUnfinishDetailController * controller =[DEUnfinishDetailController new];
    controller.controllerType = typeStr;
   
    controller.maintainId =model.MaintainTaskId;
    
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)filterMessage:(NSString*)typeString{
    for (DEUnfinishModel *model in self.itemsArray) {
        
        if ([model.MaintainFaultName isEqualToString:typeString]) {
            [self.datasource addObject:model];
        }if ([typeString isEqualToString:@"维修"]) {
            if (![model.MaintainFaultName isEqualToString:@"点检"]&&![model.MaintainFaultName isEqualToString:@"保养"]) {
                 [self.datasource addObject:model];
            }
        }
        
    }
    
}

@end
