//
//  DEStockListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEStockListController.h"

@interface DEStockListController ()
{
    NSString *MatRequisitionCode; // 领料单号
    NSString *MaterialId;
    NSString *Status;
    NSString *ReturnBillNum; // 回仓单号
    NSString *MaterialName; // 物料名称
    NSString *MaterialInfo; // 物料规格
}

@property (nonatomic,strong)NSString *StartTime;
@property (nonatomic,strong)NSString *EndTime;
@end

@implementation DEStockListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //回仓表
    
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    NSMutableArray *sorts =[NSMutableArray array];
    NSDictionary *dict1 = @{@"Column":@"ReturnOn",@"Direction":@"Desc"};
    [sorts addObject:dict1];
    [params setObject:[Units arrayToJson:sorts] forKey:@"sorts"];
    NSMutableArray *wheres =[NSMutableArray array];
    NSDictionary *dict3 = @{@"Column":@"StartTime",@"Values":[self getNowDate:-1]};
    NSDictionary *dict4 = @{@"Column":@"EndTime",@"Values":[self getNowDate:0]};
    [wheres addObject:dict3];[wheres addObject:dict4];
    
    //    NSString *MatRequisitionCode; // 领料单号
    //    NSString *MaterialId;
    //    NSString *ReturnBillNum; // 回仓单号
    //    NSString *MaterialName; // 物料名称
    //    NSString *MaterialInfo; // 物料规格
    
    if (MatRequisitionCode.length != 0) {
        NSDictionary *dict = @{@"Column":@"MatRequisitionCode",@"Values":MatRequisitionCode};
        [wheres addObject:dict];
    }
    if (MaterialId.length != 0) {
        NSDictionary *dict = @{@"Column":@"MaterialId",@"Values":MaterialId};
        [wheres addObject:dict];
    }
    
    if (Status.length != 0) {
        NSInteger i = [Status integerValue];
        NSDictionary *dict = @{@"Column":@"Status",@"Values":@(i)};
        [wheres addObject:dict];
    }
    
    if (ReturnBillNum.length != 0) {
        NSDictionary *dict = @{@"Column":@"ReturnBillNum",@"Values":ReturnBillNum};
        [wheres addObject:dict];
    }
    if (MaterialName.length !=0) {
        NSDictionary *dict = @{@"Column":@"MaterialName",@"Values":MaterialName};
        [wheres addObject:dict];
    }
    if (MaterialInfo.length !=0) {
        NSDictionary *dict = @{@"Column":@"MaterialInfo",@"Values":MaterialInfo};
        [wheres addObject:dict];
    }
    
    [params setObject:[Units arrayToJson:wheres] forKey:@"wheres"];
    [self reloadMessageWithUrl:[DeviceStockListURL getWholeUrl] parms:params flag:102];
   
    
}
-(void)getTime:(NSNotification*)notification{
    debugLog(@"-------");
}


@end
