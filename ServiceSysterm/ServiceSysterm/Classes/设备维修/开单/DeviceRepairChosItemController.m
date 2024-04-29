//
//  DeviceRepairChosItemController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/15.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceRepairChosItemController.h"
#import "DeviceModel.h"
#import "DENewOrderController.h"
#import "DEMyTaskViewController.h"
#import "DEHistoryListController.h"
#import "DEMemberController.h"
#import "DESearchController.h"
#import "DEUnfinishController.h"
#import "DEPickViewController.h"
#import "DEUnfinishListController.h"
#import "CECheckAddOrderController.h"
#import "CECheckUnFinishListController.h"
#import "MTMaintainNewOrderController.h"
#import "CheckMyTaskController.h"
#import "UIImage+ChangeColor.h"
#import "GarbageCreatViewController.h"
#import "WasterAddController.h"
#import "WasteTaskListController.h"
#import "WasterUnfinishController.h"
#import "WasterHistoryViewController.h"
#import "DeviceCorrectionController.h"
#import "DeviceCorrectionTaskController.h"
#import "DeviceCorrecetionHistoryListController.h"
#import "DeviceCorrectionUnfinishListController.h"
@interface DeviceRepairChosItemController ()

@end

@implementation DeviceRepairChosItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.typeController;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    self.tableView.rowHeight = 50.0f;
    //处理数据 c去掉 汇总 推送 异常 排名 积分
    if ([_typeController isEqualToString:@"维修工具管理"]) {
        NSMutableArray * arr = [[NSMutableArray alloc]initWithObjects:@"开单",@"任务",@"录入",@"历史", nil];
        if (![_maintainToolType isEqualToString:@"1"]) {
            [self.datasource addObjectsFromArray:arr];
        }else{
            [arr removeObject:@"录入"];
            [self.datasource addObjectsFromArray:arr];
        }
    }else{
        for (DeviceModel * model in self.moudleArray) {
            
            if ([model.RtName isEqualToString:@"开单"]) {
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"任务"]){
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"未完成"]){
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"历史"]){
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"人员"]){
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"领料"]){
                [self.datasource addObject:model.RtName];
            }else if ([model.RtName isEqualToString:@"查询"]){
                if(![self.typeController isEqualToString:@"设备校正"]){
                    [self.datasource addObject:model.RtName];
                }
            }else if ([model.RtName isEqualToString:@"新增"]){
                [self.datasource addObject:model.RtName];
            }
        }
    }
   
   
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    NSArray * images = @[@"chaxun",@"zonghekaidan",@"gougao-h",@"jilu",@"gougao-h",@"huaban",@"zonghekaidan"];
    UIImage * realImage = [UIImage imageNamed:images[indexPath.row]];
    cell.imageView.image = [realImage imageChangeColor:RGBA(0, 106, 255, 1)];
    
    
   
    cell.textLabel.text = self.datasource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tipStrig = self.datasource[indexPath.row];
    UIViewController * controller;
    if ([tipStrig isEqualToString:@"开单"]) {
        if ([self.typeController isEqualToString:@"设备维修"]) {
            controller = [DENewOrderController new];
        }else if ([self.typeController isEqualToString:@"设备点检保养"]){
            controller =[CECheckAddOrderController new];
        }else if ([self.typeController isEqualToString:@"维修工具管理"]){
            controller = [MTMaintainNewOrderController new];
        }else if ([self.typeController isEqualToString:@"废品变卖"]){
            controller  =[GarbageCreatViewController new];
        }else if ([self.typeController isEqualToString:@"设备校正"]){
            controller  =[DeviceCorrectionController new];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([tipStrig isEqualToString:@"新增"]){
        if ([self.typeController isEqualToString:@"废品变卖"]) {
            WasterAddController *controller  =[[WasterAddController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else if ([tipStrig isEqualToString:@"任务"]){
        if ([self.typeController isEqualToString:@"设备维修"]) {
            controller = [DEMyTaskViewController new];
        }else if ([self.typeController isEqualToString:@"设备点检保养"]){
            controller = [CheckMyTaskController new];
        }else if ([self.typeController isEqualToString:@"废品变卖"]){
            controller =[[WasteTaskListController alloc]init];
        }else if ([self.typeController isEqualToString:@"设备校正"]){
            controller  = [DeviceCorrectionTaskController new];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([tipStrig isEqualToString:@"未完成"]){
        if ([self.typeController isEqualToString:@"设备维修"]) {
            controller = [DEUnfinishListController new];
        }else if ([self.typeController isEqualToString:@"设备点检保养"]){
            controller = [CECheckUnFinishListController new];
        }else if ([self.typeController isEqualToString:@"废品变卖"]){
            controller  =[[WasterUnfinishController alloc]init];
        }else if ([self.typeController isEqualToString:@"设备校正"]){
            controller  =[DeviceCorrectionUnfinishListController new];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([tipStrig isEqualToString:@"历史"]){
        UIViewController *controller;
        if ([self.typeController isEqualToString:@"设备维修"]||[self.typeController isEqualToString:@"设备点检保养"]) {
            controller  =[[DEHistoryListController alloc]init];
            
        }else if ([self.typeController isEqualToString:@"废品变卖"]){
            controller  =[[WasterHistoryViewController alloc]init];
        }else if ([self.typeController isEqualToString:@"设备校正"]){
            controller  =[DeviceCorrecetionHistoryListController new];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([tipStrig isEqualToString:@"人员"]){
        [self.navigationController pushViewController:[DEMemberController new] animated:YES];
    }else if ([tipStrig isEqualToString:@"领料"]){
        [self.navigationController pushViewController:[DEPickViewController new] animated:YES];
    }else if ([tipStrig isEqualToString:@"查询"]){
        DESearchController * controller =[DESearchController new];
        controller.moudleArray = _moudleArray;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
