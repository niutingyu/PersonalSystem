//
//  DEReBackController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEReBackController.h"

@interface DEReBackController ()
{
    NSString * MatRequisitionCode;
    NSString *MaterialCode;
}
@end

@implementation DEReBackController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //可回仓
   
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    NSMutableArray *sorts =[NSMutableArray array];
    NSDictionary *dict1 = @{@"Column":@"RequisitionOn",@"Direction":@"Desc"};
    [sorts addObject:dict1];
    [params setObject:[Units arrayToJson:sorts] forKey:@"sorts"];
    NSMutableArray *wheres =[NSMutableArray array];
    NSDictionary *dict2 = @{@"Column":@"IsReturnBill",@"Values":@false};
    NSDictionary *dict3 = @{@"Column":@"StartTime",@"Values":[self getNowDate:-1]};
    NSDictionary *dict4 = @{@"Column":@"EndTime",@"Values":[self getNowDate:0]};
    NSDictionary *dict5 = @{@"Column":@"DepInfo",@"Values":@"维修"};
    [wheres addObject:dict2];[wheres addObject:dict3];[wheres addObject:dict4];
    [wheres addObject:dict5];
    if (MatRequisitionCode.length !=0) {
        NSDictionary *dict5 = @{@"Column":@"MatRequisitionCode",@"Values":MatRequisitionCode};
        [wheres addObject:dict5];
    }
    if (MaterialCode.length !=0) {
        NSDictionary *dict6 = @{@"Column":@"MaterialCode",@"Values":MaterialCode};
        [wheres addObject:dict6];
    }
    
    [params setObject:[Units arrayToJson:wheres] forKey:@"wheres"];
    [self reloadMessageWithUrl:[DeviceBackStockURL getWholeUrl] parms:params flag:101];
    
}

-(void)getTime:(NSNotification*)notification{
    debugLog(@"----========");
}

@end
