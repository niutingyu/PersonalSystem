//
//  DeviceRepairChosItemController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/15.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceRepairChosItemController : DeviceBaseController
@property (nonatomic,copy)void(^moudleArrayBlock)(NSMutableArray *moudleArray);
@property (nonatomic,strong)NSMutableArray * moudleArray;

@property (nonatomic,copy)NSString * typeController;

@property (nonatomic,copy)NSString * maintainToolType;//维修工具管理

@end

NS_ASSUME_NONNULL_END
