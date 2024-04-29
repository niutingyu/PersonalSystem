//
//  DESearchPushMessageController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchPushMessageController.h"

@interface DESearchPushMessageController ()

@end

@implementation DESearchPushMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _filterTimeView.beginTimeTextField.text = [NSString stringWithFormat:@"开始时间:%@",[Units getNowDate:-4]];
    _filterTimeView.endTimeTextField.text =[NSString stringWithFormat:@"结束时间:%@",[Units getNowDate:0]];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTime:) name:@"passTime" object:nil];
    [self.mutableParms setObject:_benginTimeString?:[Units getNowDate:-4] forKey:@"StartTime"];
    [self.mutableParms setObject:_endTimeString?:[Units getNowDate:0] forKey:@"EndTime"];
    [self.mutableParms setObject:USERDEFAULT_object(@"fname") forKey:@"FName"];
    
    [self reloadMessage:self.mutableParms url:[DevicePushLogURL getWholeUrl] flag:1];
}

-(void)getTime:(NSNotification*)notification{
    debugLog(@"- - -%@",[notification object]);
}

@end
