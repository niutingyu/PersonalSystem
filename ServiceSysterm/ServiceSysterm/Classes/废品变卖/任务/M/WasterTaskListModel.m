//
//  WasterTaskListModel.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterTaskListModel.h"

@implementation WasterTaskListModel


-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    NSInteger flows  =[_FlowStatus intValue];
    switch (flows) {
        case 0:
            _flowStautsStr  =@"待废品组长审核";
            break;
        case 1:
            _flowStautsStr  =@"待人政审核";
            break;
        case 2:
            _flowStautsStr =@"待门卫审核";
            break;
        case 3:
            _flowStautsStr =@"已出厂-待对账";
            break;
        case 4:
            _flowStautsStr =@"待确认收款";
            break;
        case 5:
            _flowStautsStr =@"待冲销";
            break;
        case 6:
            _flowStautsStr =@"已结单";
            break;
        case 10:
            _flowStautsStr =@"驳回待修改";
            break;
        case 15:
            _flowStautsStr =@"收款失败";
            
        default:
            break;
    }
    
}
@end
