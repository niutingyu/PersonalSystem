//
//  DEHistoryListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEHistoryListController.h"
#import "MoudleModel.h"
@interface DEHistoryListController (){
NSString * _beginTime;
NSString * _endTime;
NSString * _districtId;
NSString * _engineer;
NSString * _departmentNo;
NSString * _deviceId;
NSString * _orderNo;
NSString *_orderUserName;
NSString * _selectedTitle;//选择的标题
}
@end

@implementation DEHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史";
    //取出工厂
    
     NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
     MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
     [modleArchiver finishDecoding];
    debugLog(@"- - %ld",moudleStatus.FactoryList.count);
    if (moudleStatus.FactoryList.count >1) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"切换工厂" forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chosFactory:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    [self.mutaleParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [self.mutaleParms setObject:@"1" forKey:@"ListType"];
    NSString * beginTimeString = [NSString stringWithFormat:@"%@ 00:00:00",[Units getNowDate:-4]];
    NSString * endTimeString =[NSString stringWithFormat:@"%@ 23:59:59",[Units getNowDate:0]];
    
    [self.mutaleParms setObject:_beginTime?:beginTimeString forKey:@"StartTime"];
    [self.mutaleParms setObject:_endTime?:endTimeString forKey:@"EndTime"];
    [self.mutaleParms setObject:_districtId?:@"" forKey:@"MaintainDistrictId"];
    [self.mutaleParms setObject:_engineer?:@"" forKey:@"AcceptUser"];
    [self.mutaleParms setObject:_departmentNo?:@"" forKey:@"OrId"];
    [self.mutaleParms setObject:_deviceId?:@"" forKey:@"FacilityId"];
    [self.mutaleParms setObject:_orderNo?:@"" forKey:@"TaskCode"];
    [self.mutaleParms setObject:_orderUserName?:@"" forKey:@"OperCreateUserName"];
    [self loadMessageparms:self.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl]];
   
    
}

-(void)chosFactory:(UIButton*)sender{
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
      MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    KWeakSelf
   NSMutableArray * factories =[NSMutableArray array];
   [factories removeAllObjects];
   [factories addObjectsFromArray:moudleStatus.FactoryList];
   [factories addObject:@{@"FactoryName":@"不限",@"FactoryId":@""}];
    for (int i =0; i<factories.count; i++) {
        NSString * title  =factories[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.mutaleParms setObject:factories[i][@"FactoryId"] forKey:@"FactoryId"];
            [weakSelf loadMessageparms:weakSelf.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl]];
            
           
            
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

@end
