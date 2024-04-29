//
//  DeviceCorrectionDetailListModel.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectionDetailListModel.h"
#import "DeviceCorrectionOperationArray.h"
#import "DeviceCorrectionUserLogModel.h"
@implementation DeviceCorrectionDetailListModel


+(NSDictionary*)mj_objectClassInArray{
    return @{@"OperateArray":[DeviceCorrectionOperationArray class],@"UserOperateArray":[DeviceCorrectionUserLogModel class]};
}
@end
