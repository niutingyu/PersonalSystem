//
//  DESearchErrorController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchErrorController.h"

@interface DESearchErrorController ()

@end

@implementation DESearchErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    //异常
    _filterTimeView.beginTimeTextField.text =[NSString stringWithFormat:@"开始时间:%@",[Units getNowDate:-4]];
    _filterTimeView.endTimeTextField.text =[NSString stringWithFormat:@"结束时间:%@",[Units getNowDate:0]];
    [self.mutableParms setObject:[Units getNowDate:-4] forKey:@"StartTime"];
    [self.mutableParms setObject:[Units getNowDate:0] forKey:@"EndTime"];
    [self reloadMessage:self.mutableParms url:[DeviceErrorURL getWholeUrl] flag:2];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTime:) name:@"passTime" object:nil];
}


-(void)getTime:(NSNotification*)notification{
    debugLog(@"- - -%@",[notification object]);
}
@end
