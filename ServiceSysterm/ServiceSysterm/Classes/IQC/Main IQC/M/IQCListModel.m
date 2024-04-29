//
//  IQCListModel.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/6.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCListModel.h"

@implementation IQCListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    NSInteger statusIdx  = [_Status intValue];
    switch (statusIdx) {
        case -1:
            _statusStr =@"作废";
            break;
        case 1:
            _statusStr =@"待检验";
            break;
        case 3:
            _statusStr =@"部分检验";
            break;
        case 5:
            _statusStr =@"待审核";
            break;
        case 11:
            _statusStr =@"全未通过";
            break;
        case 12:
            _statusStr =@"部分通过";
            break;
        case 13:
            _statusStr =@"全部通过";
            
        default:
            break;
    }
    
    NSInteger passIdx  = [_IsUrgentPass intValue];
    switch (passIdx) {
        case 0:
            _IsUrgentPassStr =@"否";
            break;
        case 1:
            _IsUrgentPassStr =@"是";
            
        default:
            break;
    }
    
    NSInteger taskTypeIdx  =[_IQCType intValue];
    switch (taskTypeIdx) {
        case 1:
            _IqcTaskTypeStr =@"收货IQC";
            
            break;
        case 3:
            _IqcTaskTypeStr =@"返检IQC";
         
      
            
        default:
            break;
    }
    
    //根据文字计算高度
    CGFloat cellWidth  = (kScreenWidth-36-4-2)/7;
    _cellHeight  =  [Units calculateRowHeight:_MaterialInfo width:cellWidth+15];
    if (_cellHeight <40) {
        _cellHeight  = 56.0f;
    }
    
    
    
    
    
}


@end
