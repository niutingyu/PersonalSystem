//
//  DESearchSortController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchSortController.h"

@interface DESearchSortController ()

@end

@implementation DESearchSortController

- (void)viewDidLoad {
    [super viewDidLoad];
    //积分
    _filterTimeView.beginTimeTextField.text =[NSString stringWithFormat:@"开始时间:%@",[Units getNowDate:0]];
    _filterTimeView.endTimeTextField.text =[NSString stringWithFormat:@"结束时间:%@",[Units getNowDate:0]];
    [self.mutableParms setObject:[Units getNowDate:0] forKey:@"StartTime"];
    [self.mutableParms setObject:[Units getNowDate:0] forKey:@"EndTime"];
    [self reloadMessage:self.mutableParms url:[DeviceSortURL getWholeUrl] flag:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getParms:) name:@"passParm-4" object:nil];
    
}
-(void)getParms:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    _selectedDistrictId = dict[@"parms"];
    
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
    
    //判断选中维修人员id
    if (_selectedDistrictId.length ) {
        [self.mutableParms setObject:_selectedDistrictId forKey:@"UserId"];
    }
    //重新请求网络
    [self reloadMessage:self.mutableParms url:[DeviceSortURL getWholeUrl] flag:4];
}


@end
