//
//  DeviceCorrectionTaskListModel.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectionTaskListModel.h"

@implementation DeviceCorrectionTaskListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    _TaskStatusStr  = [self getTaskStatus];
    _Remark =_Remark?:@"";
    _FacilityName=_FacilityName?:@"";
    
}

-(NSString *)getTaskStatus{
    NSString *statusStr;
    switch (self.TaskStatus) {
        case -1:
            statusStr =@"驳回";
            break;
        case 0:
            statusStr =@"待接单";
            break;
        case 1:
            statusStr =@"处理中";
            break;
        case 2:
            statusStr =@"待复核";
            break;
        case 3:
            statusStr =@"已结单";
        default:
            break;
    }
    return statusStr;
}
@end
