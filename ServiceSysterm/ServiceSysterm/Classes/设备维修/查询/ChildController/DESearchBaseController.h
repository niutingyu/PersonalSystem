//
//  DESearchBaseController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "DETimeFilterView.h"
#import "ZHPickView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DESearchBaseController : DeviceBaseController<UITextFieldDelegate,ZHPickViewDelegate>{
    NSString * _selectedString;
    DETimeFilterView * _filterTimeView;
    NSString * _benginTimeString;
    NSString * _endTimeString;
    NSString * _selectedDistrictId;//区域id
     NSString *_factoryId;//工厂个Id
}
-(void)reloadMessage:(NSMutableDictionary*)parms url:(NSString*)urlString flag:(NSInteger)flag;
@property (nonatomic,strong)NSMutableDictionary * mutableParms;
@end

NS_ASSUME_NONNULL_END
