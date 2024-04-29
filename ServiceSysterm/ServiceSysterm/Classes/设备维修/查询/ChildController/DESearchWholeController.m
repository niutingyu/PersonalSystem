//
//  DESearchWholeController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchWholeController.h"
#import "MoudleModel.h"
@interface DESearchWholeController ()

@end

@implementation DESearchWholeController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getParms:) name:@"passParms" object:nil];
    _filterTimeView.beginTimeTextField.text =[NSString stringWithFormat:@"开始时间:%@",[Units getNowDate:-7]];
    _filterTimeView.endTimeTextField.text =[NSString stringWithFormat:@"结束时间:%@",[Units getNowDate:0]];
    [self.mutableParms setObject:_benginTimeString?:[Units getNowDate:-7] forKey:@"StartTime"];
    [self.mutableParms setObject:_endTimeString?:[Units getNowDate:0] forKey:@"EndTime"];
        [self.mutableParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    NSString *productId  =moudleStatus.FactoryList[0][@"FactoryId"]?:@"";
    [self.mutableParms setObject:_factoryId?:productId forKey:@"FactoryId"];
  
            
    [self reloadMessage:self.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:0];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDistrict:) name:@"passParm-0" object:nil];
}
-(void)getDistrict:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    _selectedDistrictId =dict[@"parms"];
    _factoryId  =dict[@"factoryId"];
    
    
    //判断选中的时间不能大于当前时间
    NSDate *currentDate = [self.formatter dateFromString:[Units getNowDate:0]];
    if (_endTimeString.length) {
        NSDate *selectDate = [self.formatter dateFromString:_endTimeString];
        NSComparisonResult result = [selectDate compare:currentDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"结束时间不能大于当前时间"];
            return;
        }
    }
    //判断时间 结束时间不能小于结束时间
    if (_benginTimeString.length &&_endTimeString.length) {
        NSDate * startDate = [self.formatter dateFromString:_benginTimeString];
        NSDate * endDate = [self.formatter dateFromString:_endTimeString];
        NSComparisonResult result = [startDate compare:endDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"开始时间不能大于结束时间"];
            return;
        }
    }
   [self.mutableParms setObject:_benginTimeString?:[Units getNowDate:-7] forKey:@"StartTime"];
    [self.mutableParms setObject:_endTimeString?:[Units getNowDate:0] forKey:@"EndTime"];
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    NSString *productId  =moudleStatus.FactoryList[0][@"FactoryId"]?:@"";
    [self.mutableParms setObject:_factoryId?:productId forKey:@"FactoryId"];

    //排除不限选项
    if (![_selectedDistrictId isEqualToString:@"不限"]) {
        [self.mutableParms setObject:_selectedDistrictId?:@"" forKey:@"DistrictName"];
        
    }
    debugLog(@" - - -%@",self.mutableParms);
    [self reloadMessage:self.mutableParms url:[DeviceWholeMessageURL getWholeUrl] flag:0];
    
            
    
}
//-(void)getTime:(NSNotification*)notification{
//    debugLog(@"- - -%@",[notification object]);
//}

-(void)getParms:(NSNotification*)notification{
   // NSDictionary * dict =[notification object];
    
    
}
@end
