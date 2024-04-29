//
//  DEUnfinishDetailController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/15.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishDetailController : DeviceBaseController

@property (nonatomic,copy)NSString * maintainId;

@property (nonatomic,copy)NSString * controllerType;//点检保养 设备维修

@property (nonatomic,copy)void(^sucessInternetBlock)(void);

@end

NS_ASSUME_NONNULL_END
