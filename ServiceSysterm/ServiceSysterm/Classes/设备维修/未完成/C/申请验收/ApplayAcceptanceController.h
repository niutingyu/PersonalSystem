//
//  ApplayAcceptanceController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplayAcceptanceController : DeviceBaseController
@property (nonatomic,copy)NSString * facilityId;//设备配件id
@property (nonatomic,copy)NSString * taskId;
@end

NS_ASSUME_NONNULL_END
