//
//  DEUnfinishListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishListController.h"

#import "DEChosConditonController.h"

#import "MoudleModel.h"
@interface DEUnfinishListController ()
{
    NSString * _beginTime;
    NSString * _endTime;
    NSString * _districtId;
    NSString * _engineer;
    NSString * _departmentNo;
    NSString * _deviceId;
    NSString * _orderNo;
    NSString *_orderUserName;
    NSString * _factoryId;//工厂id
   // NSString * _selectedTitle;//选择的标题
    
    
}

@end

@implementation DEUnfinishListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSegmetControl];
   
    [self.mutaleParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [self.mutaleParms setObject:@"0" forKey:@"ListType"];
    [self.mutaleParms setObject:_beginTime?:@"" forKey:@"StartTime"];
    [self.mutaleParms setObject:_endTime?:@"" forKey:@"EndTime"];
    [self.mutaleParms setObject:_districtId?:@"" forKey:@"MaintainDistrictId"];
    [self.mutaleParms setObject:_engineer?:@"" forKey:@"AcceptUser"];
    [self.mutaleParms setObject:_departmentNo?:@"" forKey:@"OrId"];
    [self.mutaleParms setObject:_deviceId?:@"" forKey:@"FacilityId"];
    [self.mutaleParms setObject:_orderNo?:@"" forKey:@"TaskCode"];
    [self.mutaleParms setObject:_orderUserName?:@"" forKey:@"OperCreateUserName"];
    [self loadMessageparms:self.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getItem:) name:@"chosItem" object:nil];
    //取出工厂
     
      NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
      MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
      [modleArchiver finishDecoding];
    if (moudleStatus.FactoryList.count ==1) {
        UIButton * btn1  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"筛选" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
            
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        UIButton * btn1  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"筛选" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2  =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"工厂" forState:UIControlStateNormal];
        btn2.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(chosFactory) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * rightItem1  =[[UIBarButtonItem alloc]initWithCustomView:btn1];
        
        UIBarButtonItem *rightItem2  =[[UIBarButtonItem alloc]initWithCustomView:btn2];
        NSArray * arr  =@[rightItem1,rightItem2];
        self.navigationItem.rightBarButtonItems =arr;
    }
    
    
    
    
}

-(void)filter{
    DEChosConditonController * controller =[DEChosConditonController new];
    [self.navigationController pushViewController:controller animated:YES];
    KWeakSelf
    controller.passItemBlock = ^(FilterModel * _Nonnull filterModel) {
     
       
        [weakSelf.mutaleParms setObject:filterModel.startTime?:@"" forKey:@"StartTime"];//开始时间
      
        [weakSelf.mutaleParms setObject:filterModel.endTime?:@"" forKey:@"EndTime"];//结束时间
      
        [weakSelf.mutaleParms setObject:filterModel.districtId?:@"" forKey:@"MaintainDistrictId"];//区域名称
      
        [weakSelf.mutaleParms setObject:filterModel.engineerId?:@"" forKey:@"AcceptUser"];//维修工程师
      
        [weakSelf.mutaleParms setObject:filterModel.departmentId?:@"" forKey:@"OrId"];
      
        //部门名称
        [weakSelf.mutaleParms setObject:filterModel.deviceId?:@"" forKey:@"FacilityId"];//设备名称
      
        [weakSelf.mutaleParms setObject:filterModel.orderNumber?:@"" forKey:@"TaskCode"];//维修单号
     
        [weakSelf.mutaleParms setObject:filterModel.orderName?:@"" forKey:@"OperCreateUserName"];//开单人名称
      
        
        [weakSelf loadMessageparms:weakSelf.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl] ];
    };
    
}

-(void)chosFactory{
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
            self->_factoryId = factories[i][@"FactoryId"];
//            [weakSelf.mutaleParms setObject:self->_beginTime?:@"" forKey:@"StartTime"];//开始时间
//
//            [weakSelf.mutaleParms setObject:self->_endTime?:@"" forKey:@"EndTime"];//结束时间
//
//            [weakSelf.mutaleParms setObject:self->_districtId?:@"" forKey:@"MaintainDistrictId"];//区域名称
//
//            [weakSelf.mutaleParms setObject:self->_engineer?:@"" forKey:@"AcceptUser"];//维修工程师
//
//            [weakSelf.mutaleParms setObject:self->_departmentNo?:@"" forKey:@"OrId"];
//
//
//            [weakSelf.mutaleParms setObject:self->_deviceId?:@"" forKey:@"FacilityId"];//设备名称
//
//            [weakSelf.mutaleParms setObject:self->_orderNo?:@"" forKey:@"TaskCode"];//维修单号
//
//            [weakSelf.mutaleParms setObject:self->_orderUserName?:@"" forKey:@"OperCreateUserName"];//开单人名称
//            [weakSelf.mutaleParms setObject:moudleStatus.FactoryList[i][@"FactoryId"] forKey:@"FactoryId"];
            [weakSelf.mutaleParms setObject:self->_factoryId forKey:@"FactoryId"];
            [weakSelf loadMessageparms:weakSelf.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl]];
            
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
         
}
-(void)getItem:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    NSString *typeString = dict[@"item"];
    [self.mutaleParms setObject:typeString forKey:@"ListType"];
    [self loadMessageparms:self.mutaleParms url:[DeviceUnfinishTaskURL getWholeUrl]];
    
}


@end
